import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/models/progress_model.dart';

class WeightSummaryCard extends StatelessWidget {
  final WeekSummaryModel weekData;
  const WeightSummaryCard({super.key, required this.weekData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xff173272),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weight', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                weekData.weight,
                style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4.w),
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Text('kg', style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CaloriesSummaryCard extends StatelessWidget {
  final WeekSummaryModel weekData;
  const CaloriesSummaryCard({super.key, required this.weekData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xff173272),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Calories consumed', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
          SizedBox(height: 4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${weekData.sumConsumedCalories.toInt()}', style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold)),
              Text(' / ${weekData.sumTargetCalories.toInt()} kcal', style: TextStyle(color: Colors.white70, fontSize: 13.sp)),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildMacroBar('Protein', weekData.sumProtein, weekData.targetProtein),
              SizedBox(width: 16.w),
              _buildMacroBar('Carbs', weekData.sumCarbs, weekData.targetCarbs),
              SizedBox(width: 16.w),
              _buildMacroBar('Fats', weekData.sumFats, weekData.targetFats),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBar(String name, double current, double total) {
    final double percent = total > 0 ? (current / total).clamp(0.0, 1.0) : 0.0;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(color: Colors.white70, fontSize: 11.sp)),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: current.toInt().toString(), style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.bold)),
                    TextSpan(text: '/${total.toInt()}g', style: TextStyle(color: Colors.white70, fontSize: 10.sp)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation(Colors.white),
            borderRadius: BorderRadius.circular(4.r),
            minHeight: 4.h,
          ),
        ],
      ),
    );
  }
}

class SleepSummaryCard extends StatelessWidget {
  final WeekSummaryModel weekData;
  const SleepSummaryCard({super.key, required this.weekData});

  @override
  Widget build(BuildContext context) {
    final double sleepTarget = 8.0;
    final double percent = (weekData.avgSleepHours / sleepTarget).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xff173272),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Average sleep', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
          SizedBox(height: 4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${weekData.avgSleepHours.toStringAsFixed(1)} h', style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold)),
              Text(' / $sleepTarget h target', style: TextStyle(color: Colors.white70, fontSize: 13.sp)),
            ],
          ),
          SizedBox(height: 12.h),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation(Colors.white),
            borderRadius: BorderRadius.circular(4.r),
            minHeight: 4.h,
          ),
        ],
      ),
    );
  }
}