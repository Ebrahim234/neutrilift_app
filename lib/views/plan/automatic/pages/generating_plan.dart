import 'package:flutter/material.dart';

class GeneratingPlanView extends StatefulWidget {
  const GeneratingPlanView({super.key});

  @override
  State<GeneratingPlanView> createState() => _GeneratingPlanViewState();
}

class _GeneratingPlanViewState extends State<GeneratingPlanView> {
  double progress = 0.0;
  String statusText = "Balancing muscle groups";

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() async {
    final steps = [
      (0.3, "Analyzing your goals..."),
      (0.6, "Balancing muscle groups"),
      (0.8, "Scheduling your week..."),
      (1.0, "Almost done!"),
    ];

    for (final step in steps) {
      await Future.delayed(Duration(milliseconds: 800));
      if (!mounted) return;
      setState(() {
        progress = step.$1;
        statusText = step.$2;
      });
    }

    // لما يخلص روح للشاشة الجاية
    await Future.delayed(Duration(milliseconds: 500));
    if (!mounted) return;
    // goTo(ReviewPlanView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F4F6),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Generating Your\nWorkout Plan...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0D1B2A),
                ),
              ),
              SizedBox(height: 48),
              Text(
                statusText,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Color(0xffE5E7EB),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E2D6E)),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Processing...",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "${(progress * 100).toInt()}%",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2D6E),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}