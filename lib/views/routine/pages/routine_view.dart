import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/views/routine/pages/select_exercises_view.dart';
import '../../../core/ui/app_back.dart';
import '../../workout/pages/workout_view.dart';
import '../widgets/routine_card.dart';

class RoutinesView extends StatefulWidget {
  const RoutinesView({super.key});

  @override
  State<RoutinesView> createState() => _RoutinesViewState();
}

class _RoutinesViewState extends State<RoutinesView> {
  bool isYourRoutines = true;
  bool isLoading = true;
  final Dio dio = ApiHelper.createDio();
  List<dynamic> routinesList = [];

  @override
  void initState() {
    super.initState();
    _fetchRoutines();
  }

  // 1. جلب الروتينات (GET)
  Future<void> _fetchRoutines() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final response = await dio.get(
        '/api/groups/',
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          routinesList = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching routines: $e");
      setState(() {
        routinesList = [
          {"id": 5, "group_name": "upper_body"},
          {"id": 6, "group_name": "Leg Day"},
          {"id": 7, "group_name": "Core Workout"},
        ];
        isLoading = false;
      });
    }
  }

  // 2. 🚀 دالة تعديل اسم الروتين (PUT) بناءً على طلب الباك إند
  Future<void> _updateRoutineName(int id, String currentName) async {
    final TextEditingController editController = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Routine Name"),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(hintText: "Enter new name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              if (editController.text.trim().isEmpty) return;
              Navigator.pop(context);
              setState(() => isLoading = true);

              try {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('access_token');

                // إرسال PUT ومفتاح البيانات هو "name" طبقاً لصورة البوست مان
                final response = await dio.put(
                  '/api/groups/$id/',
                  data: {"name": editController.text.trim()},
                  options: Options(
                    headers: {
                      if (token != null) 'Authorization': 'Bearer $token',
                    },
                  ),
                );

                if (response.statusCode == 200 || response.statusCode == 201) {
                  showMsg("Routine updated successfully!");
                  _fetchRoutines(); // إعادة تحميل الروتينات المحدثة
                }
              } catch (e) {
                setState(() => isLoading = false);
                showMsg("Failed to update routine", isError: true);
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // 3. 🚀 دالة حذف الروتين نهائياً (DELETE) بناءً على طلب الباك إند
  Future<void> _deleteRoutine(int id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Routine"),
        content: const Text("Are you sure you want to delete this routine permanently?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirm) return;
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      // إرسال طلب DELETE المباشر للـ ID المطلوب
      final response = await dio.delete(
        '/api/groups/$id/',
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        showMsg("Routine deleted successfully!");
        _fetchRoutines(); // تحديث القائمة فوراً
      }
    } catch (e) {
      setState(() => isLoading = false);
      showMsg("Failed to delete routine", isError: true);
    }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Workout", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: const Color(0xff0D1B2A))),
            SizedBox(height: 20.h),

            // Toggle Button (Your Routines | Create New)
            Container(
              height: 50.h,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25.r)),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isYourRoutines = true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isYourRoutines ? const Color(0xff1E2D6E) : Colors.transparent,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Center(
                          child: Text(
                            "Your Routines",
                            style: TextStyle(color: isYourRoutines ? Colors.white : Colors.grey, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => goTo(const SelectExercisesView(), canPop: true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isYourRoutines ? const Color(0xff1E2D6E) : Colors.transparent,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Center(
                          child: Text(
                            "Create New",
                            style: TextStyle(color: !isYourRoutines ? Colors.white : Colors.grey, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            Expanded(
              child: routinesList.isEmpty
                  ? const Center(child: Text("No routines found."))
                  : ListView.builder(
                itemCount: routinesList.length,
                itemBuilder: (context, index) {
                  String rawName = routinesList[index]['group_name'] ?? 'Routine';
                  String displayName = rawName.replaceAll('_', ' ');
                  int routineId = routinesList[index]['id'];

                  return RoutineCard(
                    title: displayName,
                    onTap: () {
                      goTo(WorkoutView(groupId: routineId), canPop: true);
                    },
                    // 🚀 ربط أكواد الـ PUT والـ DELETE المضافة مع الكارت
                    onEdit: () => _updateRoutineName(routineId, displayName),
                    onDelete: () => _deleteRoutine(routineId),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}