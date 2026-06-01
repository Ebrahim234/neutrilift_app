import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../home_model.dart'; // 👈 تأكد من مسار الموديل عندك

class WeekCalender extends StatefulWidget {
  final HomeModel? homeData; // 👈 استلام الداتا لجعل التقويم ديناميكي
  const WeekCalender({super.key, this.homeData});

  @override
  State<WeekCalender> createState() => _WeekCalenderState();
}

class _WeekCalenderState extends State<WeekCalender> {
  // ربط أيام الأسبوع بأرقام الـ ID المعتمدة في السيرفر (الإثنين = 1 إلى الأحد = 7)
  final List<Map<String, dynamic>> daysConfig = [
    {"name": "M", "id": 1, "fullName": "Monday"},
    {"name": "T", "id": 2, "fullName": "Tuesday"},
    {"name": "W", "id": 3, "fullName": "Wednesday"},
    {"name": "T", "id": 4, "fullName": "Thursday"},
    {"name": "F", "id": 5, "fullName": "Friday"},
    {"name": "S", "id": 6, "fullName": "Saturday"},
    {"name": "S", "id": 7, "fullName": "Sunday"},
  ];

  int selectedDay = 1;

  @override
  void initState() {
    super.initState();
    // تحديد اليوم الحالي أوتوماتيكياً من ساعة الموبايل (0 لـ 6)
    selectedDay = DateTime.now().weekday - 1;
  }

  @override
  Widget build(BuildContext context) {
    // استخراج أرقام أيام التمرين من الموديل في قائمة ليسهل فحصها
    List<int> workoutDayIds = widget.homeData?.exerciseDays?.map((e) => e.day ?? 0).toList() ?? [];

    return Container(
      height: 140.h,
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Week ${widget.homeData?.currentWeek ?? 1} • ${daysConfig[selectedDay]["fullName"]}",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                "${widget.homeData?.exerciseFrequency ?? 0} workouts this week",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff9CA3AF)),
              )
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < daysConfig.length; i++)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = i;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: selectedDay == i ? const Color(0xff1A2D6B) : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          daysConfig[i]["name"],
                          style: TextStyle(
                            color: selectedDay == i ? Colors.white : const Color(0xff1A2D6B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // 🚀 النقطة الزرقاء تنير ديناميكياً فقط لو الرقم موجود في قائمة السيرفر
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: workoutDayIds.contains(daysConfig[i]["id"])
                              ? const Color(0xff1A2D6B)
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}