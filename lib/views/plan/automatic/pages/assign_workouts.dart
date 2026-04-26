import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/ui/app_back.dart';
import 'package:neutrilift/core/ui/app_button.dart';

import '../widgets/days_card.dart';
import '../widgets/goal_icon.dart';

class AssignWorkoutsView extends StatelessWidget {
  const AssignWorkoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(start: 16,end: 16,bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              AppBack(),
              SizedBox(height: 8),
              Text("Build Your Weekly Plan",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              SizedBox(height: 8),
              Text("Select Your Workout Days",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xff6B7280)),),
              SizedBox(height: 16),
              Row(
                children: [
                  GoalIcon(),
                  SizedBox(width: 8),
                  Text("Assign Workouts",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                ],
              ),
              SizedBox(height: 12.h,),
              DaysCard(day: "Saturday",onAdd: (){},workout: "No workout assigned",),
              DaysCard(day: "Sunday",onAdd: (){},workout: "No workout assigned",),
              DaysCard(day: "Monday",onAdd: (){},workout: "No workout assigned",),
              DaysCard(day: "Tuesday",onAdd: (){},workout: "No workout assigned",),
              DaysCard(day: "Wednesday",onAdd: (){},workout: "No workout assigned",),
              DaysCard(day: "Thursday",onAdd: (){},workout: "No workout assigned",),
              DaysCard(day: "Friday",onAdd: (){},workout: "No workout assigned",),
              AppButton(title: "Next", width: double.infinity, onPressed: (){})

            ],
          ),
        ),
      ),
    );
  }
}
