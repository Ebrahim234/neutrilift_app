import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/views/routine/pages/save_routine_dialog.dart';
import '../../../../core/ui/app_back.dart';
import '../../../../core/ui/app_button.dart';
import '../../../../core/ui/app_search.dart';
import '../widgets/selectable_exercise_card.dart';

class SelectExercisesView extends StatefulWidget {
  const SelectExercisesView({super.key});

  @override
  State<SelectExercisesView> createState() => _SelectExercisesViewState();
}

class _SelectExercisesViewState extends State<SelectExercisesView> {
  final Dio dio = ApiHelper.createDio();
  bool isLoading = true;
  List<dynamic> exercisesList = [];

  int selectedCategoryIndex = 0;
  final List<String> categories = ["All", "Chest", "Back", "Legs", "Arms"];
  List<int> selectedExercisesIds = [];

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  // 🚀 جلب التمارين الحقيقية من السيرفر
  Future<void> _fetchExercises() async {
    try {
      final response = await dio.get('/api/exercises/');
      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          exercisesList = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("🔴 FETCH EXERCISES ERROR => $e");
      setState(() => isLoading = false);
      showMsg('Failed to load exercises', isError: true);
    }
  }

  // 🎯 فلترة التمارين ديناميكياً حسب القسم العضلي المختار مع تأمين الـ null
  List<dynamic> get filteredExercises {
    if (selectedCategoryIndex == 0) {
      return exercisesList;
    }
    String targetCategory = categories[selectedCategoryIndex].toLowerCase();
    return exercisesList.where((ex) {
      var muscles = ex['muscles'];
      if (muscles is List && muscles.isNotEmpty) {
        String mName = (muscles[0]['muscle'] ?? '').toString().toLowerCase();
        return mName == targetCategory;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const AppBack(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select Your Workouts", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: const Color(0xff0D1B2A))),
                SizedBox(height: 4.h),
                Text("Choose exercises for your custom plan", style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                SizedBox(height: 16.h),
                const AppSearch(),
                SizedBox(height: 16.h),
              ],
            ),
          ),

          // شريط الفلاتر (All, Chest, Back...)
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedCategoryIndex = index),
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xff1E2D6E) : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),

          // لستة التمارين
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredExercises.isEmpty
                ? const Center(child: Text("No exercises found."))
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final ex = filteredExercises[index];
                int exId = ex['id'] ?? 0;
                bool isSelected = selectedExercisesIds.contains(exId);

                String rawImageUrl = ex['image'] ?? '';
                String fullImageUrl = rawImageUrl.startsWith('http')
                    ? rawImageUrl
                    : '${ApiHelper.baseUrl}$rawImageUrl';

                // 🛡️ حماية تكتيكية لمنع كراش الـ Null تماماً هنا
                String muscleName = 'General';
                var musclesList = ex['muscles'];
                if (musclesList is List && musclesList.isNotEmpty) {
                  muscleName = musclesList[0]['muscle'] ?? 'General';
                }

                return SelectableExerciseCard(
                  imageUrl: fullImageUrl,
                  name: ex['name'] ?? 'Unknown',
                  targetMuscle: muscleName,
                  isSelected: isSelected,
                  onAddTapped: () {
                    setState(() {
                      if (isSelected) {
                        selectedExercisesIds.remove(exId);
                      } else {
                        selectedExercisesIds.add(exId);
                      }
                    });
                  },
                );
              },
            ),
          ),

          // زرار الانتقال لحفظ الروتين مأمن بالـ Objects الكاملة
          Padding(
            padding: EdgeInsets.all(20.w),
            child: AppButton(
              title: "Add exercises",
              width: double.infinity,
              onPressed: () {
                if (selectedExercisesIds.isEmpty) return;

                // 🚀 استخراج كائنات التمارين كاملة بداتا السيرفر لتمريرها للـ Dialog
                List<Map<String, dynamic>> selectedExercisesObjects = exercisesList
                    .where((ex) => selectedExercisesIds.contains(ex['id']))
                    .map((ex) => Map<String, dynamic>.from(ex))
                    .toList();

                showDialog(
                  context: context,
                  builder: (context) => SaveRoutineDialog(selectedExercises: selectedExercisesObjects),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}