import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/ui/app_image.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/week_calender.dart';

class Workout extends StatelessWidget {
  Workout({super.key});

  bool hasWorkout = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasWorkout == false) ...[
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(16),

            height: 70.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                AppImage(image: "no_workout.svg"),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "No workout scheduled for today",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Enjoy your rest day",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff9CA3AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
              height: 80.h,
            decoration: BoxDecoration(
              color: Color(0xff1B3A85),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(top: 16,start: 16,end: 32,bottom: 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Today’s workout",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w700),),
                      SizedBox(height: 2.h,),
                      Text("Pull Day",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w400),),
                    ],
                  ),
                  Spacer(),

                  AppImage(image: "forward.svg",height: 10.h,width: 5.w,)

                ],
              ),
            ),
            ),
        ],
      ],
    );
  }
}
