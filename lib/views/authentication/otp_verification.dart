import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/logic/api_helper.dart';

class OtpVerificationView extends StatefulWidget {
  final String email;

  const OtpVerificationView({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final TextEditingController _otpController = TextEditingController();

  // متغيرات لوجيك الـ Resend Timer
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _canResend = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _canResend = false;
      _secondsRemaining = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer?.cancel();
      }
    });
  }

  void _resendOtpAction() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiHelper.createDio().post('/api/auth/resend-otp/', data: {
        'email': widget.email,
      });

      await Future.delayed(const Duration(seconds: 1));

      _startTimer(); // لو الريكويست نجح.. صفر العداد وابدأ دقيقة جديدة

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A new OTP has been sent to your email.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to resend OTP. Please try again.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _verifyOtpAction() async {
    if (_otpController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final response = await ApiHelper.createDio().post('/api/auth/verify-otp/', data: {
        'email': widget.email,
        'otp': _otpController.text.trim(),
      });

      await Future.delayed(const Duration(seconds: 1));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Please check and try again.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B121F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Verification Code",
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Please enter the OTP code sent to:\n${widget.email}",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6, // أو 4 أرقام حسب الباك إند عندك
              style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 8),
              decoration: InputDecoration(
                counterText: "",
                hintText: "000000",
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5), letterSpacing: 8),
                filled: true,
                fillColor: const Color(0xFF161F30),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtpAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E6DEB),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("Verify", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't receive code? ", style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: _canResend && !_isLoading ? _resendOtpAction : null,
                  child: Text(
                    _canResend ? "Resend OTP" : "Resend in $_secondsRemaining s",
                    style: TextStyle(
                      color: _canResend ? const Color(0xFF1E6DEB) : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}