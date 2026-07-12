class UserProfileModel {
  final double weight;
  final double height;
  final int birthYear;
  final String sex;
  final String dailyMovement;
  final int exerciseFrequency;
  final String weightUnit;
  final String heightUnit;

  UserProfileModel({
    required this.weight,
    required this.height,
    required this.birthYear,
    required this.sex,
    required this.dailyMovement,
    required this.exerciseFrequency,
    required this.weightUnit,
    required this.heightUnit,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      weight: double.tryParse(json['weight'].toString()) ?? 0.0,
      height: double.tryParse(json['height'].toString()) ?? 0.0,
      birthYear: json['birth_year'] ?? 2000,
      sex: json['sex'] ?? 'M',
      dailyMovement: json['daily_movement'] ?? 'MD',
      exerciseFrequency: json['exercise_frequency'] ?? 0,
      weightUnit: json['weight_unit'] ?? 'kg',
      heightUnit: json['height_unit'] ?? 'cm',
    );
  }
}

class UserPreferencesModel {
  final int id;
  final String workoutTime;
  final bool isWorkoutEnabled;
  final bool isSleepEnabled;
  final String sleepTime;
  final bool isMealEnabled;
  final String mealTime;
  final String heightUnit;
  final String weightUnit;
  final bool notificationSound;

  UserPreferencesModel({
    required this.id,
    required this.workoutTime,
    required this.isWorkoutEnabled,
    required this.isSleepEnabled,
    required this.sleepTime,
    required this.isMealEnabled,
    required this.mealTime,
    required this.heightUnit,
    required this.weightUnit,
    required this.notificationSound,
  });

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      id: json['id'] ?? 0,
      workoutTime: json['workout_notification_time'] ?? '08:00:00',
      isWorkoutEnabled: json['is_workout_notification_enabled'] ?? false,
      isSleepEnabled: json['is_sleep_enabled'] ?? false,
      sleepTime: json['sleep_time'] ?? '22:00:00',
      isMealEnabled: json['is_meal_log_enabled'] ?? false,
      mealTime: json['meal_log_time'] ?? '14:00:00',
      heightUnit: json['height_unit'] ?? 'cm',
      weightUnit: json['weight_unit'] ?? 'kg',
      notificationSound: json['notification_sound'] ?? true,
    );
  }
}