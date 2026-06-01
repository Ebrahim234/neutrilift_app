class ExerciseModel {
  final int id;
  final String name;
  final String image;
  final String? muscle;

  final bool hasWeight;
  final bool hasSets;
  final bool hasReps;
  final bool hasDuration;

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
      id: json['id'] ?? json['exercise'] ?? 0,
      name: json['name'] ?? 'Unknown Exercise',
      image: json['image'] ?? '',
      muscle: json['muscle'],
      hasWeight: json['weight'] != null,
      hasSets: json['sets'] != null,
      hasReps: json['reps'] != null,
      hasDuration: json['duration'] != null,
      weight: json['weight'] != null ? double.parse(json['weight'].toString()).toInt() : null,
      sets: json['sets'] != null ? double.parse(json['sets'].toString()).toInt() : null,
      reps: json['reps'] != null ? double.parse(json['reps'].toString()).toInt() : null,
      duration: json['duration'] != null
          ? double.parse(json['duration'].toString()).toInt()
          : null,
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

  Map<String, dynamic> toJson({int order = 1}) {
    final map = <String, dynamic>{
      'exercise': id,
      'order': order,
    };
    if (hasWeight) map['weight'] = weight ?? 0;
    if (hasSets) map['sets'] = sets ?? 0;
    if (hasReps) map['reps'] = reps ?? 0;
    if (hasDuration) map['duration'] = (duration ?? 0).toDouble();
    return map;
  }
}