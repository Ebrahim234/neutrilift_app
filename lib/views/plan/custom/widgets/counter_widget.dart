import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CounterWidget extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const CounterWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 9999,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: value > min ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove),
            iconSize: 18.sp,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            constraints: const BoxConstraints(),
          ),
          SizedBox(
            width: 28.w,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
          ),
          IconButton(
            onPressed: value < max ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add),
            iconSize: 18.sp,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}