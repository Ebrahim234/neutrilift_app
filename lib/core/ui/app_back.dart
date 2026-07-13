import 'package:flutter/material.dart';
import '../../views/home/pages/home main view.dart';
class AppBack extends StatelessWidget {

  const AppBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: IconButton(
        onPressed: () {
          if (Navigator.canPop(context)) {
            // 1. لو الشاشة دي مفتوحة فوق شاشة تانية، هيرجع طبيعي جداً لورا
            Navigator.pop(context);
          } else {
            // 2. 🎯 لو مفتوحة كـ تابة (الـ Stack فاضي)، هينقله فوراً لتابة الـ Home (الاندكس 0) بدون شاشة سودة!
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeView(initialIndex: 0)), // يفتح على أول تابة
                  (route) => false, // يمسح أي كاش قديم
            );
          }
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Color(0xff173272), // لون تطبيقك الأزرق المعتمد
        ),
      )
    );
  }
}
