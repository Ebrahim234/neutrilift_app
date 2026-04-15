import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/ui/app_image.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/week_calender.dart';

class NoWorkout extends StatelessWidget {
  NoWorkout({super.key});

  bool hasWorkout = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeekCalender(),
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
              Column(children: [
                Text("No workout scheduled for today",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                Text("Enjoy your rest day",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500,color: Color(0xff9CA3AF)),),
              ],)
            ],
          ) ,
        ),
      ],
    );
  }
}
