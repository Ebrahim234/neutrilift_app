import 'exercise_model.dart';

class RoutineModel {
  final int? id;
  final String name;
  final List<ExerciseModel> exercises;

  const RoutineModel({
    this.id,
    required this.name,
    required this.exercises,
  });

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    return RoutineModel(
      id: json['id'],
      name: json['group_name'] ?? json['name'] ?? 'Unknown Routine',
      exercises: (json['exercises'] as List?)
          ?.map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}