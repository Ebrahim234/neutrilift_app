import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_back.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/core/ui/app_image.dart';
import 'package:neutrilift/views/plan/automatic/pages/assign_workouts.dart';

import 'package:neutrilift/views/plan/automatic/widgets/selectable_card.dart';
import 'package:neutrilift/views/plan/automatic/widgets/goal_icon.dart';
import 'package:neutrilift/views/plan/automatic/widgets/weight_input.dart';
// متنساش تعمل import لصفحة AssignWorkoutsView هنا

class AutomaticLifeStylView extends StatefulWidget {
  const AutomaticLifeStylView({super.key});

  @override
  State<AutomaticLifeStylView> createState() => _AutomaticLifeStylViewState();
}

class _AutomaticLifeStylViewState extends State<AutomaticLifeStylView> {
  String? selectedGoal;
  String? selectedExerciseType;
  String selectedWeightUnit = "Kg";
  final weightController = TextEditingController();

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(start: 16, end: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              AppBack(),
              SizedBox(height: 16),
              Text("Lifestyle Details", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(
                "Help us personalize your workout plan",
                style: TextStyle(color: Color(0xff6B7280), fontSize: 14, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  GoalIcon(),
                  SizedBox(width: 8),
                  Text("Goal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SelectableCard(
                    image: "gain_weight.svg",
                    goal: "Gain weight",
                    isSelected: selectedGoal == "Gain weight",
                    onTap: () => setState(() => selectedGoal = "Gain weight"),
                  ),
                  SizedBox(width: 16),
                  SelectableCard(
                    image: "lose_weight.svg",
                    goal: "Lose weight",
                    isSelected: selectedGoal == "Lose weight",
                    onTap: () => setState(() => selectedGoal = "Lose weight"),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  AppImage(image: "exercise_type.svg"),
                  SizedBox(width: 8.h),
                  Text("Exercise Type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  SelectableCard(
                    image: "machines.svg",
                    goal: "Machines",
                    isSelected: selectedExerciseType == "Machines",
                    onTap: () => setState(() => selectedExerciseType = "Machines"),
                  ),
                  SizedBox(width: 16.w),
                  SelectableCard(
                    image: "body_weight.svg",
                    goal: "Body Weight",
                    isSelected: selectedExerciseType == "Body Weight",
                    onTap: () => setState(() => selectedExerciseType = "Body Weight"),
                  )
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  GoalIcon(),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "How many kg do you want to lose/gain?",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              WeightInput(
                controller: weightController,
                onUnitChanged: (unit) => setState(() => selectedWeightUnit = unit),
              ),
              SizedBox(height: 100),
              AppButton(
                title: "Next",
                width: double.infinity,
                onPressed: () {
                  if (selectedGoal == null || selectedExerciseType == null || weightController.text.isEmpty) {
                    showMsg('Please fill all details', isError: true); // استخدمنا الهيلبر هنا
                    return;
                  }

                  String apiGoal = selectedGoal == "Gain weight" ? "G" : "L";
                  String apiResistance = selectedExerciseType == "Machines" ? "M" : "B";

                  Map<String, dynamic> planData = {
                    "type": "A",
                    "goal": apiGoal,
                    "amount": weightController.text,
                    "amount_unit": selectedWeightUnit.toLowerCase(),
                    "resistance_type": apiResistance,
                  };

                  // بنخلي canPop بـ true عشان يقدر يرجع للشاشة دي لو حب يعدل
                  goTo(AssignWorkoutsView(planData: planData), canPop: true);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}