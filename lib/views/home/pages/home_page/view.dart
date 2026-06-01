import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/helper_method.dart'; // مسار الـ goTo
import 'package:neutrilift/core/ui/app_image.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/no_plan.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/stats_card/stat_card_side.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/stats_card/stat_card_top.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/week_calender.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/workout_routines.dart';
import 'package:neutrilift/views/workout/pages/workout_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'barcode_feature/food_scanner.dart';
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
  HomeModel? homeData;

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
      backgroundColor: const Color(0xffF0F0F0),
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
              // كارت الترحيب باليوزر
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
                  const Expanded(
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

              // كارت الإحصائيات البدنية (النبض، الخطوات، السعرات، الوزن)
              Container(
                padding: const EdgeInsetsDirectional.all(16),
                height: 192,
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
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
                          value: steps,
                          // سحب الخطوات الفعلية من العداد الحسي النشط
                          unit: "Today",
                          label: "Steps",
                        ),
                        StatCardTop(
                          icon: "calorie_intake.svg",
                          value: homeData?.dailyCalorieIntake ?? 0,
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
                          value:
                              double.tryParse(
                                homeData?.weeklySleepingHours ?? "0.0",
                              ) ??
                              0.0,
                          unit: "Hours",
                          label: "Avg Sleep",
                        ),
                        StatCardSide(
                          icon: "weight.svg",
                          value:
                              double.tryParse(homeData?.weight ?? "0.0") ?? 0.0,
                          unit: "KG",
                          label: "Weight",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // اللوجيك الشرطي المطور لربط التمرين أو أيام الراحة بالـ Figma بالمللي
              if (homeData?.hasPlan == false) ...[
                const NoPlanWidget(),
              ] else ...[
                WeekCalender(homeData: homeData),

                // 🚀 التحكم في كروت التمارين بناءً على ماب السيرفر
                if (homeData?.groupDetail != null)
                  // 1. كارت التمرين النشط (الأزرق اللامع) في حالة وجود تمرين مجدول اليوم
                  GestureDetector(
                    onTap: () {
                      // الانتقال لشاشة التمرين الحقيقية وتمرير الـ ID المتاح من الباك إند
                      goTo(
                        WorkoutView(groupId: homeData!.groupDetail!.id!),
                        canPop: true,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: const Color(0xff1E2D6E),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Today's workout",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                (homeData!.groupDetail!.groupName ?? "Workout")
                                    .replaceAll('_', ' '),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.nightlight_round_outlined,
                            color: Colors.amber,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "No workout scheduled for today",
                              style: TextStyle(
                                color: const Color(0xff0D1B2A),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Enjoy your rest day",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],

              SizedBox(height: 16.h),
              const WorkoutRoutines(),
              // كارت الروتينات المستقل المطور
              SizedBox(height: 16.h),
              const FoodScannerWidget(),
              // كارت الاسكانر الحي
            ],
          ),
        ),
      ),
    );
  }
}
