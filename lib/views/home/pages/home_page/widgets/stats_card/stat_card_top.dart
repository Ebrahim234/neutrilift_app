import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/ui/app_image.dart';

class StatCardTop extends StatelessWidget {
  final String icon;
  final int value;
  final String unit;
  final String label;

  const StatCardTop({
    super.key,
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92.w,
      height: 96.h,
      padding: EdgeInsetsDirectional.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImage(image: icon, height: 24.h, width: 24.w),
          SizedBox(height: 8.h),
          Text("$value",style:TextStyle(
            color: Color(0xff1B3A85),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),),
          Text(
            unit,
            style: TextStyle(
              color: Color(0xff999999),
              fontSize: 8,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(label,style: TextStyle(
            color: Color(0xff626566),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),),
        ],
      ),
    );
  }
}
