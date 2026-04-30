import 'exercise_model.dart';

class RoutineModel {
  final String name;
  final List<ExerciseModel> exercises;

  const RoutineModel({
    required this.name,
    required this.exercises,
  });
}