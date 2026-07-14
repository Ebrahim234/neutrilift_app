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
import '../home/pages/home main view.dart';
import '../home/pages/home_page/view.dart';

// 👈 اعمل import لصفحة الـ personal details بتاعتك هنا في السطر ده:
// import 'package:neutrilift/views/authentication/personal_details_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

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

  final cleanDio = Dio(
    BaseOptions(
      baseUrl: ApiHelper.baseUrl,
      headers: {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
    ),
  );

  final dio = ApiHelper.createDio();

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    print("TOKEN: $token");

    try {
      await dio.get("/");
    } on DioException catch (e) {
      final code = e.response?.data?['code'];
      if (code == 'not_authenticated') {
        if (!mounted) return;
        goTo(const LoginView());
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
    bool isNewUser = false; // 🚀 متغير لفحص هل المستخدم جديد ومحتاج يروح للـ personal details

    try {
      print("🚀 [1] Sending Login request...");
      final response = await cleanDio.post(
        "/api/login/",
        data: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print("📩 [2] Login Response Status: ${response.statusCode}");

      final List<String>? sessionCookies = response.headers['set-cookie'];
      final data = response.data;
      final prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 302 && data != null && data['destination'] != null) {
        isNewUser = true; // 🚀 نعم، المستخدم جديد ويجب توجيهه لصفحة البيانات الشخصية!
        String destination = data['destination'];

        if (!destination.startsWith('/')) {
          destination = '/$destination';
        }

        print("🔄 [3] 302 Detected! Fetching profile path: $destination");

        final nextResponse = await cleanDio.get(
          destination,
          options: Options(
            headers: {
              if (sessionCookies != null) 'cookie': sessionCookies.join('; '),
            },
          ),
        );

        print("📩 [4] Profile Response Data: ${nextResponse.data}");
        final nextData = nextResponse.data;

        if (nextData is Map && nextData['access'] != null) {
          await prefs.setString('access_token', nextData['access']);
          await prefs.setString('refresh_token', nextData['refresh']);
          print("✅ Tokens saved!");
        }
      } else {
        // مستخدم قديم مسجل بياناته بالفعل
        isNewUser = false;
        if (data is Map && data['access'] != null) {
          await prefs.setString('access_token', data['access']);
          await prefs.setString('refresh_token', data['refresh']);
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hi, ${emailController.text.trim()} 👋")),
      );

      // 🚀 4️⃣ التوجيه الذكي بناءً على حالة المستخدم:
      if (isNewUser) {
        print("➡️ Redirecting to Personal Details Page...");
        // ⚠️ استبدل PersonalDetailsView باسم الكلاس الحقيقي لصفحة البيانات الشخصية عندك
        // goTo(const PersonalDetailsView());
      } else {
        print("➡️ Redirecting directly to Home View...");
        goTo(const HomeView()); //[cite: 1]
      }

    } on DioException catch (e) {
      print("🔴 ERROR: ${e.type} | Status: ${e.response?.statusCode}");
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
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
          padding: const EdgeInsetsDirectional.only(top: 60, end: 16, start: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text.rich(
                  style: GoogleFonts.muktaVaani(),
                  const TextSpan(
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
              const SizedBox(height: 56),
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
                  const SizedBox(width: 4),
                  const Text(
                    "Remember me",
                    style: TextStyle(color: Color(0xff9B9B9B)),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      goTo(const ForgetPasswordView());
                    },
                    child: const Text(
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
              const SizedBox(height: 30),
              const AppLoginOrAppRegister(isLogin: true),
            ],
          ),
        ),
      ),
    );
  }
}