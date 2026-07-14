import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/views/home/pages/home main view.dart';
import 'package:neutrilift/views/home/pages/home_page/home_controller.dart';
import 'package:neutrilift/views/home/pages/home_page/home_model.dart';

class MyPlanView extends StatefulWidget {
  final HomeModel? homeData;
  const MyPlanView({super.key, this.homeData});

  @override
  State<MyPlanView> createState() => _MyPlanViewState();
}

class _MyPlanViewState extends State<MyPlanView> {
  final _controller = HomeController();
  bool isDeleting = false;

  void _showDeleteConfirmation(BuildContext screenContext) { // 🚀 سميناه screenContext (بتاع الشاشة)
    const Color brandBlue = Color(0xff173272);

    showDialog(
      context: screenContext,
      builder: (dialogContext) => AlertDialog( // 🚀 سميناه dialogContext (بتاع الديالوج بس)
        title: const Text("Delete Plan?", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to delete your current plan and build a new one?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), // إغلاق الديالوج بـ dialogContext
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffEF4444)),
            onPressed: () async {
              Navigator.pop(dialogContext); // 🚀 1. قفل الديالوج فوراً بـ dialogContext
              setState(() => isDeleting = true);

              // طلب الحذف من السيرفر
              await _controller.deletePlan().timeout(
                const Duration(seconds: 2),
                onTimeout: () => null,
              );

              if (mounted) {
                setState(() => isDeleting = false);
                // 🚀 2. قفل الشاشة والرجوع للهوم بـ screenContext الشغال والمأمن!
                Navigator.pop(screenContext, true);
              }
            },
            child: const Text("Yes, Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xff173272);
    bool isAutomatic = widget.homeData?.dayStatus != "custom";

    return Scaffold(
      backgroundColor: const Color(0xffF5F6F9),
      body: SafeArea(
        child: isDeleting
            ? const Center(child: CircularProgressIndicator(color: brandBlue))
            : SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: brandBlue),
              ),
              SizedBox(height: 10.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Plan",
                        style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: brandBlue),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Manage Your Workout Plan",
                        style: TextStyle(fontSize: 14.sp, color: const Color(0xff9CA3AF)),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _showDeleteConfirmation(context),
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: const Color(0xffFEE2E2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.delete_rounded,
                        color: const Color(0xffEF4444),
                        size: 24.r,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Week 1", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: brandBlue)),
                    Text("Monday", style: TextStyle(fontSize: 16.sp, color: brandBlue, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: brandBlue,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAutomatic ? "Automatic Plan" : "Custom Plan",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.h),
                    _buildPlanDetailRow("Duration", "12 weeks"),
                    SizedBox(height: 12.h),
                    _buildPlanDetailRow("Goal", isAutomatic ? "Lose weight" : "Custom Workout Routine"),
                    SizedBox(height: 12.h),
                    _buildPlanDetailRow("Weekly Workouts", "${widget.homeData?.exerciseFrequency ?? 5} sessions"),
                    SizedBox(height: 12.h),
                    _buildPlanDetailRow("Weight to lose", "${widget.homeData?.weight ?? '10'} Kg"),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "${widget.homeData?.dailyCalorieIntake ?? 1700}",
                            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xff1E293B)),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Calories Taken",
                            style: TextStyle(fontSize: 12.sp, color: const Color(0xff9CA3AF)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "2100",
                            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xff10B981)),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Intake Target",
                            style: TextStyle(fontSize: 12.sp, color: const Color(0xff9CA3AF)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    Text(
                      "5",
                      style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: brandBlue),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Weeks Left",
                      style: TextStyle(fontSize: 12.sp, color: const Color(0xff9CA3AF)),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: const BoxDecoration(
                        color: brandBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.fitness_center_rounded, color: Colors.white, size: 18.r),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "Assign Workouts",
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: const Color(0xff1E293B)),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: const Color(0xffF3F4F6),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(Icons.edit_rounded, color: brandBlue, size: 16.r),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanDetailRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}