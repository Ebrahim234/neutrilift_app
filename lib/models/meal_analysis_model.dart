class MealAnalysisModel {
  final List<MealItem> items;
  final double proteinG;
  final double carbsG;
  final double fatsG;
  final double totalCalories;
  final double drinkCalories;
  final double foodCalories;
  final List<String> mealBalance;

  MealAnalysisModel({
    required this.items,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    required this.totalCalories,
    required this.drinkCalories,
    required this.foodCalories,
    required this.mealBalance,
  });

  factory MealAnalysisModel.fromJson(Map<String, dynamic> json) {
    return MealAnalysisModel(
      items: (json['items'] as List?)?.map((x) => MealItem.fromJson(x)).toList() ?? [],
      proteinG: (json['protein_g'] as num?)?.toDouble() ?? 0.0,
      carbsG: (json['carbs_g'] as num?)?.toDouble() ?? 0.0,
      fatsG: (json['fats_g'] as num?)?.toDouble() ?? 0.0,
      totalCalories: (json['total_calories'] as num?)?.toDouble() ?? 0.0,
      drinkCalories: (json['drink_calories'] as num?)?.toDouble() ?? 0.0,
      foodCalories: (json['food_calories'] as num?)?.toDouble() ?? 0.0,
      // تجميع الـ Array الجديدة وتحويلها لـ نصوص صريحة بأمان لمنع الـ Type Casting Error
      mealBalance: List<String>.from(json['meal_balance'] ?? []),
    );
  }
}

class MealItem {
  final String name;
  final String type;
  final String portion;
  final double calories;
  final double confidence;

  MealItem({
    required this.name,
    required this.type,
    required this.portion,
    required this.calories,
    required this.confidence,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      portion: json['portion'] ?? '',
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }
}