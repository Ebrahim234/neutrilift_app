import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/views/logging/pages/logging_success_dialog.dart';
import 'package:neutrilift/views/logging/view.dart';

class MealDetailsView extends StatelessWidget {
  final File imageFile;
  const MealDetailsView({super.key, required this.imageFile});

  // void _showSuccessDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
  //         child: Padding(
  //           padding: EdgeInsets.all(24.w),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 padding: EdgeInsets.all(12.w),
  //                 decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF00BFA5), width: 2)),
  //                 child: Icon(Icons.check, color: const Color(0xFF00BFA5), size: 40.sp),
  //               ),
  //               SizedBox(height: 16.h),
  //               Text(
  //                 "Your meal has been saved!",
  //                 style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xff0D1B2A)),
  //                 textAlign: TextAlign.center,
  //               ),
  //               SizedBox(height: 24.h),
  //               AppButton(
  //                 title: "Back to Log",
  //                 width: double.infinity,
  //                 onPressed: () {
  //                   // الكود ده بيقفل كل الصفحات اللي فتحناها لحد ما يوصل للصفحة الأساسية
  //                   Navigator.of(context).popUntil((route) => route.isFirst);
  //                 },
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
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
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Grilled Chicken & Rice", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _macroItem("Fats", "95"),
                        _macroItem("Carbs", "37"),
                        _macroItem("Protein", "100"),
                        _macroItem("Calories", "356"),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              AppButton(
                title: "Save meal",
                width: double.infinity,
                onPressed: () {goTo(LoggingSuccessDialog(isSleep: false));},
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _macroItem(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.w500)),
        SizedBox(height: 8.h),
        Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xff0D1B2A))),
      ],
    );
  }
}