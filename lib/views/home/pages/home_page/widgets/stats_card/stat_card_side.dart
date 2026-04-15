import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/ui/app_image.dart';

class StatCardSide extends StatelessWidget {
  final String icon;
  final num value;
  final String unit;
  final String label;

  const StatCardSide({
    super.key,
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(8),
      height: 52.h,
      width: 144.w,
      decoration: BoxDecoration(
        color: Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(

        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppImage(image: icon,height: 24.h,width: 24.w,),
          SizedBox(width: 8.w),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    "$value",
                    style: TextStyle(
                      color: Color(0xff1B3A85),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    unit,
                    style: TextStyle(
                      color: Color(0xff999999),
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Text(
                label,
                style: TextStyle(
                  color: Color(0xff626566),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
