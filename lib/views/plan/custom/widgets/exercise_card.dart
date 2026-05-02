import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/models/exercise_model.dart';
import 'attribute_row.dart';
import 'badge_chip.dart';

class ExerciseCard extends StatelessWidget {
  final ExerciseModel exercise;
  final bool isExpanded;
  final bool isAdded;
  final ExerciseModel? addedExercise;
  final VoidCallback onToggleExpand;
  final ValueChanged<ExerciseModel> onExerciseChanged;
  final VoidCallback onAddExercise;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.isExpanded,
    required this.isAdded,
    required this.addedExercise,
    required this.onToggleExpand,
    required this.onExerciseChanged,
    required this.onAddExercise,
  });

  @override
  Widget build(BuildContext context) {
    final current = addedExercise ??
        exercise.copyWith(
          sets: exercise.hasSets ? (exercise.sets ?? 4) : null,
          reps: exercise.hasReps ? (exercise.reps ?? 4) : null,
          weight: exercise.hasWeight ? (exercise.weight ?? 4) : null,
          duration: exercise.hasDuration ? (exercise.duration ?? 30) : null,
        );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main row
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                // image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.network(
                    '${ApiHelper.baseUrl}${exercise.image}',
                    width: 64.w,
                    height: 64.h,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 64.w,
                      height: 64.h,
                      color: const Color(0xffF3F4F6),
                      child: const Icon(Icons.fitness_center,
                          color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // name + muscle / badges
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      if (isAdded && addedExercise != null)
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (addedExercise!.hasSets)
                              BadgeChip(label: '${addedExercise!.sets ?? 0} sets'),
                            if (addedExercise!.hasReps)
                              BadgeChip(label: '${addedExercise!.reps ?? 0} reps'),
                            if (addedExercise!.hasWeight)
                              BadgeChip(label: '${addedExercise!.weight ?? 0} kg'),
                            if (addedExercise!.hasDuration)
                              BadgeChip(label: '${addedExercise!.duration ?? 0} min'),
                          ],
                        )
                      else
                        Text(
                          exercise.muscle ?? '',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                        ),
                    ],
                  ),
                ),

                // + / edit button
                GestureDetector(
                  onTap: onToggleExpand,
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: isAdded
                          ? const Color(0xff173272)
                          : const Color(0xffF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isAdded ? Icons.edit_rounded : Icons.add,
                      size: 18.sp,
                      color: isAdded ? Colors.white : const Color(0xff173272),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Expanded config
          if (isExpanded) ...[
            Divider(height: 1, color: Colors.grey.shade100),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
              child: Column(
                children: [
                  if (current.hasSets)
                    AttributeRow(
                      label: 'Set',
                      value: current.sets ?? 4,
                      onChanged: (v) =>
                          onExerciseChanged(current.copyWith(sets: v)),
                    ),
                  if (current.hasReps)
                    AttributeRow(
                      label: 'Reps',
                      value: current.reps ?? 4,
                      onChanged: (v) =>
                          onExerciseChanged(current.copyWith(reps: v)),
                    ),
                  if (current.hasWeight)
                    AttributeRow(
                      label: 'Weight',
                      value: current.weight ?? 4,
                      onChanged: (v) =>
                          onExerciseChanged(current.copyWith(weight: v)),
                    ),
                  if (current.hasDuration)
                    AttributeRow(
                      label: 'Duration (min)',
                      value: current.duration ?? 30,
                      onChanged: (v) =>
                          onExerciseChanged(current.copyWith(duration: v)),
                    ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onAddExercise,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xff173272),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: const Text('Add Exercise'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}