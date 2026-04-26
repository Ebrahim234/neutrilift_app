import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeekCalender extends StatefulWidget {
   WeekCalender({super.key});

  @override
  State<WeekCalender> createState() => _WeekCalenderState();
}

class _WeekCalenderState extends State<WeekCalender> {
   final List<Map<String, dynamic>> days = [
     {"name": "M", "isWorkout": true},
     {"name": "T", "isWorkout": true},
     {"name": "W", "isWorkout": false},
     {"name": "T", "isWorkout": true},
     {"name": "F", "isWorkout": false},
     {"name": "S", "isWorkout": true},
     {"name": "S", "isWorkout": false},
   ];
int selectedDay = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Week 3 • Tuesday",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),),
              Spacer(),
              Text("4 workouts this week",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xff9CA3AF)),)
            ],
          ),
          SizedBox(height: 8.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < days.length; i++)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = i;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: selectedDay == i
                              ? Color(0xff1A2D6B)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          days[i]["name"],
                          style: TextStyle(
                            color: selectedDay == i ? Colors.white : Color(0xff1A2D6B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: days[i]["isWorkout"]
                              ? Color(0xff1A2D6B)
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
