import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/models/routine_model.dart';

class DayAssignCard extends StatelessWidget {
  final String dayName;
  final RoutineModel? routine;
  final VoidCallback onTap;

  const DayAssignCard({
    super.key,
    required this.dayName,
    required this.routine,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasRoutine = routine != null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dayName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                hasRoutine ? routine!.name : 'No workout assigned',
                style: TextStyle(
                  color: hasRoutine ? const Color(0xff173272) : Colors.grey,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 36.w,
              height: 36.h,
              decoration: const BoxDecoration(
                color: Color(0xffF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasRoutine ? Icons.edit_rounded : Icons.add,
                size: 18.sp,
                color: const Color(0xff173272),
              ),
            ),
          ),
        ],
      ),
    );
  }
}