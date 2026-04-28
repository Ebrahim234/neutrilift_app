import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/views/authentication/forget_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logic/api_helper.dart';
import '../../core/ui/app_button.dart';
import '../../core/ui/app_input.dart';
import '../../core/ui/app_login_or_app_register.dart';
import '../home/pages/home_page/view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  // ✅ static هنا عشان نوصلهم من api_helper
  static String? tempAccessToken;
  static String? tempRefreshToken;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isChecked = false;
  bool isLoading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final dio = ApiHelper.createDio();
  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    print("TOKEN: $token"); // ✅ اطبع الـ token

    try {
      await dio.get("/");
    } on DioException catch (e) {
      final code = e.response?.data?['code'];
      if (code == 'not_authenticated') {
        if (!mounted) return;
        goTo(LoginView());
      }
    }
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await dio.post(
        "/api/login/",
        data: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      final data = response.data;
      print("RESPONSE: $data");
      final prefs = await SharedPreferences.getInstance();

      // ✅ بعد - بيحفظ دايماً
      await prefs.setString('access_token', data['access']);
      await prefs.setString('refresh_token', data['refresh']);

      // ✅ بعت request للـ home page على طول بعد الـ login
      await dio.get("/");

      if (!mounted) return;

      final serverMessage = data['message'] ?? "";
      final email = serverMessage
          .replaceAll("Hello, ", "")
          .replaceAll(". you logged in successfully.", "");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hi, ${emailController.text.trim()} 👋")),
      );

      goTo(HomePageView());
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";

      if (e.response != null && e.response!.data is Map) {
        final errors = e.response!.data as Map;

        if (errors.containsKey('__all__')) {
          errorMessage = errors['__all__'][0];
        } else if (errors.isNotEmpty) {
          final firstKey = errors.keys.first;
          final firstError = errors[firstKey];
          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError[0];
          }
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(
            top: 60,
            end: 16,
            start: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text.rich(
                  style: GoogleFonts.muktaVaani(),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Welcome Back \n",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                      TextSpan(
                        text: "Let's get you back on track.",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 56),
              AppInput(
                hintText: "Enter your email",
                controller: emailController,
              ),
              AppInput(
                hintText: "Enter your password",
                isPassword: true,
                controller: passwordController,
              ),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Remember me",
                    style: TextStyle(color: Color(0xff9B9B9B)),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      goTo(ForgetPasswordView());
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color(0xff415A77)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              AppButton(
                title: "Next",
                isLoading: isLoading,
                onPressed: login,
                width: double.infinity,
              ),
              SizedBox(height: 30),
              AppLoginOrAppRegister(isLogin: true),
            ],
          ),
        ),
      ),
    );
  }
}