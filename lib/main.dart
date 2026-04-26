import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/views/plan/automatic/pages/generating_plan.dart';
import 'package:neutrilift/views/plan/automatic/pages/review_plan.dart';

import 'core/logic/helper_method.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Neutrilift',
          theme: ThemeData(
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                minimumSize: Size.fromHeight(50),
                backgroundColor: Color(0xff16347A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            useMaterial3: true,
            fontFamily: "k2d",
            scaffoldBackgroundColor: const Color(0xffD3D3D3),

            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xff6366F1),
              primary: const Color(0xff6366F1),
            ),



            inputDecorationTheme: InputDecorationTheme(
              border: InputBorder.none,

              hintStyle: TextStyle(
                color: const Color(0xff999999),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),

              labelStyle: TextStyle(
                color: const Color(0x665A6690),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          home:ReviewPlanView(),
        );
      },
    );
  }
}
