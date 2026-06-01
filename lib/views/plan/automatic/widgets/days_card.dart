import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/ui/app_image.dart';

class DaysCard extends StatelessWidget {
  final String day;
  final bool isReview;
  final String? workout;
  final String? icon;
  final VoidCallback onAdd;
  // ✅ ضفنا المتغير ده عشان يستقبل حالة التحديد من الشاشة الأب
  final bool isSelected;

  const DaysCard({
    super.key,
    required this.day,
    this.workout,
    required this.onAdd,
    required this.isReview,
    this.icon,
    this.isSelected = false, // الـ Default بتاعها فولس عشان متعملش إيرور
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 16),
      child: Container(
        width: double.infinity,
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: -2,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              spreadRadius: -1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color(0xff1E2D6E),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: AppImage(image: icon!, width: 20.w, height: 20.h),
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      workout ?? "No workout assigned",
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            if (!isReview)
              GestureDetector(
                // الشاشة الرئيسية هي اللي بتعمل التغيير، فهنا بننادي الدالة بس
                onTap: onAdd,
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    // ✅ بيتغير لونه بناءً على الشاشة الأساسية
                    color: isSelected ? const Color(0xff1E2D6E) : const Color(0xffF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    // ✅ بتتغير الأيقونة بناءً على الشاشة الأساسية
                    isSelected ? Icons.check : Icons.add,
                    size: 20.sp,
                    color: isSelected ? Colors.white : const Color(0xff0D1B2A),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}