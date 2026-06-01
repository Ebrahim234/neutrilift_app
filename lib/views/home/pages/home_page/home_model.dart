class GroupDetail {
  int? id;
  String? groupName;

  GroupDetail({this.id, this.groupName});

  GroupDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupName = json['group_name'];
  }
}

// 🚀 كلاس فرعي جديد لقراءة أيام التمرين من السيرفر
class ExerciseDay {
  int? day;

  ExerciseDay({this.day});

  ExerciseDay.fromJson(Map<String, dynamic> json) {
    day = json['day'];
  }
}

class HomeModel {
  late final String weight;
  late final int dailyCalorieIntake;
  late final String weeklySleepingHours;
  late final bool hasPlan;
  late final bool planFinished;
  late final String dayStatus;
  GroupDetail? groupDetail;
  late final int currentWeek;
  int? exerciseFrequency;
  List<ExerciseDay>? exerciseDays; // 👈 لستة الأيام الديناميكية

  HomeModel.fromJson(Map<String, dynamic> json) {
    weight = json['weight']?.toString() ?? "0.0";
    dailyCalorieIntake = json['daily_calorie_intake'] ?? 0;
    weeklySleepingHours = json['weekly_sleeping_hours']?.toString() ?? "0.0";
    hasPlan = json['has_plan'] ?? false;
    planFinished = json['plan_finished'] ?? false;
    dayStatus = json['day_status'] ?? "";
    groupDetail = json['group_detail'] != null ? GroupDetail.fromJson(json['group_detail']) : null;
    currentWeek = json['current_week'] ?? 1;
    exerciseFrequency = json['exercise_frequency'];

    // 🚀 فك شفرة أيام التمارين الراجعة من السيرفر
    if (json['exercise_days'] != null) {
      exerciseDays = <ExerciseDay>[];
      json['exercise_days'].forEach((v) {
        exerciseDays!.add(ExerciseDay.fromJson(v));
      });
    }
  }
}