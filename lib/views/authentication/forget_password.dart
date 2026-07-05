import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/views/authentication/otp_verification.dart';
import '../../core/ui/app_button.dart';
import '../../core/ui/app_input.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  // 🎯 الكنترولر ده هو المسؤول عن سحب الكتابة من الأبليكيشن
  final emailController = TextEditingController();
  final dio = ApiHelper.createDio();
  bool isLoading = false;

  Future<void> sendResetCode() async {
    // 💥 هنا بناخد النص اللي كتبته بإيدك في الشاشة حالا
    final inputEmail = emailController.text.trim();

    if (inputEmail.isEmpty) {
      showMsg("Please enter your email", isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      // الريكويست بياخد الإيميل الديناميكي اللي كتبته في التطبيق
      final response = await dio.post(
        '/api/password-reset/request/',
        data: {"email": inputEmail},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showMsg("Verification code sent! 📩");
        // بنمرر الإيميل المكتوب لصفحة الـ OTP عشان نستخدمه في الـ Verify بعد كده
        goTo(OtpVerificationView(email: inputEmail));
      }
    } on DioException catch (e) {
      String errorMsg = "Failed to send code";
      if (e.response?.data is Map) {
        errorMsg = e.response?.data['error'] ?? e.response?.data['message'] ?? errorMsg;
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
    emailController.dispose();
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
                      TextSpan(text: "Forgot password? \n", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36)),
                      TextSpan(text: "No worries — enter your email and we’ll send you a reset link.", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 🚀 ربطنا الـ controller هنا عشان يلقط كتابتك من الكيبورد فوراً
              AppInput(
                hintText: "Enter your email",
                isEmail: true,
                controller: emailController,
              ),

              const SizedBox(height: 150),
              AppButton(
                title: "Next",
                width: double.infinity,
                isLoading: isLoading,
                onPressed: sendResetCode, // تشغيل الدالة الديناميكية
              ),
            ],
          ),
        ),
      ),
    );
  }
}