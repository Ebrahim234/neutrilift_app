import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/ui/app_button.dart'; // مسار الـ AppButton

class WorkoutEndedDialog extends StatelessWidget {
  final int exercisesCount;
  final String duration;

  const WorkoutEndedDialog({
    super.key,
    required this.exercisesCount,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: const BoxDecoration(color: Color(0xFF00BFA5), shape: BoxShape.circle),
              child: Icon(Icons.check, color: Colors.white, size: 40.sp),
            ),
            SizedBox(height: 16.h),
            Text("Workout Ended!", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xff0D1B2A))),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(12.r)),
                    child: Column(
                      children: [
                        Text("No. of exercises", style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                        SizedBox(height: 4.h),
                        Text("$exercisesCount Exercises", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: const Color(0xff1E2D6E))),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(12.r)),
                    child: Column(
                      children: [
                        Text("Duration", style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                        SizedBox(height: 4.h),
                        Text(duration, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: const Color(0xff1E2D6E))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            // ✅ استخدمنا AppButton
            AppButton(
              title: "Back to Homepage",
              width: double.infinity,
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            )
          ],
        ),
      ),
    );
  }
}