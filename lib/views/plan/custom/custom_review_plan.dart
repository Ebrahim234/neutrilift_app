import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_back.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/models/routine_model.dart';
import 'package:neutrilift/views/home/pages/view.dart';
import 'widgets/calorie_paginator.dart';
import 'widgets/review_day_card.dart';
import 'widgets/review_summary_card.dart';
import 'widgets/section_header.dart';

class CustomReviewPlanView extends StatefulWidget {
  final int weekCount;
  final List<Map<String, dynamic>> weeksCalories;
  final Map<int, RoutineModel> assignedDays;
  final List<RoutineModel> savedRoutines;
  final List<Map<String, dynamic>> groupsDays;

  const CustomReviewPlanView({
    super.key,
    required this.weekCount,
    required this.weeksCalories,
    required this.assignedDays,
    required this.savedRoutines,
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: const BoxDecoration(
                  color: Color(0xff22C55E),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 40.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Plan Saved!',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff173272),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: const Color(0xffF3F4F6),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.fitness_center_rounded,
                                  size: 16.sp,
                                  color: const Color(0xff173272)),
                              SizedBox(width: 4.w),
                              Text(
                                'Frequency',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${widget.assignedDays.length} days/week',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: const Color(0xffF3F4F6),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_month_rounded,
                                  size: 16.sp,
                                  color: const Color(0xff173272)),
                              SizedBox(width: 4.w),
                              Text(
                                'Duration',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${widget.weekCount} weeks',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              AppButton(
                title: 'Back to Homepage',
                width: double.infinity,
                onPressed: () {
                  Navigator.pop(context);
                  goTo(const HomeView());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _savePlan() async {
    setState(() => isLoading = true);
    try {
      final uniqueRoutines = widget.savedRoutines.toSet().toList();

      final data = <String, dynamic>{
        'duration': widget.weekCount,
        'type': 'M',
        'weeks_calories': widget.weeksCalories.map((w) => {
          'week_number': (w['week_number'] as num).toInt(),
          'daily_intake_calories': (w['daily_intake_calories'] as num).toInt(),
        }).toList(),
        'groups_days': widget.groupsDays,
      };

      if (uniqueRoutines.isNotEmpty) {
        data['groups'] = uniqueRoutines.map((r) => {
          'name': r.name,
          'exercises': r.exercises
              .asMap()
              .entries
              .map((e) => e.value.toJson(order: e.key + 1))
              .toList(),
        }).toList();
      }

      await dio.post('/api/plans/', data: data);

      _showSuccessDialog(); // ✅
    } on DioException catch (e) {
      String errorMessage = 'Failed to save plan';

      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMessage = e.response!.data['detail'] ?? errorMessage;
        } else if (e.response!.data is List && e.response!.data.isNotEmpty) {
          errorMessage = e.response!.data[0].toString();
        }
      }

      showMsg(errorMessage, isError: true);
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
                      style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                    ),
                    SizedBox(height: 16.h),

                    ReviewSummaryCard(
                      weekCount: widget.weekCount,
                      workoutDays: widget.assignedDays.length,
                    ),
                    SizedBox(height: 16.h),

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

            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: AppButton(
                title: 'Save Plan',
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