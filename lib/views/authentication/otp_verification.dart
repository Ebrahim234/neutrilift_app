import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neutrilift/core/ui/Pin_code_text_field.dart';

class OtpVerificationView extends StatelessWidget {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(top: 60, end: 16, start: 16),

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
                        text: "Enter code from email \n",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                      TextSpan(
                        text: "We’ve sent a 4-digit code to your email",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 60,),
              MyPinCodeTextField()
            ],
          ),
        ),
      ),
    );
  }
}
