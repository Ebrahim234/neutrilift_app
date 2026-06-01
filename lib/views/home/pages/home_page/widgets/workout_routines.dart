import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/core/ui/app_image.dart';

import '../../../../../core/logic/helper_method.dart';
import '../../../../routine/pages/routine_view.dart';

class WorkoutRoutines extends StatelessWidget {
  const WorkoutRoutines({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // أيقونة الدامبل بخلفية كحلي
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: const Color(0xff1E2D6E),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: AppImage(
                    image: "workout.svg", // تأكد إن اسم أيقونة الدامبل صح عندك في الـ assets
                    width: 24.w,
                    height: 24.h,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // النصوص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Workout Routines",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff0D1B2A),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "View, Start, Create Your Routines",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          AppButton(
            title: "View My Routines",
            width: double.infinity,
            icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            onPressed: () {
             goTo(const RoutinesView(), canPop: true);
            },
          ),
        ],
      ),
    );
  }
}