import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neutrilift/core/ui/app_image.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../widgets/activity_card.dart';
import '../../widgets/quick_action_card.dart';
import 'home_controller.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final _controller = HomeController();
  int steps = 0;
  String stepStatus = "loading";

  @override
  void initState() {
    super.initState();
    _controller.checkAuth();
    _initSteps();
  }

  Future<void> _initSteps() async {
    final granted = await _controller.requestPermission();
    if (granted) {
      _controller.startStepCounting(
        onStep: (s) => setState(() {
          steps = s;
          stepStatus = "active";
        }),
        onError: () => setState(() => stepStatus = "error"),
      );
    } else {
      setState(() => stepStatus = "denied");
      await openAppSettings();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get stepsDisplay {
    if (stepStatus == "loading") return "...";
    if (stepStatus == "denied" || stepStatus == "error") return "N/A";
    return steps.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF0F0F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(start: 16, end: 16, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppImage(
                    image: "https://picsum.photos/200",
                    height: 70,
                    width: 70,
                    isCircle: true,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Welcome, Ahmed",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text("Today's Activity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  ActivityCard(
                    icon: Icons.directions_walk,
                    iconBg: Color(0xff0D1F49),
                    value: stepsDisplay,
                    unit: "STEPS",
                    label: "Steps",
                    isLoading: stepStatus == "loading",
                  ),
                  ActivityCard(
                    icon: Icons.local_fire_department,
                    iconBg: Color(0xff0D1F49),
                    value: "542",
                    unit: "KCAL",
                    label: "Calories",
                  ),
                  ActivityCard(
                    icon: Icons.favorite,
                    iconBg: Color(0xffE91E63),
                    value: "72",
                    unit: "BPM",
                    label: "Heart Rate",
                  ),
                  ActivityCard(
                    icon: Icons.show_chart,
                    iconBg: Color(0xff9C27B0),
                    value: "42",
                    unit: "MIN",
                    label: "Active Time",
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text("Quick Actions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Row(
                children: [
                  QuickActionCard(icon: Icons.fitness_center, label: "Workout"),
                  SizedBox(width: 12),
                  QuickActionCard(icon: Icons.apple, label: "Nutrition"),
                  SizedBox(width: 12),
                  QuickActionCard(icon: Icons.trending_up, label: "Progress"),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}