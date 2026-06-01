import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/ui/app_image.dart'; // مسار الـ AppImage

class ExerciseCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String setsReps;
  final VoidCallback onPlayTapped;

  const ExerciseCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.setsReps,
    required this.onPlayTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: AppImage(
              image: imageUrl,
              width: 70.w,
              height: 70.w,
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
                Text(setsReps, style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            onPressed: onPlayTapped,
            icon: Icon(Icons.play_circle_outline, color: const Color(0xff1E2D6E), size: 28.sp),
          )
        ],
      ),
    );
  }
}