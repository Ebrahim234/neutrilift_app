import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ ضفنا الـ SharedPreferences
import 'package:neutrilift/views/authentication/login.dart'; // ✅ ضفنا الـ LoginView للتوكن المؤقت
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_back.dart';
import 'package:neutrilift/core/ui/app_button.dart';

import '../../../../core/logic/api_helper.dart';
import '../widgets/days_card.dart';
import '../widgets/goal_icon.dart';
import 'generating_paln.dart';

class AssignWorkoutsView extends StatefulWidget {
  final Map<String, dynamic> planData;
  final bool isEditMode;

  const AssignWorkoutsView({
    super.key,
    required this.planData,
    this.isEditMode = false,
  });

  @override
  State<AssignWorkoutsView> createState() => _AssignWorkoutsViewState();
}

class _AssignWorkoutsViewState extends State<AssignWorkoutsView> {
  final Dio dio = ApiHelper.createDio();

  bool isLoadingGroups = true;
  List<dynamic> exerciseGroups = [];
  List<int> selectedDaysOnly = [];
  Map<int, int> assignedWorkouts = {};

  final List<Map<String, dynamic>> displayDays = [
    {"name": "Saturday", "id": 6},
    {"name": "Sunday", "id": 7},
    {"name": "Monday", "id": 1},
    {"name": "Tuesday", "id": 2},
    {"name": "Wednesday", "id": 3},
    {"name": "Thursday", "id": 4},
    {"name": "Friday", "id": 5},
  ];

  @override
  void initState() {
    super.initState();
    _fetchExerciseGroups();
    _prefillExistingData();
  }

  void _prefillExistingData() {
    if (widget.planData.containsKey('exercise_days')) {
      List days = widget.planData['exercise_days'];
      selectedDaysOnly = days.map<int>((e) => e['day'] as int).toList();
    }
    if (widget.planData.containsKey('groups_days')) {
      List groupsDays = widget.planData['groups_days'];
      for (var item in groupsDays) {
        assignedWorkouts[item['day']] = item['exercise_group'];
      }
    }
  }

  Future<void> _fetchExerciseGroups() async {
    try {
      // ✅ سحب التوكن وحقنه صراحة في الهيدر
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? LoginView.tempAccessToken;

      final response = await dio.get(
        '/api/groups/',
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          exerciseGroups = response.data;
          isLoadingGroups = false;
        });
      }
    } catch (e) {
      setState(() => isLoadingGroups = false);
      showMsg('Failed to load workouts!', isError: true);
    }
  }

  void _showExerciseSelection(int dayId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: exerciseGroups.length,
          itemBuilder: (context, index) {
            final group = exerciseGroups[index];
            return ListTile(
              title: Text(group['group_name']),
              onTap: () {
                setState(() => assignedWorkouts[dayId] = group['id']);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: isLoadingGroups
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsetsDirectional.only(start: 16, end: 16, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              const AppBack(),
              const SizedBox(height: 8),
              const Text("Build Your Weekly Plan", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Select Your Workout Days", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff6B7280))),
              const SizedBox(height: 16),

              const Row(
                children: [
                  GoalIcon(),
                  SizedBox(width: 8),
                  Text("Assign Workouts", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
              SizedBox(height: 12.h),

              ...displayDays.map((dayObj) {
                final dayId = dayObj['id'];
                final dayName = dayObj['name'];

                String workoutText = "No workout assigned";
                bool isSelected = false;

                if (exerciseGroups.isEmpty) {
                  if (selectedDaysOnly.contains(dayId)) {
                    workoutText = "Selected";
                    isSelected = true;
                  }
                } else {
                  if (assignedWorkouts.containsKey(dayId)) {
                    final groupId = assignedWorkouts[dayId];
                    final group = exerciseGroups.firstWhere((g) => g['id'] == groupId);
                    workoutText = group['group_name'];
                    isSelected = true;
                  }
                }

                return DaysCard(
                  day: dayName,
                  workout: workoutText,
                  isReview: false,
                  isSelected: isSelected,
                  onAdd: () {
                    if (exerciseGroups.isEmpty) {
                      setState(() {
                        if (selectedDaysOnly.contains(dayId)) {
                          selectedDaysOnly.remove(dayId);
                        } else {
                          selectedDaysOnly.add(dayId);
                        }
                      });
                    } else {
                      _showExerciseSelection(dayId);
                    }
                  },
                );
              }),

              SizedBox(height: 20.h),

              AppButton(
                  title: widget.isEditMode ? "Regenerate" : "Generate Plan",
                  width: double.infinity,
                  onPressed: () {
                    Map<String, dynamic> finalPlanData = Map.from(widget.planData);

                    if (exerciseGroups.isEmpty) {
                      if (selectedDaysOnly.isEmpty) {
                        showMsg("Please select at least one day", isError: true);
                        return;
                      }
                      finalPlanData["exercise_days"] = selectedDaysOnly.map((id) => {"day": id}).toList();
                    } else {
                      if (assignedWorkouts.isEmpty) {
                        showMsg("Please assign at least one workout", isError: true);
                        return;
                      }
                      finalPlanData["groups_days"] = assignedWorkouts.entries.map((entry) => {
                        "day": entry.key,
                        "exercise_group": entry.value
                      }).toList();
                    }

                    goTo(GeneratingPlanView(finalPlanData: finalPlanData), canPop: true);
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}