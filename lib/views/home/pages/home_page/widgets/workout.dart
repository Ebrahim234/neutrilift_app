import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import '../../../../workout/pages/workout_view.dart';
import '../home_model.dart';

class Workout extends StatelessWidget {
  final HomeModel? homeData;

  const Workout({super.key, this.homeData});

  @override
  Widget build(BuildContext context) {
    int todayWeekday = DateTime.now().weekday;

    final todayWorkout = homeData?.exerciseDays?.firstWhere(
      (e) => e.day == todayWeekday,
      orElse: () => ExerciseDay(day: null),
    );

    bool isWorkoutToday =
        todayWorkout != null &&
        todayWorkout.day != null &&
        homeData?.dayStatus != "off";

    if (!isWorkoutToday) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: const BoxDecoration(
                color: Color(0xffF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.nightlight_round,
                color: const Color(0xff9CA3AF),
                size: 24.r,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No workout scheduled for today",
                    style: TextStyle(
                      color: const Color(0xff1A2D6B),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Enjoy your rest day",
                    style: TextStyle(
                      color: const Color(0xff9CA3AF),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: () {
        final int? currentGroupId = todayWorkout?.groupId;

        if (currentGroupId != null) {
          goTo(
            WorkoutView(
              groupId:
                  currentGroupId,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("🔴 No Workout ID found for today!")),
          );
        }
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xff1A2D6B),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today’s workout",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    todayWorkout?.groupName ?? "Workout Day",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 16.r,
            ),
          ],
        ),
      ),
    );
  }
}
