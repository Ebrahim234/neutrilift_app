import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/ui/app_image.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/no_plan.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/stats_card/stat_card_side.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/stats_card/stat_card_top.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/week_calender.dart';
import 'package:neutrilift/views/home/pages/home_page/widgets/workout.dart';
import 'package:neutrilift/views/home/pages/home_page/barcode_feature/food_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/logic/health_service.dart';
import '../../../../core/logic/helper_method.dart';
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

  // تايمر نبض القلب الدوري
  Timer? _heartRateTimer;

  @override
  void initState() {
    super.initState();
    _controller.checkAuth();
    _loadHomeData();
    _initializeDualTracking(); // تشغيل التتبع المزدوج للحساسات
  }

  // دالة الـ Logout المؤقتة للتست
  Future<void> _temporaryLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');

    LoginView.tempAccessToken = null;
    LoginView.tempRefreshToken = null;

    goTo(const LoginView());
  }

  // دالة التتبع المزدوج الاحترافية (Pedometer لايف + Health Package دوري)
  Future<void> _initializeDualTracking() async {
    bool healthAuthorized = await _healthService.requestPermissions();
    bool activityAuthorized = await _controller.requestPermission();

    if (healthAuthorized) {
      // 🏃‍♂️ تشغيل عداد الخطوات لايف (Sensor Stream)
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

      // ❤️ سحب قراءة نبض القلب الافتتاحية فوراً عند فتح الصفحة
      _fetchLatestHeartRate();

      // ⏱️ تايمر دوري (Battery-Aware) كل 60 ثانية لتحديث النبض
      _heartRateTimer = Timer.periodic(const Duration(seconds: 60), (timer) async {
        await _fetchLatestHeartRate();
      });
    }
  }

  // دالة سحب نبض القلب من باكدج الـ Health
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

  // دالة سحب بيانات الـ API (صامتة ومأمنة بالكامل)
  Future<void> _loadHomeData() async {
    try {
      final data = await _controller.getHomeData();
      if (mounted && data != null) {
        setState(() {
          homeData = data;
        });
      }
    } catch (e) {
      print("🔴 Server Error: $e"); // بيطبع الأيرور في الـ Console بس مش بيعطل الـ UI
    }
  }

  @override
  void dispose() {
    _heartRateTimer?.cancel(); // قفل التايمر فوراً لمنع الـ Memory Leak
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F0F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 30, bottom: 60),
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
                  const Expanded(
                    child: Text(
                      "Welcome, Ahmed",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // كارت الماكروز والإحصائيات الحية (مأمن تماماً بـ Fallback values)
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
                          value: heartRate,
                          unit: "bpm",
                          label: "Heart Rate",
                        ),
                        StatCardTop(
                          icon: "steps.svg",
                          value: steps,
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
                          value: double.tryParse(homeData?.weeklySleepingHours ?? "0.0") ?? 0.0,
                          unit: "Hours",
                          label: "Avg Sleep",
                        ),
                        StatCardSide(
                          icon: "weight.svg",
                          value: double.tryParse(homeData?.weight ?? "0.0") ?? 0.0,
                          unit: "KG",
                          label: "Weight",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // 🛡️ لوجيك الحماية الذكي: لو الداتا لسه مجاتش أو مفيش خطة اعرض NoPlanWidget، غير كدة اظهر الجدول
              if (homeData == null || homeData!.hasPlan == false) ...[
                const NoPlanWidget(),
              ] else ...[
                WeekCalender(homeData: homeData),
                SizedBox(height: 8.h),
                 Workout(),
              ],

              SizedBox(height: 8.h),
              const FoodScannerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}