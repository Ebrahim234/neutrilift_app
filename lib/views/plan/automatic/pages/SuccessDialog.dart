import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/ui/app_image.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xffFFFFFF),
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.all(16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImage(image: "plan_saved.svg"),
            SizedBox(height: 8.h),
            Text(
              "Plan Saved!",
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xff173273),
              ),
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                Expanded(
                  child: SavedPlanCard(
                    icon: "blue_goal.svg",
                    label: "Goal",
                    value: "Weight Loss",
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: SavedPlanCard(
                    icon: "duration.svg",
                    label: "Duration",
                    value: "12 weeks",
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            SavedPlanCard(
              icon: "frequency.svg",
              label: "Frequency",
              value: "5 days/week",
            ),
          ],
        ),
      ),
    );
  }
}

class SavedPlanCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const SavedPlanCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        vertical: 12.h,
        horizontal: 16.w,
      ),
      height: 64.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Color(0xffD8D8D8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch, 
        children: [
          Row(
            children: [
              AppImage(
                image: icon,
                height: 16.h,
                width: 16.w,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff173273),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.2,
              fontWeight: FontWeight.w400,
              color: Color(0xff173273),
            ),
          ),
        ],
      ),
    );
  }
}