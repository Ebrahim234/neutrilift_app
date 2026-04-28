import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CaloriePaginator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int calories;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const CaloriePaginator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.calories,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            'WEEK ${currentPage + 1}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '$calories',
            style: TextStyle(
              fontSize: 40.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xff173272),
            ),
          ),
          Text(
            'cal / day',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onPrevious,
                icon: const Icon(Icons.chevron_left),
                color: const Color(0xff173272),
                disabledColor: Colors.grey.shade300,
              ),
              IconButton(
                onPressed: onNext,
                icon: const Icon(Icons.chevron_right),
                color: const Color(0xff173272),
                disabledColor: Colors.grey.shade300,
              ),
            ],
          ),
        ],
      ),
    );
  }
}