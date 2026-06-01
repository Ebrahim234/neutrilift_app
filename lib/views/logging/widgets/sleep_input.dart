import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SleepInput extends StatelessWidget {
  final String label;
  final String time;
  final VoidCallback onTap;

  const SleepInput({
    super.key,
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xff94A3B8),
            ),
          ),
          SizedBox(height: 8.h),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              height: 55.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xffF3F4F6),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff1E293B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}