import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/ui/app_image.dart';

class ReviewCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isEdit;

  const ReviewCard({
    super.key,
    required this.label,
    required this.value,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8),
      child: Container(
        padding: EdgeInsetsDirectional.all(12),
        height: 68.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffF3F4F61A).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffFFFFFF).withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            if (isEdit)
              IconButton(
                onPressed: () {},
                icon: AppImage(image: "edit.svg"),
              ),
          ],
        ),
      ),
    );
  }
}