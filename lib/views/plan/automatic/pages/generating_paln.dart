import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ ضفنا الـ SharedPreferences
import 'package:neutrilift/views/authentication/login.dart'; // ✅ ضفنا الـ LoginView للتوكن
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/views/plan/automatic/pages/review_plan.dart';
import '../../../../core/logic/api_helper.dart';

class GeneratingPlanView extends StatefulWidget {
  final Map<String, dynamic> finalPlanData;

  const GeneratingPlanView({super.key, required this.finalPlanData});

  @override
  State<GeneratingPlanView> createState() => _GeneratingPlanViewState();
}

class _GeneratingPlanViewState extends State<GeneratingPlanView> {
  double progress = 0.0;
  String statusText = "Analyzing your goals...";
  final Dio dio = ApiHelper.createDio();

  @override
  void initState() {
    super.initState();
    _startProgressAndApiCall();
  }

  void _startProgressAndApiCall() async {
    _simulateProgress();

    try {
      widget.finalPlanData['save'] = false;

      // ✅ سحب التوكن وحقنه صراحة في هيدر الـ POST
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? LoginView.tempAccessToken;

      final response = await dio.post(
        '/api/plans/',
        data: widget.finalPlanData,
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final duration = response.data['duration'];

        if (mounted) {
          setState(() {
            progress = 1.0;
            statusText = "Almost done!";
          });
        }

        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;

        goTo(ReviewPlanView(planData: widget.finalPlanData, duration: duration), canPop: false);
      }
    } on DioException catch (e) {
      print("🔴 ERROR STATUS: ${e.response?.statusCode}");
      print("🔴 ERROR DATA: ${e.response?.data}");
      if (mounted) {
        setState(() {
          statusText = "Error generating plan!";
          progress = 0.0;
        });
        showMsg('Failed to generate plan. Please try again.', isError: true);
      }
    }
  }

  void _simulateProgress() async {
    final steps = [
      (0.3, "Analyzing your goals..."),
      (0.6, "Balancing muscle groups"),
      (0.8, "Scheduling your week..."),
    ];

    for (final step in steps) {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted || progress == 1.0) return;
      setState(() {
        progress = step.$1;
        statusText = step.$2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F6),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Generating Your\nWorkout Plan...", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff0D1B2A))),
              const SizedBox(height: 48),
              Text(statusText, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: const Color(0xffE5E7EB), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E2D6E))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}