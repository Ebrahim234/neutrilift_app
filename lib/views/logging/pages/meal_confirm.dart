import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_button.dart';

import 'meal_loading.dart';


class MealConfirmView extends StatefulWidget {
  final File imageFile; // بنستقبل الصورة هنا
  const MealConfirmView({super.key, required this.imageFile});

  @override
  State<MealConfirmView> createState() => _MealConfirmViewState();
}

class _MealConfirmViewState extends State<MealConfirmView> {
  final TextEditingController _drinkController = TextEditingController();

  @override
  void dispose() {
    _drinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.file(widget.imageFile, width: double.infinity, height: 350.h, fit: BoxFit.cover),
              ),
              SizedBox(height: 16.h),
              const Text("If this is a drink, please enter the drink name before confirming.", style: TextStyle(fontSize: 14, color: Color(0xff173273))),
              SizedBox(height: 8.h),
              TextField(
                controller: _drinkController,
                decoration: InputDecoration(
                  hintText: "Enter Drink Name",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context), // الـ Retake بيرجع للكاميرا
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text("Retake", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: AppButton(
                      title: "Confirm",
                      width: double.infinity,
                      onPressed: () {
                       goTo(MealLoadingView(imageFile: widget.imageFile));

                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}