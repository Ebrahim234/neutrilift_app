import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/views/logging/pages/meal_logging.dart';
import 'package:neutrilift/views/logging/pages/sleep_logging.dart';
import 'package:neutrilift/views/logging/widgets/choice_card.dart';

class LoggingView extends StatelessWidget {
  const LoggingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(top: 100, start: 16, end: 16, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Log your sleep and meals",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h,),
              Text("Help us personalize your workout plan",style: TextStyle(color: Color(0xff6B7280), fontSize: 14, fontWeight: FontWeight.w400)),
              SizedBox(height: 16.h,),
              ChoiceCard(label: "Meal", description: "Log your meals", onPressed: () {goTo(MealLoggingView());},),
              ChoiceCard(label: "Sleep", description: "Log your sleep duration",onPressed: (){goTo(SleepLoggingView());},),
            ],
          ),
        ),
      ),
    );
  }
}
