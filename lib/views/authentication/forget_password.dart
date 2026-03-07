import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/views/authentication/otp_verification.dart';

import '../../core/ui/app_button.dart';
import '../../core/ui/app_input.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(top: 60,end: 16,start: 16),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text.rich(
                    style:GoogleFonts.muktaVaani(),TextSpan(children: [
                  TextSpan(text: "Forgot password? \n", style:TextStyle(fontWeight: FontWeight.bold,fontSize: 36,)),
                  TextSpan(text: "No worries — enter your email and we’ll send you a reset link.",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 24))

                ])),
              ),
              SizedBox(height: 24,),
              AppInput(hintText: "Enter your email",isEmail: true,),
              SizedBox(height: 150,),
              AppButton(title: "Next",),

            ],
          ),
        ),
      ),
    );
  }
}
