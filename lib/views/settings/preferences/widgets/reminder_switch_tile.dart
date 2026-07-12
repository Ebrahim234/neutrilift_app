import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ReminderSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.time,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(color: const Color(0xff173272), borderRadius: BorderRadius.circular(8.r)),
          child: Icon(icon, color: Colors.white, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6.r)),
                child: Text(time, style: TextStyle(fontSize: 12.sp, color: const Color(0xff173272), fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          activeColor: const Color(0xff173272),
          onChanged: onChanged,
        ),
      ],
    );
  }
}