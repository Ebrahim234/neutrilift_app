import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MuscleFilterChips extends StatelessWidget {
  final List<String> muscles;
  final String selectedMuscle;
  final ValueChanged<String> onSelected;

  const MuscleFilterChips({
    super.key,
    required this.muscles,
    required this.selectedMuscle,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: muscles.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final muscle = muscles[i];
          final isSelected = muscle == selectedMuscle;

          return GestureDetector(
            onTap: () => onSelected(muscle),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xff173272)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                muscle[0].toUpperCase() + muscle.substring(1),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13.sp,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}