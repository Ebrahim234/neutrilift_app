import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/models/routine_model.dart';

class ReviewDayCard extends StatelessWidget {
  final String dayName;
  final RoutineModel? routine;

  const ReviewDayCard({
    super.key,
    required this.dayName,
    required this.routine,
  });

  @override
  Widget build(BuildContext context) {
    final hasRoutine = routine != null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          // icon
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: hasRoutine
                  ? const Color(0xff173272)
                  : const Color(0xffE8EAF0),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              hasRoutine
                  ? Icons.fitness_center_rounded
                  : Icons.nightlight_round,
              color: hasRoutine ? Colors.white : const Color(0xff9CA3AF),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),

          // day name + routine name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dayName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                hasRoutine ? routine!.name : 'Rest Day',
                style: TextStyle(
                  color: hasRoutine
                      ? const Color(0xff173272)
                      : Colors.grey,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}