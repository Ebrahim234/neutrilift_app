import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'meal_details.dart';

class MealLoadingView extends StatefulWidget {
  final File imageFile;
  const MealLoadingView({super.key, required this.imageFile});

  @override
  State<MealLoadingView> createState() => _MealLoadingViewState();
}

class _MealLoadingViewState extends State<MealLoadingView> {
  final Dio dio = ApiHelper.createDio();
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _analyzeMeal();
  }

  // 🚀 إرسال الصورة الحقيقية للباك إند بدلاً من التايمر القديم
  void _analyzeMeal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      // تجهيز ملف الصورة بصيغة form-data طبقاً للبوست مان
      String fileName = widget.imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          widget.imageFile.path,
          filename: fileName,
        ),
      });

      // إرسال الريكويست الفعلي للباك إند
      final response = await dio.post(
        '/api/imagecalories/?save=true',
        data: formData,
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (mounted) {
          // دفع البيانات الديناميكية لشاشة العرض المحدثة
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MealDetailsView(
                imageFile: widget.imageFile,
                mealData: response.data, // الـ JSON الراجع من السيرفر
              ),
            ),
          );
        }
      } else {
        setState(() => isError = true);
        showMsg("Failed to analyze meal", isError: true);
      }
    } catch (e) {
      print("🔴 MEAL ANALYSIS ERROR => $e");
      setState(() => isError = true);
      showMsg("Network error or invalid response", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100.h),
            Text(
              isError ? "Analysis Failed" : "Analyzing Your Meal...",
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xff0D1B2A)),
            ),
            SizedBox(height: 32.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.file(widget.imageFile, width: 250.w, height: 250.h, fit: BoxFit.cover),
            ),
            SizedBox(height: 40.h),
            if (isError)
              ElevatedButton(
                onPressed: () {
                  setState(() => isError = false);
                  _analyzeMeal();
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E2D6E)),
                child: const Text("Retry", style: TextStyle(color: Colors.white)),
              )
            else
              const CircularProgressIndicator(color: Color(0xFF1E2D6E)),
          ],
        ),
      ),
    );
  }
}