import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/models/progress_model.dart';

class WeeklyLogCard extends StatelessWidget {
  final List<ExerciseDayModel> exerciseDays;
  final String missedDaysStr;

  const WeeklyLogCard({
    super.key,
    required this.exerciseDays,
    required this.missedDaysStr,
  });

  @override
  Widget build(BuildContext context) {
    // أسماء الأيام (ممكن تعدل ترتيبها حسب ما الباك إند بيبعت الـ Day Index)
    // بافتراض إن 1 = السبت, 2 = الأحد ... 7 = الجمعة
    final List<String> weekDays = [
      'Saturday', 'Sunday', 'Monday', 'Tuesday',
      'Wednesday', 'Thursday', 'Friday'
    ];

    List<Map<String, dynamic>> generatedDays = [];

    for (int i = 0; i < 7; i++) {
      int apiDayIndex = i + 1; // للبحث في الـ API
      String dayName = weekDays[i];

      // هل اليوم ده متسجل تمرين في الـ API؟
      final exercise = exerciseDays.where((e) => e.day == apiDayIndex).firstOrNull;

      bool isRest = exercise == null;
      String type = isRest ? 'Rest day' : exercise.groupName;

      // هل اليوم ده في قائمة الأيام اللي اتفوتت (Missed)؟
      bool isMissed = missedDaysStr.contains(apiDayIndex.toString());
      String status = isMissed ? 'missed' : 'done';

      if (isMissed && !isRest) type = 'Missed workout';

      generatedDays.add({
        'day': dayName,
        'type': type,
        'isRest': isRest,
        'status': status,
      });
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: generatedDays.map((dayData) => _buildDayItem(dayData)).toList(),
      ),
    );
  }

  Widget _buildDayItem(Map<String, dynamic> data) {
    final bool isRest = data['isRest'];
    final bool isDone = data['status'] == 'done';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: isRest ? const Color(0xff8B98B2) : const Color(0xff173272),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              isRest ? Icons.nightlight_round : Icons.fitness_center,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['day'],
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                ),
                Text(
                  data['type'],
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: isDone ? const Color(0xffD1FAE5) : const Color(0xffFEE2E2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDone ? Icons.check : Icons.close,
              color: isDone ? const Color(0xff10B981) : const Color(0xffEF4444),
              size: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}