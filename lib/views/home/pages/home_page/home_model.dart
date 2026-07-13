class ExerciseDay {
  final int? day;
  final int? groupId;
  final String? groupName;

  ExerciseDay({this.day, this.groupId, this.groupName});

  factory ExerciseDay.fromJson(Map<String, dynamic> json) {
    return ExerciseDay(
      day: (json['day'] as num?)?.toInt(),
      groupId: (json['group_id'] as num?)?.toInt() ?? (json['groupId'] as num?)?.toInt(),
      groupName: json['group_name'] ?? json['groupName'],
    );
  }
}

class HomeModel {
  final bool hasPlan;
  final bool planFinished;
  final String dayStatus;
  final int dailyCalorieIntake;
  final int steps;
  final int heartRate;
  final String weeklySleepingHours;
  final String weight;
  final List<ExerciseDay>? exerciseDays;
  final int currentWeek;
  final int exerciseFrequency;

  HomeModel({
    required this.hasPlan,
    required this.planFinished,
    required this.dayStatus,
    required this.dailyCalorieIntake,
    required this.steps,
    required this.heartRate,
    required this.weeklySleepingHours,
    required this.weight,
    this.exerciseDays,
    required this.currentWeek,
    required this.exerciseFrequency,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    List<ExerciseDay> parsedDays = [];
    if (json['exercise_days'] != null) {
      parsedDays = (json['exercise_days'] as List)
          .map((e) => ExerciseDay.fromJson(e))
          .toList();
    }

    return HomeModel(
      hasPlan: json['has_plan'] ?? false,
      planFinished: json['plan_finished'] ?? false,
      dayStatus: json['day_status'] ?? "off",
      dailyCalorieIntake: (json['daily_calorie_intake'] as num?)?.toInt() ?? 0,
      steps: (json['steps'] as num?)?.toInt() ?? 0,
      heartRate: (json['heart_rate'] as num?)?.toInt() ?? 72,
      weeklySleepingHours: (json['weekly_sleeping_hours'] ?? "0.0").toString(),
      weight: (json['weight'] ?? "0.0").toString(),
      exerciseDays: parsedDays,
      currentWeek: (json['current_week'] as num?)?.toInt() ?? 1,
      exerciseFrequency: (json['exercise_frequency'] as num?)?.toInt() ?? parsedDays.length,
    );
  }
}