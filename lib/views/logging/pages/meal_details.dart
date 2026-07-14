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

    // سحب القيم كمجرد أرقام لتطابق التصميم والصورة بالظبط
    String calories = "${mealData['total_calories'] ?? 0}";
    String protein = "${mealData['protein_g'] ?? 0}";
    String carbs = "${mealData['carbs_g'] ?? 0}";
    String fats = "${mealData['fats_g'] ?? 0}";

    // استخراج قائمة تنبيهات الـ AI الجديدة
    List mealBalance = mealData['meal_balance'] ?? [];

    const Color brandBlue = Color(0xff1D3573); // الأزرق الملكي المعتمد في التصميم

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        // سهم الرجوع في الأعلى تماماً لوحده كالتصميم
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان أسفل السهم مباشرة جهة اليسار وبخط عريض
              Text(
                "Nutrition details",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff0D1B2A),
                ),
              ),
              SizedBox(height: 20.h),

              // صورة الوجبة بحواف دائرية ناعمة
              ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: Image.file(
                  imageFile,
                  width: double.infinity,
                  height: 230.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20.h),

              // كارت الماكروز الأبيض المحدث بالكامل
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم الوجبة باللون الأزرق
                    Text(
                      mealName,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: brandBlue,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // الخط الأفقي الرفيع الفاصل تحت الاسم
                    Divider(color: Colors.grey.shade100, thickness: 1),
                    SizedBox(height: 12.h),

                    // جدول الماكروز الموزع بالترتيب والخطوط الفاصلة الرأسية
                    Row(
                      children: [
                        Expanded(child: _macroItem("Fats", fats, brandBlue)),
                        Container(width: 1, height: 40.h, color: Colors.grey.shade100),
                        Expanded(child: _macroItem("Carbs", carbs, brandBlue)),
                        Container(width: 1, height: 40.h, color: Colors.grey.shade100),
                        Expanded(child: _macroItem("Protein", protein, brandBlue)),
                        Container(width: 1, height: 40.h, color: Colors.grey.shade100),
                        Expanded(child: _macroItem("Calories", calories, brandBlue)),
                      ],
                    )
                  ],
                ),
              ),

              // حقن سيكشن الـ AI Meal Insights بشكل مشروط لو متاح
              if (mealBalance.isNotEmpty) ...[
                SizedBox(height: 20.h),
                Text(
                  "AI Meal Insights & Balance",
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: brandBlue),
                ),
                SizedBox(height: 8.h),
                ...mealBalance.map((insight) => Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFFFB300), width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF8F00)),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          insight.toString(),
                          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF5D4037), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ],

              SizedBox(height: 40.h),

              // زرار الـ Save meal العريض والمطابق للـ UI الجديد
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    goTo(const LoggingSuccessDialog(isSleep: false));
                  },
                  child: Text(
                    "Save meal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجيت بناء العنصر الفردي للماكرو (العنوان وتحته القيمة ومحاذاتها لليسار بنعومة)
  Widget _macroItem(String title, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}