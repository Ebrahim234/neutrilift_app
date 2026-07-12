class ProgressOverviewModel {
  final List<WeekSummaryModel> weeks;
  final List<ExerciseDayModel> exerciseDays;

  ProgressOverviewModel({
    required this.weeks,
    required this.exerciseDays,
  });

  factory ProgressOverviewModel.fromJson(Map<String, dynamic> json) {
    return ProgressOverviewModel(
      weeks: (json['weeks'] as List?)
          ?.map((e) => WeekSummaryModel.fromJson(e))
          .toList() ??
          [],
      exerciseDays: (json['exercise_days'] as List?)
          ?.map((e) => ExerciseDayModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class WeekSummaryModel {
  final int weekNumber;
  final double sumConsumedCalories;
  final double sumTargetCalories;
  final double sumProtein;
  final double targetProtein;
  final double sumCarbs;
  final double targetCarbs;
  final double sumFats;
  final double targetFats;
  final String weight;
  final double avgSleepHours;
  final String missedDays;

  WeekSummaryModel({
    required this.weekNumber,
    required this.sumConsumedCalories,
    required this.sumTargetCalories,
    required this.sumProtein,
    required this.targetProtein,
    required this.sumCarbs,
    required this.targetCarbs,
    required this.sumFats,
    required this.targetFats,
    required this.weight,
    required this.avgSleepHours,
    required this.missedDays,
  });

  factory WeekSummaryModel.fromJson(Map<String, dynamic> json) {
    return WeekSummaryModel(
      weekNumber: json['week_number'] ?? 1,
      sumConsumedCalories: (json['sum_consumed_calories'] ?? 0).toDouble(),
      sumTargetCalories: (json['sum_target_calories'] ?? 0).toDouble(),
      sumProtein: (json['sum_protein_g'] ?? 0).toDouble(),
      targetProtein: (json['p_percn_targ'] ?? 0).toDouble(),
      sumCarbs: (json['sum_carbs_g'] ?? 0).toDouble(),
      targetCarbs: (json['c_percn_targ'] ?? 0).toDouble(),
      sumFats: (json['sum_fats_g'] ?? 0).toDouble(),
      targetFats: (json['f_percn_targ'] ?? 0).toDouble(),
      weight: json['weight']?.toString() ?? '0.0',
      avgSleepHours: (json['avg_sleep_hours'] ?? 0).toDouble(),
      missedDays: json['missed_days']?.toString() ?? '',
    );
  }
}

class ExerciseDayModel {
  final int day;
  final String groupName;

  ExerciseDayModel({
    required this.day,
    required this.groupName,
  });

  factory ExerciseDayModel.fromJson(Map<String, dynamic> json) {
    return ExerciseDayModel(
      day: json['day'] ?? 0,
      groupName: json['group_name'] ?? 'Workout',
    );
  }
}