import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/ui/app_back.dart';

class ScannerDetailsView extends StatelessWidget {
  final Map<String, dynamic> nutritionData;

  const ScannerDetailsView({super.key, required this.nutritionData});

  @override
  Widget build(BuildContext context) {
    // قراءة الداتا الديناميكية من الـ JSON الراجع من السيرفر
    String productName = nutritionData['product_name'] ?? 'Unknown Product';
    String brand = nutritionData['brand'] ?? 'Generic';
    String servingSize = nutritionData['serving_size'] ?? 'N/A';

    String calories = "${nutritionData['calories'] ?? 0} Kcal";
    String protein = "${nutritionData['protein_g'] ?? 0}g";
    String carbs = "${nutritionData['carbs_g'] ?? 0}g";
    String fats = "${nutritionData['fats_g'] ?? 0}g";

    String fiber = "${nutritionData['fiber_g'] ?? 0}g";
    String sugar = "${nutritionData['sugar_g'] ?? 0}g";
    String sodium = "${nutritionData['sodium_mg'] ?? 0}mg";
    String ingredients = nutritionData['ingredients'] ?? 'No ingredients listed.';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Nutrition Details", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: const AppBack(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // كارت بيانات المنتج
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xff1A2D6B))),
                    SizedBox(height: 4.h),
                    Text("Brand: $brand", style: TextStyle(fontSize: 14.sp, color: Colors.grey, fontWeight: FontWeight.w500)),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.restaurant_menu, size: 16.sp, color: Colors.grey),
                        SizedBox(width: 6.w),
                        Text("Serving Size: $servingSize", style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // كارت الماكروز الأساسية
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Macronutrients", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xff0D1B2A))),
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
              SizedBox(height: 16.h),

              // كارت الإحصائيات الإضافية
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Additional Insights", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xff0D1B2A))),
                    SizedBox(height: 12.h),
                    _rowInsightItem("Sugar", sugar),
                    const Divider(),
                    _rowInsightItem("Fiber", fiber),
                    const Divider(),
                    _rowInsightItem("Sodium", sodium),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // كارت المكونات
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ingredients", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xff0D1B2A))),
                    SizedBox(height: 8.h),
                    Text(ingredients, style: TextStyle(fontSize: 13.sp, color: const Color(0xff434C6D), height: 1.4)),
                  ],
                ),
              ),
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
        SizedBox(height: 6.h),
        Text(value, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _rowInsightItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14.sp, color: const Color(0xff434C6D), fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: const Color(0xff0D1B2A))),
        ],
      ),
    );
  }
}