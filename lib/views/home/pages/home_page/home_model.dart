class HomeModel {
  late final String weight;
  late final int dailyCalorieIntake;
  late final String weeklySleepingHours;
  late final bool hasPlan;
  late final bool planFinished;
  late final String dayStatus;
  late final String groupName;
  late final int currentWeek;
  late final Null exerciseFrequency;

  HomeModel.fromJson(Map<String, dynamic> json){
    weight = json['weight'];
    dailyCalorieIntake = json['daily_calorie_intake'];
    weeklySleepingHours = json['weekly_sleeping_hours'];
    hasPlan = json['has_plan'];
    planFinished = json['plan_finished'];
    dayStatus = json['day_status'];
    groupName = json['group_name'];
    currentWeek = json['current_week'];
    exerciseFrequency = null;
  }

}