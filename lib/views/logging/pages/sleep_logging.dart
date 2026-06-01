import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_back.dart';
import 'package:neutrilift/views/logging/pages/logging_success_dialog.dart';
import '../../../core/ui/app_image.dart';
import '../widgets/sleep_input.dart';

class SleepLoggingView extends StatefulWidget {
  const SleepLoggingView({super.key});

  @override
  State<SleepLoggingView> createState() => _SleepLoggingViewState();
}

class _SleepLoggingViewState extends State<SleepLoggingView> {
  TimeOfDay sleepTime = const TimeOfDay(hour: 23, minute: 30);
  TimeOfDay wakeTime = const TimeOfDay(hour: 11, minute: 30);

  // حساب الفرق بين الوقتين
  double _calculateDuration() {
    double sleepDouble = sleepTime.hour + (sleepTime.minute / 60.0);
    double wakeDouble = wakeTime.hour + (wakeTime.minute / 60.0);

    double duration = wakeDouble - sleepDouble;
    if (duration < 0) duration += 24; // إذا كان النوم قبل منتصف الليل والاستيقاظ بعده

    return double.parse(duration.toStringAsFixed(1));
  }

  // إظهار الـ Picker بشكل الـ Input Mode
  Future<void> _selectTime(BuildContext context, bool isSleep) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isSleep ? sleepTime : wakeTime,
      initialEntryMode: TimePickerEntryMode.input, // هذا السطر يحول الشكل لصورة image_b1a5be.png
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff1A3B82),
              onSurface: Color(0xff1D2939),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isSleep) sleepTime = picked;
        else wakeTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(top: 20.h, start: 16.w, end: 16.w, bottom: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBack(),
              SizedBox(height: 16.h),
              Text(
                "Track Your Sleep",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24.h),

              // كارت الإدخال الأبيض
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: const Color(0xff1A3B82),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: const AppImage(image: "white_sleep.svg", height: 24, width: 24),
                        ),
                        SizedBox(width: 12.w),
                        const Text("Sleep time", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        SleepInput(
                          label: "Sleep",
                          time: sleepTime.format(context),
                          onTap: () => _selectTime(context, true),
                        ),
                        SizedBox(width: 16.w),
                        SleepInput(
                          label: "Wake up",
                          time: wakeTime.format(context),
                          onTap: () => _selectTime(context, false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // كارت عرض النتيجة الكحلي (image_b20bba.png)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 40.h),
                decoration: BoxDecoration(
                  color: const Color(0xff1A3B82),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  children: [
                    Text(
                      _calculateDuration().toString(),
                      style: TextStyle(fontSize: 64.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const Text("Hours slept", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),

              SizedBox(height: 60.h),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    goTo(const LoggingSuccessDialog(isSleep: true,),);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1A3B82),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  ),
                  child: const Text("Save", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}