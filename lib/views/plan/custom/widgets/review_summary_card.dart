import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewSummaryCard extends StatelessWidget {
  final int weekCount;
  final int workoutDays;

  const ReviewSummaryCard({
    super.key,
    required this.weekCount,
    required this.workoutDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xff173272),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Duration', value: '$weekCount weeks'),
          SizedBox(height: 8.h),
          _SummaryRow(label: 'Weekly Workouts', value: '$workoutDays sessions'),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.edit_rounded,
            color: Colors.white54,
            size: 18,
          ),
        ],
      ),
    );
  }
}