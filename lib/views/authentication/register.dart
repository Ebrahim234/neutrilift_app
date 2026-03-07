import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/core/ui/app_input.dart';
import 'package:neutrilift/core/ui/app_login_or_app_register.dart';
import 'package:neutrilift/views/authentication/otp_verification.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logic/api_helper.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final emailController = TextEditingController();
  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();

  final dio = ApiHelper.createDio();

  bool isLoading = false;

  Future<void> register() async {
    if (emailController.text.isEmpty ||
        password1Controller.text.isEmpty ||
        password2Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await dio.post(
        "api/signup/",
        data: {
          "email": emailController.text.trim(),
          "password1": password1Controller.text.trim(),
          "password2": password2Controller.text.trim(),
        },
      );

      final data = response.data;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access']);
      await prefs.setString('refresh_token', data['refresh']);

      print("Access: ${data['access']}");
      print("Refresh: ${data['refresh']}");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registered Successfully ✅")),
      );

      goTo(OtpVerificationView());
    } on DioException catch (e) {
      print("Status: ${e.response?.statusCode}");
      print("Error: ${e.response?.data}");

      String errorMessage = "Something went wrong";

      if (e.response != null && e.response!.data is Map) {
        final errors = e.response!.data as Map;

        if (errors.isNotEmpty) {
          final firstKey = errors.keys.first;
          final firstError = errors[firstKey];

          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = "$firstKey: ${firstError[0]}";
          }
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    password1Controller.dispose();
    password2Controller.dispose();
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
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text.rich(
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
                  style: GoogleFonts.muktaVaani(),
                ),
              ),
              SizedBox(height: 56),
              AppInput(
                hintText: "Enter your email",
                isEmail: true,
                controller: emailController,
              ),
              AppInput(
                hintText: "Create your password",
                isPassword: true,
                controller: password1Controller,
              ),
              AppInput(
                hintText: "Confirm your password",
                isPassword: true,
                controller: password2Controller,
              ),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  "-Make it at least 8 characters",
                  style: GoogleFonts.encodeSans(),
                ),
              ),
              SizedBox(height: 24),
              AppButton(
                title: "Next",
                isLoading: isLoading,
                onPressed: register,
              ),
              SizedBox(height: 40),
              AppLoginOrAppRegister(isLogin: false),
            ],
          ),
        ),
      ),
    );
  }
}