import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/ui/app_back.dart';
import 'package:neutrilift/models/progress_model.dart';
import 'widgets/weekly_log_card.dart';
import 'widgets/summary_cards.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  final dio = ApiHelper.createDio();
  bool isLoading = true;
  ProgressOverviewModel? progressData;

  @override
  void initState() {
    super.initState();
    _fetchProgressData();
  }

  Future<void> _fetchProgressData() async {
    try {
      // 🚨 اتأكد إن مسار الـ API ده مطابق للي عندك
      final response = await dio.get('/api/weeks_overview/');

      setState(() {
        progressData = ProgressOverviewModel.fromJson(response.data);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching progress: $e');
      setState(() {
        isLoading = false;
      });
      // هنا ممكن تظهر رسالة Error لليوزر
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F0F0),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xff173272)))
            : progressData == null || progressData!.weeks.isEmpty
            ? const Center(child: Text("No progress data available yet."))
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    // هناخد داتا الأسبوع الأول كبداية (أو الأسبوع الحالي لو الباك إند بيبعت كذا أسبوع)
    final currentWeek = progressData!.weeks.first;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBack(),
          SizedBox(height: 12.h),
          Text(
            'Progress',
            style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Text(
            'Track your body and Nutrition Progress',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 24.h),

          WeeklyLogCard(
            exerciseDays: progressData!.exerciseDays,
            missedDaysStr: currentWeek.missedDays,
          ),
          SizedBox(height: 24.h),

          Text(
            'Week ${currentWeek.weekNumber} summary',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12.h),

          WeightSummaryCard(weekData: currentWeek),
          SizedBox(height: 12.h),
          CaloriesSummaryCard(weekData: currentWeek),
          SizedBox(height: 12.h),
          SleepSummaryCard(weekData: currentWeek),
        ],
      ),
    );
  }
}