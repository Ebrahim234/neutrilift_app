import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import '../../../../plan/create_plan/create_plan_view.dart';

class NoPlanWidget extends StatelessWidget {
  const NoPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainAppColor = Color(0xff1A2D6B); // لون تطبيقك الأزرق المعتمد

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // شكل جمالي فوق الزرار يشير لعدم وجود خطة
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: mainAppColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_late_outlined,
              color: mainAppColor,
              size: 32,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "No Active Plan Found",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: mainAppColor,
            ),
          ),
          SizedBox(height: 4.h),
          const Text(
            "Create your personalized workout plan to unlock your weekly schedule and tracking.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 16.h),

          // 🚀 زرار الـ Create Plan بالـ onPressed المتعدلة وجنبها علامة الزائد (+)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // أمر الانتقال لصفحة اختيار نوع الخطة فوراً عند الضغط
                goTo(const CreatePlanView());
              },
              icon: const Icon(Icons.add, color: Colors.white), // علامة الزائد الشيك داخل الزرار
              label: const Text(
                "Create Plan",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainAppColor,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}