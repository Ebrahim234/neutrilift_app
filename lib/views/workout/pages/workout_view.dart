import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import '../../../../core/logic/api_helper.dart';
import '../../../../core/logic/helper_method.dart';
import '../../../../core/ui/app_back.dart';
import '../../../../core/ui/app_button.dart';
import '../widgets/active_workout_bar.dart';
import '../widgets/exercise_card.dart';
import 'exercise_detail_sheet.dart';
import 'workout_ended_dialog.dart';

class WorkoutView extends StatefulWidget {
  final int groupId;

  const WorkoutView({super.key, required this.groupId});

  @override
  State<WorkoutView> createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  final Dio dio = ApiHelper.createDio();
  bool isLoading = true;
  Map<String, dynamic>? groupData;
  List<dynamic> exercises = [];

  bool isWorkoutActive = false;
  int secondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchGroupDetails();
  }

  Future<void> _fetchGroupDetails() async {
    try {
      final response = await dio.get('/api/groups/${widget.groupId}');
      if (response.statusCode == 200) {
        setState(() {
          groupData = response.data;
          exercises = response.data['exercises'] ?? [];
          exercises.sort((a, b) => (a['order'] as int).compareTo(b['order'] as int));
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      // ✅ إظهار رسالة خطأ باستخدام دالتك
      showMsg('Failed to load workout group', isError: true);
    }
  }

  void _startWorkout() {
    setState(() {
      isWorkoutActive = true;
      secondsElapsed = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => secondsElapsed++);
    });
  }

  void _endWorkout() {
    _timer?.cancel();
    String duration = _formatTime(secondsElapsed);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WorkoutEndedDialog(
        exercisesCount: exercises.length,
        duration: duration,
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _openExerciseDetail(int exerciseId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExerciseDetailSheet(exerciseId: exerciseId),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // ✅ استخدمنا AppBack
        leading: const AppBack(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Start Workout", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: const Color(0xff0D1B2A))),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
                  child: const Center(child: Text("Today's Workout", style: TextStyle(fontWeight: FontWeight.bold))),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final ex = exercises[index];
                int realExerciseId = ex['exercise'];

                return ExerciseCard(
                  imageUrl: "workout.png",
                  name: ex['name'] ?? 'Exercise',
                  setsReps: "${ex['sets']} sets ${ex['reps']} reps",
                  onPlayTapped: () => _openExerciseDetail(realExerciseId),
                );
              },
            ),
          ),

          if (!isWorkoutActive)
            Padding(
              padding: EdgeInsets.all(20.w),
              // ✅ استخدمنا AppButton لزرار Start
              child: AppButton(
                title: "Start",
                width: double.infinity,
                onPressed: _startWorkout,
              ),
            )
          else
            ActiveWorkoutBar(
              groupName: groupData?['name'] ?? 'Workout',
              timerText: _formatTime(secondsElapsed),
              onPause: () { },
              onEnd: _endWorkout,
            )
        ],
      ),
    );
  }
}