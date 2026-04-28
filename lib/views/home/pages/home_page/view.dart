import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/ui/app_image.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/food_scanner.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/no_plan.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/stats_card/stat_card_side.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/stats_card/stat_card_top.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/week_calender.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/workout.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_controller.dart';
import 'home_model.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final bool isPlanDone = false;
  final _controller = HomeController();
  int steps = 0;
  String stepStatus = "loading";

  @override
  void initState() {
    super.initState();
    _controller.checkAuth();
    _initSteps();
    _loadHomeData();

  }
  Future<void> _loadHomeData() async {
    final data = await _controller.getHomeData();
    if (data != null) {
      setState(() {
        homeData = data;
      });
    }
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

  HomeModel? homeData;

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
          padding: EdgeInsetsDirectional.only(
            start: 16,
            end: 16,
            top: 30,
            bottom: 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppImage(
                    image: "https://picsum.photos/200",
                    height: 70.h,
                    width: 70.w,
                    isCircle: true,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      "Welcome, Ahmed",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsetsDirectional.all(16),
                height: 192,
                decoration: BoxDecoration(
                  color: Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatCardTop(
                          icon: "heart_rate.svg",
                          value: 72,
                          unit: "bpm",
                          label: "Heart Rate",
                        ),
                        StatCardTop(
                          icon: "steps.svg",
                          value: 8240,
                          unit: "Today",
                          label: "Steps",
                        ),
                        StatCardTop(
                          icon: "calorie_intake.svg",
                          value: 1840,
                          unit: "Kcal",
                          label: "Calorie Intake",
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatCardSide(
                          icon: "sleep.svg",
                          value: 72,
                          unit: "Hours",
                          label: "Avg Sleep",
                        ),
                        StatCardSide(
                          icon: "weight.svg",
                          value: 78.4,
                          unit: "KG",
                          label: "Weight",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              if (homeData?.hasPlan == false) ...[
                NoPlanWidget(),
              ] else ...[
                WeekCalender(),
                SizedBox(height: 8.h),
                Workout(),
              ],
              SizedBox(height: 8.h),
              FoodScannerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
