import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ ضفنا الـ SharedPreferences
import 'package:neutrilift/views/authentication/login.dart'; // ✅ ضفنا الـ LoginView للتوكن
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/views/plan/automatic/pages/SuccessDialog.dart';
import 'package:neutrilift/views/plan/automatic/pages/assign_workouts.dart';
import 'package:neutrilift/views/plan/automatic/widgets/days_card.dart';
import 'package:neutrilift/views/plan/automatic/widgets/goal_icon.dart';
import 'package:neutrilift/views/plan/automatic/widgets/review_card.dart';
import '../../../../core/logic/api_helper.dart';
import '../../../../core/ui/app_image.dart';

class ReviewPlanView extends StatefulWidget {
  final Map<String, dynamic> planData;
  final int duration;

  const ReviewPlanView({super.key, required this.planData, required this.duration});

  @override
  State<ReviewPlanView> createState() => _ReviewPlanViewState();
}

class _ReviewPlanViewState extends State<ReviewPlanView> {
  final Dio dio = ApiHelper.createDio();
  late String weightToLose;
  late int currentDuration;
  bool isAccepting = false;

  final weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    weightToLose = widget.planData['amount'].toString();
    currentDuration = widget.duration;
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  Future<void> _acceptPlan() async {
    setState(() => isAccepting = true);

    try {
      widget.planData['save'] = true;

      // ✅ سحب التوكن وحقنه صراحة في هيدر الـ POST لـ قبول الخطة
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? LoginView.tempAccessToken;

      final response = await dio.post(
        '/api/plans/',
        data: widget.planData,
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        goTo(SuccessDialog(), canPop: false);
      }
    } catch (e) {
      showMsg('Failed to save plan!', isError: true);
    } finally {
      setState(() => isAccepting = false);
    }
  }

  Future<void> _regeneratePlan(String newWeight) async {
    Navigator.pop(context);
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

    try {
      widget.planData['amount'] = newWeight;
      widget.planData['save'] = false;

      // ✅ سحب التوكن وحقنه صراحة عند الـ Regenerate
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? LoginView.tempAccessToken;

      final response = await dio.post(
        '/api/plans/',
        data: widget.planData,
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      Navigator.pop(context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          weightToLose = newWeight;
          currentDuration = response.data['duration'];
        });
        showMsg('Plan regenerated successfully!');
      }
    } catch (e) {
      Navigator.pop(context);
      showMsg('Failed to regenerate plan!', isError: true);
    }
  }

  void _showEditDialog() {
    weightController.text = weightToLose;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Weight Goal"),
        content: TextField(
          controller: weightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "e.g. 5"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              if (weightController.text.isNotEmpty) _regeneratePlan(weightController.text);
            },
            child: const Text("Regenerate"),
          ),
        ],
      ),
    );
  }

  String _getDayName(int id) {
    switch(id){
      case 1: return "Monday";
      case 2: return "Tuesday";
      case 3: return "Wednesday";
      case 4: return "Thursday";
      case 5: return "Friday";
      case 6: return "Saturday";
      case 7: return "Sunday";
      default: return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    String goalText = widget.planData['goal'] == 'L' ? 'Lose weight' : 'Gain weight';

    List<dynamic> selectedDaysList = widget.planData['groups_days'] ?? widget.planData['exercise_days'] ?? [];
    int sessionsCount = selectedDaysList.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.only(top: 60, start: 16, end: 16, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Review Your Plan", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 4.h),
              const Text("Automatic generated workout program", style: TextStyle(fontSize: 14, color: Color(0xff6B7280))),
              SizedBox(height: 16.h),
              Container(
                padding: const EdgeInsetsDirectional.all(16),
                width: double.infinity,
                decoration: BoxDecoration(color: const Color(0xff173273), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ReviewCard(label: 'Duration', value: '$currentDuration Weeks'),
                    ReviewCard(label: 'Goal', value: goalText),
                    ReviewCard(label: 'Weekly Workouts', value: '$sessionsCount sessions'),
                    ReviewCard(label: 'Weight Goal', value: '$weightToLose kg', isEdit: true, onEdit: _showEditDialog),
                    SizedBox(height: 8.h),
                    const Text("Plan duration depends on weight you want to lose and number of sessions per week", style: TextStyle(fontSize: 12, color: Color(0xffBFBFBF))),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  const GoalIcon(), SizedBox(width: 8),
                  const Text("Assign Workouts", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsetsDirectional.all(4),
                    decoration: BoxDecoration(color: const Color(0xffFFFFFF).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8.r)),
                    child: IconButton(
                        onPressed: () => goTo(AssignWorkoutsView(planData: widget.planData, isEditMode: true), canPop: true),
                        icon: const AppImage(image: "edit.svg")
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              ...selectedDaysList.map((dayData) {
                int dayId = dayData['day'];
                return DaysCard(
                    day: _getDayName(dayId),
                    onAdd: (){},
                    isReview: true,
                    icon: "workout.svg",
                    workout: "Assigned Workout"
                );
              }),

              SizedBox(height: 16.h,),
              isAccepting
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(title: "Accept plan", width: double.infinity, onPressed: _acceptPlan)
            ],
          ),
        ),
      ),
    );
  }
}