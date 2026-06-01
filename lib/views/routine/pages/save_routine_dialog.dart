import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import '../../../../core/ui/app_button.dart';
import '../../../../core/logic/helper_method.dart';

class SaveRoutineDialog extends StatefulWidget {
  final List<Map<String, dynamic>> selectedExercises; // استلام كائنات التمارين كاملة
  const SaveRoutineDialog({super.key, required this.selectedExercises});

  @override
  State<SaveRoutineDialog> createState() => _SaveRoutineDialogState();
}

class _SaveRoutineDialogState extends State<SaveRoutineDialog> {
  final TextEditingController nameController = TextEditingController();
  final Dio dio = ApiHelper.createDio();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Save Routine", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: const Color(0xff0D1B2A))),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.grey),
                  style: IconButton.styleFrom(backgroundColor: Colors.grey[200]),
                )
              ],
            ),
            SizedBox(height: 8.h),
            Text("Save your current workout selection to reuse later", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
            SizedBox(height: 24.h),

            Text("Routine Name", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            TextField(
              controller: nameController,
              enabled: !isLoading,
              decoration: InputDecoration(
                hintText: "e.g., Chest Day",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
              ),
            ),
            SizedBox(height: 32.h),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : AppButton(
              title: "Next",
              width: double.infinity,
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  showMsg("Please enter a routine name", isError: true);
                  return;
                }

                setState(() => isLoading = true);

                try {
                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString('access_token');

                  // 🚀 بناء لستة التمارين بشكل مرن وديناميكي حسب نوع كل تمرين
                  List<Map<String, dynamic>> formattedExercises = [];

                  for (int i = 0; i < widget.selectedExercises.length; i++) {
                    var ex = widget.selectedExercises[i];

                    // جملة طباعة لمراقبة محتويات التمرين بالكامل في الـ Console لمعرفة الـ Keys
                    print("🔍 [DEBUG] Exercise at index $i => $ex");

                    String type = (ex['type'] ?? '').toString().toLowerCase();
                    String category = (ex['category'] ?? '').toString().toLowerCase();
                    String name = (ex['name'] ?? '').toString().toLowerCase();

                    // فحص ذكي: هل التمرين كارديو أو بلانك أو جري ويحتاج وقت (Duration)؟
                    bool isDurationBased = type == 'cardio' ||
                        category == 'cardio' ||
                        name.contains('plank') ||
                        name.contains('run') ||
                        ex['requires_duration'] == true;

                    Map<String, dynamic> exercisePayload = {
                      "exercise": ex['id'],
                      "order": i + 1,
                    };

                    if (isDurationBased) {
                      exercisePayload["duration"] = 1; // تعيين الوقت بدلاً من الـ Sets للتمرين الكارديو
                    } else {
                      exercisePayload["sets"] = 4;    // المجموعات الافتراضية لتمارين الحديد والـ Weight lifting
                    }

                    formattedExercises.add(exercisePayload);
                  }

                  final response = await dio.post(
                    '/api/groups/',
                    data: {
                      "name": nameController.text.trim(),
                      "exercises": formattedExercises,
                    },
                    options: Options(
                      validateStatus: (status) => status != null && status < 500,
                      headers: {
                        if (token != null) 'Authorization': 'Bearer $token',
                      },
                    ),
                  );

                  if (response.statusCode == 200 || response.statusCode == 201) {
                    if (mounted) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      showMsg('Routine Saved Successfully!');
                    }
                  }
                  else {
                    print("❌ [BACKEND REJECTION DETAILS] => ${response.data}");
                    showMsg("Validation Error: ${response.statusCode}\n${response.data}", isError: true);
                  }
                } catch (e) {
                  print("🔴 General Catch Error => $e");
                  showMsg("Failed to save routine", isError: true);
                } finally {
                  if (mounted) {
                    setState(() => isLoading = false);
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}