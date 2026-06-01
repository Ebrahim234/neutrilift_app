import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/ui/app_image.dart'; // مسار الـ AppImage

class SelectableExerciseCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String targetMuscle;
  final bool isSelected;
  final VoidCallback onAddTapped;

  const SelectableExerciseCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.targetMuscle,
    this.isSelected = false,
    required this.onAddTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: AppImage(
              image: imageUrl,
              width: 60.w,
              height: 60.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xff0D1B2A))),
                SizedBox(height: 4.h),
                Text(targetMuscle, style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            onPressed: onAddTapped,
            icon: Icon(
              isSelected ? Icons.check_circle : Icons.add_circle_outline,
              color: isSelected ? const Color(0xff1E2D6E) : Colors.grey,
              size: 28.sp,
            ),
          )
        ],
      ),
    );
  }
}