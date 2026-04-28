class ExerciseModel {
  final int id;
  final String name;
  final String image;
  final String? muscle;

  // which attributes this exercise supports (null = not supported)
  final bool hasWeight;
  final bool hasSets;
  final bool hasReps;
  final bool hasDuration;

  // user-filled values
  final int? weight;
  final int? sets;
  final int? reps;
  final int? duration;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.image,
    this.muscle,
    this.hasWeight = false,
    this.hasSets = false,
    this.hasReps = false,
    this.hasDuration = false,
    this.weight,
    this.sets,
    this.reps,
    this.duration,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      muscle: json['muscle'],
      hasWeight: json['weight'] != null,
      hasSets: json['sets'] != null,
      hasReps: json['reps'] != null,
      hasDuration: json['duration'] != null,
    );
  }

  ExerciseModel copyWith({
    int? weight,
    int? sets,
    int? reps,
    int? duration,
  }) {
    return ExerciseModel(
      id: id,
      name: name,
      image: image,
      muscle: muscle,
      hasWeight: hasWeight,
      hasSets: hasSets,
      hasReps: hasReps,
      hasDuration: hasDuration,
      weight: weight ?? this.weight,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'id': id};
    if (hasWeight) map['weight'] = weight ?? 0;
    if (hasSets) map['sets'] = sets ?? 0;
    if (hasReps) map['reps'] = reps ?? 0;
    if (hasDuration) map['duration'] = duration ?? 0;
    return map;
  }
}