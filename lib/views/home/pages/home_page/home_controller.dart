import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neutrilift/views/authentication/login.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'home_model.dart';

class HomeController {
  final Dio dio = ApiHelper.createDio();

  static bool planJustDeleted = false;
  // 🚀 الفلاج السحري: لو بقا true يبقى السيرفر طالب نروح لشاشة الـ Details
  static bool redirectToDetails = false;

  Future<HomeModel?> getHomeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? LoginView.tempAccessToken;

      final response = await dio.get(
        '/',
        options: Options(
          followRedirects: false, // 👈 منع ديو من التتبع التلقائي
          validateStatus: (status) => status != null && status < 500, // 👈 قبول الـ 302 بدون كراش
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      print("📩 [GET HOME DATA] Status Code: ${response.statusCode}");

      // 🚀 إذا رجع 302، نرفع الراية فوراً ونوقف الدالة
      if (response.statusCode == 302) {
        print("⚠️ [HOME CONTROL] 302 Detected! Setting redirectToDetails to true.");
        redirectToDetails = true;
        return null;
      }

      if (response.statusCode == 200 && response.data != null) {
        final model = HomeModel.fromJson(response.data);
        bool serverHasPlan = response.data['has_plan'] ?? response.data['hasPlan'] ?? false;

        if (!serverHasPlan) {
          planJustDeleted = false;
        }

        if (planJustDeleted) {
          return HomeModel(
            hasPlan: false,
            planFinished: model.planFinished,
            dayStatus: "off",
            dailyCalorieIntake: model.dailyCalorieIntake,
            steps: model.steps,
            heartRate: model.heartRate,
            weeklySleepingHours: model.weeklySleepingHours,
            weight: model.weight,
            exerciseDays: [],
            currentWeek: model.currentWeek,
            exerciseFrequency: 0,
          );
        }

        return model;
      }
    } catch (e) {
      print("🔴 Error fetching home data: $e");
    }
    return null;
  }

  Future<String?> deletePlan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? LoginView.tempAccessToken;

      final response = await dio.delete(
        '/api/delete_plan/',
        options: Options(
          responseType: ResponseType.plain,
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        planJustDeleted = true;
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode != null && e.response!.statusCode! >= 200 && e.response!.statusCode! < 300) {
          planJustDeleted = true;
          return null;
        }
        return e.response?.data?.toString() ?? "Server Error";
      }
      return e.toString();
    }
    return "Unknown error";
  }

  Future<bool> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? LoginView.tempAccessToken;
    return token != null;
  }

  void startStepCounting({required Function(int) onStep, required Function() onError}) {}
  void dispose() {}
}