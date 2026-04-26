import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/core/ui/app_image.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/week_calender.dart';

class NoPlanWidget extends StatelessWidget {
  const NoPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return
Column(
  children: [
  SizedBox(height: 8.h,),
  Container(
  height: 260,
  width: double.infinity,
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // الأيقونة مع الـ + الصغير
      Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xffF0F2F5),
              shape: BoxShape.circle,
            ),
            child: AppImage(image: "plan.svg", height: 32.h, width: 32.w),
          ),
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Color(0xff1A2D6B),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add, size: 16, color: Colors.white),
          ),
        ],
      ),

      SizedBox(height: 12),

      // النص الكبير
      Text(
        "You don't have a plan yet",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xff1A2D6B),
        ),
      ),

      SizedBox(height: 6),

      Text(
        "Create a personalized plan to start \n tracking your weight journey",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),

      SizedBox(height: 16),



      AppButton(title: "Create plan",icon: Icon(Icons.add, color: Colors.white), onPressed: () {},width: double.infinity,)
      // الزرار
      // SizedBox(
      //   width: double.infinity,
      //   child: ElevatedButton.icon(
      //     onPressed: () {},
      //     icon: Icon(Icons.add, color: Colors.white),
      //     label: Text("Create plan", style: TextStyle(color: Colors.white)),
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Color(0xff1A2D6B),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(30),
      //       ),
      //       padding: EdgeInsets.symmetric(vertical: 14),
      //     ),
      //   ),
      // ),
    ],
  ),
)
  ],
);

  }
}
