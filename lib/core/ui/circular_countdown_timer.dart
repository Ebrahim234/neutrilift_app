import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularCountdownTimer extends StatefulWidget {
  const CircularCountdownTimer({super.key});

  @override
  State<CircularCountdownTimer> createState() => _CircularCountdownTimerState();
}

class _CircularCountdownTimerState extends State<CircularCountdownTimer> {
  @override
 bool isCodeSent = true;

  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Didn't recieve a code?",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            color: Color(0xff434C6D),
          ),
        ),
        TextButton(
          onPressed: isCodeSent?null:(){},
          child: Text(
          "Resend",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            color: Color(0xffD75D72),
          ),
        )),
        Spacer(),
        if (isCodeSent)
        CircularCountDownTimer(
          width: 40.w,
          height: 50.h,
          duration: 60,
          fillColor: Colors.transparent,
          ringColor: Colors.transparent,
          isReverse: true,
        ),
      ],
    );
  }
}
