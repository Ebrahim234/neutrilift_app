import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/views/logging/view.dart';

import '../../home/pages/home main view.dart';

class LoggingSuccessDialog extends StatelessWidget {
  final bool isSleep;

  const LoggingSuccessDialog({super.key, required this.isSleep});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ليأخذ حجم المحتوى فقط
          children: [
            // أيقونة النجاح (الدائرة الخضراء)
            Container(
              width: 85.r,
              height: 85.r,
              decoration: BoxDecoration(
                color: const Color(0xff10B981), // نفس اللون الأخضر في الصورة
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xffD1FAE5), width: 4),
              ),
              child: Icon(Icons.check, color: Colors.white, size: 50.r),
            ),
            SizedBox(height: 24.h),

            // نص النجاح
            Text(
              isSleep
                  ? "Your sleep duration has been saved!"
                  : "Your meal has been saved!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xff1A3B82),
                height: 1.3,
              ),
            ),
            SizedBox(height: 30.h),

            // زر العودة
            AppButton(
              title: "Back to Log",
              width: double.infinity,
              onPressed: () {
                // 🚀 هيمسح كل الشاشات ويفتح الـ HomeView الأصلي بتاعك على تابة الـ Log (الاندكس رقم 2)
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeView(initialIndex: 2),
                  ),
                      (route) => false, // يمسح كاش الصفحات القديمة عشان الكالوريز تتحدث فوراً
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
