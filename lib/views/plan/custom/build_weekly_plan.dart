import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_back.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/models/routine_model.dart';
import 'widgets/day_assign_card.dart';
import 'widgets/load_preset_sheet.dart';
import 'widgets/section_header.dart';
import 'custom_review_plan.dart';


class BuildWeeklyPlanView extends StatefulWidget {
  final int weekCount;
  final List<Map<String, dynamic>> weeksCalories;
  final List<RoutineModel> savedRoutines;

  const BuildWeeklyPlanView({
    super.key,
    required this.weekCount,
    required this.weeksCalories,
    required this.savedRoutines,
  });

  @override
  State<BuildWeeklyPlanView> createState() => _BuildWeeklyPlanViewState();
}

class _BuildWeeklyPlanViewState extends State<BuildWeeklyPlanView> {
  static const List<String> _dayNames = [
    'Saturday', 'Sunday', 'Monday', 'Tuesday',
    'Wednesday', 'Thursday', 'Friday',
  ];

  late List<RoutineModel> _savedRoutines;
  final Map<int, RoutineModel> _assigned = {};

  @override
  void initState() {
    super.initState();
    _savedRoutines = List.from(widget.savedRoutines);
  }

  void _showLoadPreset(int dayNumber) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => LoadPresetSheet(
        routines: _savedRoutines,
        onLoad: (routine) =>
            setState(() => _assigned[dayNumber] = routine),
      ),
    );
  }

  List<Map<String, dynamic>> get _groupsDays => _assigned.entries
      .map((e) {
    if (e.value.id != null) {
      return {
        'day': e.key,
        'exercise_group': e.value.id,
      };
    } else {
      return {
        'day': e.key,
        'group_name': e.value.name,
      };
    }
  }).toList();

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
                      'Build Your Weekly Plan',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Select Your Workout Days',
                      style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                    ),
                    SizedBox(height: 16.h),

                    const SectionHeader(label: 'Assign Workouts'),
                    SizedBox(height: 12.h),

                    // Day cards
                    ...List.generate(
                      7,
                          (i) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: DayAssignCard(
                          dayName: _dayNames[i],
                          routine: _assigned[i + 1],
                          onTap: () => _showLoadPreset(i + 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Next button
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: AppButton(
                title: 'Next',
                width: double.infinity,
                onPressed: () => goTo(
                  CustomReviewPlanView(
                    weekCount: widget.weekCount,
                    weeksCalories: widget.weeksCalories,
                    assignedDays: _assigned,
                    savedRoutines: _savedRoutines,
                    groupsDays: _groupsDays,
                  ),
                  canPop: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}