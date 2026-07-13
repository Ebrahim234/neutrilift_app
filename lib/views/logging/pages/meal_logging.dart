import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_image.dart';
import 'package:neutrilift/views/logging/pages/meal_confirm.dart';

class MealLoggingView extends StatefulWidget {
  const MealLoggingView({super.key});

  @override
  State<MealLoggingView> createState() => _MealLoggingViewState();
}

class _MealLoggingViewState extends State<MealLoggingView> {

  // 🚀 الدالة الحركية بتستقبل نوع المصدر وتفتح المطلوب فوراً
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null && mounted) {
      goTo(MealConfirmView(imageFile: File(pickedFile.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAECEF),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 350.h,
            color: Colors.grey[300],
            child: const Center(
              child: Text(
                "Camera Preview Here",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 60.h),

          // 🚀 تم وضع زرار المعرض وزرار الكاميرا جنب بعض على الشاشة مباشرة
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🖼️ زرار الـ Gallery (المعرض) الجديد
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: Column(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xff1E2D6E), width: 2.w),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xff1E2D6E), // لون متناسق مع التطبيق
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    const Text(
                      "Gallery",
                      style: TextStyle(color: Color(0xff1E2D6E), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 40.w), // مسافة أمان تفصل بين الزرارين

              // 📸 زرار الـ Camera (الكاميرا) الأصلي بتاعك زي ما هو
              GestureDetector(
                onTap: () => _pickImage(ImageSource.camera),
                child: Column(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.w),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: AppImage(
                          image: "camera.svg",
                          width: 30.h,
                          height: 30.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    const Text(
                      "Camera",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}