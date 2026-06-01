import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActiveWorkoutBar extends StatelessWidget {
  final String groupName;
  final String timerText;
  final VoidCallback onPause;
  final VoidCallback onEnd;

  const ActiveWorkoutBar({
    super.key,
    required this.groupName,
    required this.timerText,
    required this.onPause,
    required this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xff1E2D6E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(groupName, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Container(width: 8.w, height: 8.w, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                      SizedBox(width: 8.w),
                      Text("Active Workout", style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(timerText, style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold)),
                  Text("DURATION", style: TextStyle(color: Colors.white70, fontSize: 10.sp)),
                ],
              )
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onPause,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  icon: const Icon(Icons.pause, color: Colors.white),
                  label: const Text("Pause", style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onEnd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffE53935), // لون أحمر
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text("End Workout", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}