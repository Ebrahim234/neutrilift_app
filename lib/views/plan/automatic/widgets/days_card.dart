import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DaysCard extends StatelessWidget {
  final String day;
  final String? workout;
  final VoidCallback onAdd;

  const DaysCard({
    super.key,
    required this.day,
    this.workout,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 16),
      child: Container(
        width: double.infinity,
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: -2,
              offset: Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              spreadRadius: -1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  workout ?? "No workout assigned",
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                ),
              ],
            ),
            GestureDetector(
              onTap: onAdd,
              child: Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: Color(0xffF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, size: 20.sp, color: Color(0xff0D1B2A)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}