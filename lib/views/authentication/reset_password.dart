import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/core/ui/app_input.dart';
import 'package:neutrilift/views/authentication/login.dart';

class ResetPasswordView extends StatefulWidget {
  final String email;

  const ResetPasswordView({super.key, required this.email});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dio = ApiHelper.createDio();
  bool isLoading = false;

  Future<void> confirmResetPassword() async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      showMsg("Fields cannot be empty", isError: true);
      return;
    }

    if (password != confirmPassword) {
      showMsg("Passwords do not match!", isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      // 🚀 POST الريكويست الثالث والأخير لقفل الـ Flow بنجاح
      final response = await dio.post(
        '/api/password-reset/confirm/',
        data: {
          "email": widget.email,
          "password": password,
          "confirm_password": confirmPassword,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showMsg("Password updated successfully! 🎉");
        // بنرجعه لصفحة اللوجين الأساسية نضيف
        goTo(const LoginView());
      }
    } on DioException catch (e) {
      String errorMsg = "Failed to reset password";
      if (e.response?.data is Map) {
        errorMsg = e.response?.data['message'] ?? e.response?.data.toString() ?? errorMsg;
      }
      showMsg(errorMsg, isError: true);
    } catch (e) {
      showMsg("An unexpected error occurred", isError: true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.only(top: 60, end: 16, start: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                style: GoogleFonts.muktaVaani(),
                const TextSpan(
                  children: [
                    TextSpan(text: "Reset Password \n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36)),
                    TextSpan(text: "Create a strong and secure new password.", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24))
                  ],
                ),
              ),
              const SizedBox(height: 40),
              AppInput(
                hintText: "Create your new password",
                isPassword: true,
                controller: passwordController,
              ),
              AppInput(
                hintText: "Confirm your new password",
                isPassword: true,
                controller: confirmPasswordController,
              ),
              const SizedBox(height: 60),
              AppButton(
                title: "Reset Password",
                width: double.infinity,
                isLoading: isLoading,
                onPressed: confirmResetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}