import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
// 🚀 استدعاء الغلاف الخارجي اللي جواه الـ Nav Bar
import 'package:neutrilift/views/home/pages/home main view.dart';

class LoginView extends StatefulWidget {
  static String? tempAccessToken;
  static String? tempRefreshToken;

  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final Dio dio = ApiHelper.createDio();
  bool isLoading = false;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showMsg("Please fill in all fields", isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await dio.post(
        '/api/login/', // تأكد من مسار الـ API عندك
        data: {
          "email": _emailController.text.trim(),
          "password": _passwordController.text,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final accessToken = response.data['access'] ?? response.data['access_token'];
        final refreshToken = response.data['refresh'] ?? response.data['refresh_token'];

        // حفظ التوكنز في الجهاز للأوتو لوجن
        final prefs = await SharedPreferences.getInstance();
        if (accessToken != null) await prefs.setString('access_token', accessToken);
        if (refreshToken != null) await prefs.setString('refresh_token', refreshToken);

        LoginView.tempAccessToken = accessToken;
        LoginView.tempRefreshToken = refreshToken;

        showMsg("Welcome back!", isError: false);

        // 🎯 التصليح السحري: التوجيه للـ الغلاف الخارجي وليس الصفحة الداخلية
        goTo(const HomeView(), canPop: false);
      }
    } on DioException catch (e) {
      showMsg(e.response?.data['detail'] ?? "Login failed. Check credentials.", isError: true);
    } catch (e) {
      showMsg("An unexpected error occurred", isError: true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Welcome Back",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: const Color(0xff1A2D6B)),
              ),
              SizedBox(height: 32.h),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
              ),
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1A2D6B),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}