import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/views/plan/automatic/widgets/days_card.dart';
import 'package:neutrilift/views/plan/automatic/widgets/review_card.dart';

class ReviewPlanView extends StatelessWidget {
  const ReviewPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(top: 60, start: 16, end: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Review Your Plan",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                "Automatic generated workout program",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff6B7280),
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsetsDirectional.all(16),
                width: double.infinity,
                height: 390,
                decoration: BoxDecoration(
                  color: Color(0xff173273),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ReviewCard(label: 'Duration', value: '12 Weeks'),
                    ReviewCard(label: 'Goal', value: 'Lose weight'),
                    ReviewCard(label: 'Weekly Workouts', value: '5 sessions'),
                    ReviewCard(
                      label: 'Weight to lose',
                      value: '10 kg',
                      isEdit: true,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Plan duration depend on weight you want to lose and number of session per week",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffBFBFBF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
