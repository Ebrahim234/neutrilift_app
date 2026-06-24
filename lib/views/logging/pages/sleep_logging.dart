import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
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

  final Dio dio = ApiHelper.createDio();
  bool isLoading = false; // 🚀 مؤشر تحميل لحماية الزرار أثناء الريكويست

  // حساب الفرق بين الوقتين بدقة
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
      initialEntryMode: TimePickerEntryMode.input,
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

  // 🚀 دالة إرسال ساعات النوم للباك إند
  Future<void> _saveSleepLog() async {
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      // إرسال ساعات النوم المحسوبة تلقائياً للهيكل المطلوب بالبوست مان
      final response = await dio.post(
        '/api/sleep_log/',
        data: {
          "hours": _calculateDuration(), // الحقل المعتمد بالسيرفر
        },
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          // فتح بوب آب النجاح المعتمد في الفيجما عند الحفظ الصحيح
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const LoggingSuccessDialog(isSleep: true),
          );
        }
      } else {
        showMsg("Failed to save sleep duration", isError: true);
      }
    } on DioException catch (e) {
      print("🔴 SLEEP LOG ERROR => ${e.response?.data}");
      showMsg("Server Error: ${e.response?.statusCode}", isError: true);
    } catch (e) {
      showMsg("An unexpected error occurred", isError: true);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
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

              // كارت عرض النتيجة الكحلي
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

              // زر الحفظ المطور مع إدارة مؤشر التحميل
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _saveSleepLog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1A3B82),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  ),
                  child: isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Text("Save", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}