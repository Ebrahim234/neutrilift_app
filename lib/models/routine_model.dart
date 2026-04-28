import 'exercise_model.dart';

class RoutineModel {
  final int id;
  final String name;
  final List<ExerciseModel> exercises;

  const RoutineModel({
    required this.id,
    required this.name,
    required this.exercises,
  });
}