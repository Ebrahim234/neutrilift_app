import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/no_plan.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/stats_card/stat_card_side.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/stats_card/stat_card_top.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/week_calender.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/workout.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/workout_routines.dart';
import 'package:neutrilift/views/home/pages/home_page/barcode_feature/food_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/logic/health_service.dart';
import '../../../../core/logic/helper_method.dart';
import '../../../authentication/details.dart';
import '../../../authentication/login.dart';
import 'home_controller.dart';
import 'home_model.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final _controller = HomeController();
  final HealthService _healthService = HealthService();

  int steps = 0;
  int heartRate = 72;
  HomeModel? homeData;
  Timer? _heartRateTimer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller.checkAuth();
    _loadHomeData();
    _initializeDualTracking();
  }

  Future<void> _temporaryLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');

    LoginView.tempAccessToken = null;
    LoginView.tempRefreshToken = null;

    goTo(const LoginView());
  }

  Future<void> _initializeDualTracking() async {
    bool healthAuthorized = await _healthService.requestPermissions();
    if (healthAuthorized) {
      _controller.startStepCounting(
        onStep: (liveSteps) {
          if (mounted) {
            setState(() {
              steps = liveSteps;
            });
          }
        },
        onError: () {
          print("🔴 Pedometer Sensor Error or Not Supported");
        },
      );

      _fetchLatestHeartRate();

      _heartRateTimer = Timer.periodic(const Duration(seconds: 60), (
        timer,
      ) async {
        await _fetchLatestHeartRate();
      });
    }
  }

  Future<void> _fetchLatestHeartRate() async {
    try {
      final liveHeartRate = await _healthService.getLatestHeartRate();
      if (mounted) {
        setState(() {
          heartRate = liveHeartRate;
        });
      }
    } catch (e) {
      print("🔴 Error fetching heart rate from health package: $e");
    }
  }

  // 🚀 تحميل بيانات الهوم مأمنة تماماً بـ الحظر المحلي لمنع تعليق الكاش
  // 🚀 تحميل بيانات الهوم مع التوجيه الفوري لشاشة الـ Details لو السيرفر طلب ده
  // 🚀 تحميل بيانات الهوم مع التوجيه الفوري لشاشة الـ Details لو السيرفر طلب ده
  Future<void> _loadHomeData() async {
    try {
      final data = await _controller.getHomeData().timeout(const Duration(seconds: 3));

      // 🚀 الفحص السحري: لو الكنترولر لقط 302 ورفع الراية، طيران فوراً لشاشة الـ Details!
      if (HomeController.redirectToDetails) {
        HomeController.redirectToDetails = false; // تصفير الفلاج عشان ميعلقش
        if (mounted) {
          print("➡️ Going to DetailsView screen as requested by server 302!");
          goTo(const DetailsView()); // الانتقال الفوري للشاشة اللي مديها لليوزر يملى بياناته
        }
        return; // إنهاء الدالة هنا ومفيش لودينج هيعلق
      }

      if (mounted) {
        setState(() {
          homeData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("🔴 Error loading home data or Timeout: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          homeData = null;
        });
      }
    }
  }

  @override
  void dispose() {
    _heartRateTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xffF0F0F0),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xff1A2D6B)),
        ),
      );
    }

    int displayHeartRate = (heartRate != 72 && heartRate != 0)
        ? heartRate
        : (homeData?.heartRate ?? 72);
    int displaySteps = steps > 0 ? steps : (homeData?.steps ?? 0);

    return Scaffold(
      backgroundColor: const Color(0xffF0F0F0),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xff1A2D6B),
          onRefresh: _loadHomeData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsetsDirectional.only(
              start: 16,
              end: 16,
              top: 30,
              bottom: 60,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

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
                            value: displayHeartRate,
                            unit: "bpm",
                            label: "Heart Rate",
                          ),
                          StatCardTop(
                            icon: "steps.svg",
                            value: displaySteps,
                            unit: "Today",
                            label: "Steps",
                          ),
                          StatCardTop(
                            icon: "calorie_intake.svg",
                            value: homeData?.dailyCalorieIntake ?? 0,
                            unit: "kcal",
                            label: "Calories Intake",
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
                            unit: "Hrs",
                            label: "Avg Sleep",
                          ),
                          StatCardSide(
                            icon: "weight.svg",
                            value:
                                double.tryParse(homeData?.weight ?? "0.0") ??
                                0.0,
                            unit: "Kg",
                            label: "Weight",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                if (homeData?.planFinished == true) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 16.w,
                    ),
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: const Color(0xff10B981),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            "Congrats ! You Completed Your Plan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // 🚀 فحص وعرض الشاشة الصح ديناميكياً
                if (homeData == null ||
                    homeData!.hasPlan == false ||
                    homeData!.planFinished == true) ...[
                  const NoPlanWidget(),
                  SizedBox(height: 16.h),
                  const WorkoutRoutines(),
                ] else ...[
                  WeekCalender(homeData: homeData),
                  SizedBox(height: 8.h),
                  Workout(homeData: homeData, onRefresh: _loadHomeData),
                  SizedBox(height: 16.h),
                  const WorkoutRoutines(),
                ],

                SizedBox(height: 16.h),
                const FoodScannerWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
