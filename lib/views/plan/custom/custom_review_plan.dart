import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_back.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/models/routine_model.dart';
import 'package:neutrilift/views/home/pages/view.dart';
import '../../home/pages/home_page/view.dart';
import 'widgets/calorie_paginator.dart';
import 'widgets/review_day_card.dart';
import 'widgets/review_summary_card.dart';
import 'widgets/section_header.dart';

class CustomReviewPlanView extends StatefulWidget {
  final int weekCount;
  final List<Map<String, dynamic>> weeksCalories;
  final Map<int, RoutineModel> assignedDays;
  final List<Map<String, dynamic>> groupsDays;

  const CustomReviewPlanView({
    super.key,
    required this.weekCount,
    required this.weeksCalories,
    required this.assignedDays,
    required this.groupsDays,
  });

  @override
  State<CustomReviewPlanView> createState() => _CustomReviewPlanViewState();
}

class _CustomReviewPlanViewState extends State<CustomReviewPlanView> {
  final dio = ApiHelper.createDio();
  bool isLoading = false;
  int currentCaloriePage = 0;

  static const List<String> _dayNames = [
    'Saturday', 'Sunday', 'Monday', 'Tuesday',
    'Wednesday', 'Thursday', 'Friday',
  ];

  Future<void> _savePlan() async {
    setState(() => isLoading = true);
    try {
      await dio.post('api/plans/', data: {
        'duration': widget.weekCount,
        'type': 'M',
        'weeks_calories': widget.weeksCalories,
        'groups_days': widget.groupsDays,
      });

      showMsg('Plan saved successfully! 🎉');
      goTo(const HomePageView());
    } on DioException catch (e) {
      showMsg(
        e.response?.data?['detail'] ?? 'Failed to save plan',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F0F0),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBack(),
                    SizedBox(height: 8.h),
                    Text(
                      'Review Your Plan',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Everything looks good? Save and start training!',
                      style: TextStyle(
                          color: Colors.grey, fontSize: 13.sp),
                    ),
                    SizedBox(height: 16.h),

                    // ── Summary card ──────────────────────────
                    ReviewSummaryCard(
                      weekCount: widget.weekCount,
                      workoutDays: widget.assignedDays.length,
                    ),
                    SizedBox(height: 16.h),

                    // ── Assign Workouts section ───────────────
                    Row(
                      children: [
                        const Expanded(
                          child: SectionHeader(label: 'Assign Workouts'),
                        ),
                        const Icon(
                          Icons.edit_rounded,
                          color: Color(0xff9CA3AF),
                          size: 18,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    ...List.generate(
                      7,
                          (i) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: ReviewDayCard(
                          dayName: _dayNames[i],
                          routine: widget.assignedDays[i + 1],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ── Calorie target section ────────────────
                    Row(
                      children: [
                        const Expanded(
                          child: SectionHeader(
                              label: 'Your Daily Calorie Target'),
                        ),
                        const Icon(
                          Icons.edit_rounded,
                          color: Color(0xff9CA3AF),
                          size: 18,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    CaloriePaginator(
                      currentPage: currentCaloriePage,
                      totalPages: widget.weekCount,
                      calories: widget.weeksCalories[currentCaloriePage]
                      ['daily_intake_calories'] as int,
                      onPrevious: currentCaloriePage > 0
                          ? () => setState(() => currentCaloriePage--)
                          : null,
                      onNext: currentCaloriePage < widget.weekCount - 1
                          ? () => setState(() => currentCaloriePage++)
                          : null,
                    ),
                  ],
                ),
              ),
            ),

            // ── Save button ───────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: AppButton(
                title: 'Next',
                width: double.infinity,
                isLoading: isLoading,
                onPressed: _savePlan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
