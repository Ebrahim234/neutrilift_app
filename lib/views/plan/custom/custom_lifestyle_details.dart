import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_back.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'widgets/section_header.dart';
import 'widgets/week_calorie_card.dart';
import 'widgets/white_input.dart';
import 'select_workouts.dart';

class CustomLifestyleDetailsView extends StatefulWidget {
  const CustomLifestyleDetailsView({super.key});

  @override
  State<CustomLifestyleDetailsView> createState() =>
      _CustomLifestyleDetailsViewState();
}

class _CustomLifestyleDetailsViewState
    extends State<CustomLifestyleDetailsView> {
  final weeksController = TextEditingController();
  int weekCount = 0;
  List<TextEditingController> calorieControllers = [];

  @override
  void dispose() {
    weeksController.dispose();
    for (final c in calorieControllers) c.dispose();
    super.dispose();
  }

  void _onWeeksChanged(String val) {
    final n = int.tryParse(val) ?? 0;
    if (n == weekCount) return;

    for (final c in calorieControllers) c.dispose();

    final newControllers =
    List.generate(n, (_) => TextEditingController(text: ''));
    for (final c in newControllers) {
      c.addListener(() => setState(() {}));
    }

    setState(() {
      weekCount = n;
      calorieControllers = newControllers;
    });
  }

  void _applyCaloriesToNext(int fromIndex, int applyCount) {
    final calories = calorieControllers[fromIndex].text;
    for (int i = fromIndex + 1;
    i <= fromIndex + applyCount && i < weekCount;
    i++) {
      calorieControllers[i].text = calories;
    }
  }

  bool get _isValid {
    if (weekCount == 0) return false;
    for (final c in calorieControllers) {
      final v = int.tryParse(c.text) ?? 0;
      if (v <= 0) return false;
    }
    return true;
  }

  List<Map<String, dynamic>> get _weeksCalories => List.generate(
    weekCount,
        (i) => {
      'week_number': i + 1,
      'daily_intake_calories':
      int.tryParse(calorieControllers[i].text) ?? 0,
    },
  );

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
                      'Lifestyle Details',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    const SectionHeader(label: 'Plan Duration'),
                    SizedBox(height: 10.h),
                    WhiteInput(
                      hint: 'Number of weeks',
                      controller: weeksController,
                      keyboardType: TextInputType.number,
                      onChanged: _onWeeksChanged,
                    ),
                    SizedBox(height: 16.h),

                    if (weekCount > 0) ...[
                      const SectionHeader(
                          label: 'Your daily calorie target per week'),
                      SizedBox(height: 10.h),
                      ...List.generate(
                        weekCount,
                            (i) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: WeekCalorieCard(
                            key: ValueKey(i),
                            weekNumber: i + 1,
                            calorieController: calorieControllers[i],
                            showCopyButton: i < weekCount - 1,
                            maxApply: weekCount - i - 1,
                            onApply: (applyCount) =>
                                _applyCaloriesToNext(i, applyCount),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: AppButton(
                title: 'Next',
                width: double.infinity,
                onPressed: _isValid
                    ? () => goTo(
                  SelectWorkoutsView(
                    weekCount: weekCount,
                    weeksCalories: _weeksCalories,
                  ),
                  canPop: true,
                )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
