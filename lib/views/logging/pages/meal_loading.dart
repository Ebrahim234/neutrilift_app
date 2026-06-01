import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'meal_details.dart';

class MealLoadingView extends StatefulWidget {
  final File imageFile;
  const MealLoadingView({super.key, required this.imageFile});

  @override
  State<MealLoadingView> createState() => _MealLoadingViewState();
}

class _MealLoadingViewState extends State<MealLoadingView> {
  @override
  void initState() {
    super.initState();
    _analyzeMeal();
  }

  void _analyzeMeal() async {
    // محاكاة للباك إند (٣ ثواني)
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      // استخدمنا pushReplacement عشان منرجعش لصفحة اللودينج تاني لو دوسنا باك
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MealDetailsView(imageFile: widget.imageFile)),
      );
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
            Text("Analyzing Your Meal...", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xff0D1B2A))),
            SizedBox(height: 32.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.file(widget.imageFile, width: 250.w, height: 250.h, fit: BoxFit.cover),
            ),
            SizedBox(height: 40.h),
            const CircularProgressIndicator(color: Color(0xFF1E2D6E)),
          ],
        ),
      ),
    );
  }
}