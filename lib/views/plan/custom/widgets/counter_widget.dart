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
      height: 36.h,
      decoration: BoxDecoration(
        color: const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ GestureDetector بدل IconButton — مفيش constraints مشاكل
          GestureDetector(
            onTap: value > min ? () => onChanged(value - 1) : null,
            child: Container(
              width: 36.w,
              height: 36.h,
              alignment: Alignment.center,
              child: Icon(
                Icons.remove,
                size: 18.sp,
                color: value > min ? const Color(0xff173272) : Colors.grey,
              ),
            ),
          ),

          SizedBox(
            width: 32.w,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
          ),

          GestureDetector(
            onTap: value < max ? () => onChanged(value + 1) : null,
            child: Container(
              width: 36.w,
              height: 36.h,
              alignment: Alignment.center,
              child: Icon(
                Icons.add,
                size: 18.sp,
                color: value < max ? const Color(0xff173272) : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}