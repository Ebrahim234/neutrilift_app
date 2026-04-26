import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/ui/app_image.dart';

class GoalIcon extends StatelessWidget {
  const GoalIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        color: Color(0xff1B3A85),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(child: AppImage(image: "goal.svg",width: 16.w,height: 16.h,)),
    );
  }
}
