import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neutrilift/views/authentication/login.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'home_model.dart';

class HomeController {
  final Dio dio = ApiHelper.createDio();

  Future<HomeModel?> getHomeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? LoginView.tempAccessToken;

      // 🚀 سلاش فقط بناءً على الـ API الفعلي للباك إند
      final response = await dio.get(
        '/',
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return HomeModel.fromJson(response.data);
      }
    } catch (e) {
      print("🔴 Error fetching home data in Controller: $e");
    }
    return null;
  }

  Future<bool> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? LoginView.tempAccessToken;
    return token != null;
  }

  void startStepCounting({required Function(int) onStep, required Function() onError}) {}
  void dispose() {}
}