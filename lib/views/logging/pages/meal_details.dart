import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/views/logging/pages/logging_success_dialog.dart';

class MealDetailsView extends StatelessWidget {
  final File imageFile;
  final Map<String, dynamic> mealData; // استقبال بيانات السيرفر الحقيقية هنا

  const MealDetailsView({
    super.key,
    required this.imageFile,
    required this.mealData,
  });

  @override
  Widget build(BuildContext context) {
    // فك شفرة لستة العناصر الراجعة واستخراج أول اسم طعام تم كشفه
    List items = mealData['items'] ?? [];
    String mealName = items.isNotEmpty ? (items[0]['name'] ?? 'Unknown Meal') : 'Unknown Meal';

    // سحب الماكروز المعتمدة بالمللي من الـ JSON الصادر من الباك إند
    String calories = "${mealData['total_calories'] ?? 0} Kcal";
    String protein = "${mealData['protein_g'] ?? 0}g";
    String carbs = "${mealData['carbs_g'] ?? 0}g";
    String fats = "${mealData['fats_g'] ?? 0}g";

    // 🚀 1️⃣ استخراج قائمة تنبيهات الـ AI الجديدة (لو مش موجودة بترجع قائمة فاضية تلقائياً)
    List mealBalance = mealData['meal_balance'] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Nutrition details", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.file(imageFile, width: double.infinity, height: 250.h, fit: BoxFit.cover),
              ),
              SizedBox(height: 24.h),

              // كارت الماكروز الرئيسي
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealName,
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xff1A2D6B)),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _macroItem("Calories", calories, const Color(0xff1A2D6B)),
                        _macroItem("Protein", protein, Colors.green),
                        _macroItem("Carbs", carbs, Colors.orange),
                        _macroItem("Fats", fats, Colors.red),
                      ],
                    )
                  ],
                ),
              ),

              // 🚀 2️⃣ حقن سيكشن الـ AI Meal Insights & Balance الجديد بشكل مشروط
              if (mealBalance.isNotEmpty) ...[
                SizedBox(height: 20.h),
                Text(
                  "AI Meal Insights & Balance",
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: const Color(0xff1A2D6B)),
                ),
                SizedBox(height: 8.h),
                ...mealBalance.map((insight) => Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1), // لون أصفر تنبيهي خفيف متناسق مع التصميم
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFFFB300), width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF8F00)), // الأيقونة التحذيرية المطابقة لـ Postman
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          insight.toString(), // تحويل آمن لنص التنبيه
                          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF5D4037), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ],

              SizedBox(height: 32.h),
              AppButton(
                title: "Save meal",
                width: double.infinity,
                onPressed: () {
                  goTo(const LoggingSuccessDialog(isSleep: false));
                },
              ),
              SizedBox(height: 20.h), // مساحة أمان سفلية للـ scrolling
            ],
          ),
        ),
      ),
    );
  }

  Widget _macroItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.w500)),
        SizedBox(height: 8.h),
        Text(value, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}