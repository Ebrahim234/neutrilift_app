import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/Pin_code_text_field.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/views/authentication/reset_password.dart';
// 🚀 استيراد التايمر اللي أنت عامله
import 'package:neutrilift/core/ui/circular_countdown_timer.dart';

class OtpVerificationView extends StatefulWidget {
  final String email; // استلام الإيميل من صفحة الـ Forget Password

  const OtpVerificationView({super.key, required this.email});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final dio = ApiHelper.createDio();
  String otpCode = "";
  bool isLoading = false;

  Future<void> verifyCode() async {
    if (otpCode.length < 4) {
      showMsg("Please enter the complete 4-digit code", isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      // 🚀 الـ API التانية للتأكد من الكود
      final response = await dio.post(
        '/api/password-reset/verify/',
        data: {
          "email": widget.email,
          "code": otpCode,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showMsg("Code verified successfully! 🔓");
        goTo(ResetPasswordView(email: widget.email));
      }
    } on DioException catch (e) {
      String errorMsg = "Invalid verification code.";
      if (e.response?.data is Map) {
        errorMsg = e.response?.data['error'] ?? errorMsg;
      }
      showMsg(errorMsg, isError: true);
    } catch (e) {
      showMsg("An unexpected error occurred", isError: true);
    } finally { // ✅ تم تصليح الغلطة هنا من final لـ finally
      if (mounted) setState(() => isLoading = false);
    }
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
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Enter code from email \n",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                      ),
                      TextSpan(
                        text: "We’ve sent a 4-digit code to ${widget.email}",
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // حقل إدخال الكود
              MyPinCodeTextField(
                onChanged: (value) {
                  otpCode = value; // حفظ الكود أول بأول
                },
              ),

              const SizedBox(height: 16),

              // 🚀 الـ Timer والـ Resend اللي أنت عامله للـ OTP
              const CircularCountdownTimer(),

              const SizedBox(height: 50),

              AppButton(
                title: "Verify Code",
                width: double.infinity,
                isLoading: isLoading,
                onPressed: verifyCode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}