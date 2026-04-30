import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_back.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/models/exercise_model.dart';
import 'package:neutrilift/models/routine_model.dart';
import 'build_weekly_plan.dart';
import 'widgets/exercise_card.dart';
import 'widgets/muscle_filter_chips.dart';
import 'widgets/save_routine_dialog.dart';

class SelectWorkoutsView extends StatefulWidget {
  final int weekCount;
  final List<Map<String, dynamic>> weeksCalories;
  final List<RoutineModel> existingRoutines; // ✅ استقبال الـ routines الموجودة

  const SelectWorkoutsView({
    super.key,
    required this.weekCount,
    required this.weeksCalories,
    this.existingRoutines = const [], // ✅ default فاضي
  });

  @override
  State<SelectWorkoutsView> createState() => _SelectWorkoutsViewState();
}

class _SelectWorkoutsViewState extends State<SelectWorkoutsView> {
  final dio = ApiHelper.createDio();
  final searchController = TextEditingController();

  List<ExerciseModel> exercises = [];
  List<String> muscles = ['All'];
  String selectedMuscle = 'All';
  bool isLoading = true;

  int? expandedIndex;
  final Map<int, ExerciseModel> addedExercises = {};
  late final List<RoutineModel> savedRoutines; // ✅ late لأننا بنبدأ بالموجود

  @override
  void initState() {
    super.initState();
    savedRoutines = List.from(widget.existingRoutines); // ✅ نبدأ بالموجود
    _fetchMuscles();
    _fetchExercises();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchMuscles() async {
    try {
      final res = await dio.get('/api/muscles/');
      final list = (res.data as List).map((e) => e.toString()).toList();
      setState(() => muscles = ['All', ...list]);
    } catch (_) {}
  }

  Future<void> _fetchExercises({String? name, String? muscle}) async {
    setState(() => isLoading = true);
    try {
      final params = <String, dynamic>{};
      if (name != null && name.isNotEmpty) params['name'] = name;
      if (muscle != null && muscle != 'All') params['muscle'] = muscle;

      final res =
      await dio.get('/api/exercises/', queryParameters: params);
      final list = (res.data as List)
          .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList();

      setState(() {
        exercises = list;
        isLoading = false;
      });
    } catch (e) {
      print('❌ ERROR: $e'); // ✅ اطبع الـ error
      setState(() => isLoading = false);
    }
  }

  void _onSearch(String val) => _fetchExercises(
    name: val.isEmpty ? null : val,
    muscle: selectedMuscle == 'All' ? null : selectedMuscle,
  );

  void _onMuscleFilter(String muscle) {
    setState(() {
      selectedMuscle = muscle;
      expandedIndex = null;
    });
    _fetchExercises(
      name: searchController.text.isEmpty ? null : searchController.text,
      muscle: muscle == 'All' ? null : muscle,
    );
  }

  void _showSaveRoutineDialog() {
    if (addedExercises.isEmpty) {
      showMsg('Add at least one exercise first', isError: true);
      return;
    }
    showDialog(
      context: context,
      builder: (_) => SaveRoutineDialog(
        onAddAnotherSet: () => setState(() => addedExercises.clear()),
        onNext: _saveRoutine,
      ),
    );
  }

  void _saveRoutine(String name) {
    final exercisesList = addedExercises.values.toList();
    final routine = RoutineModel(name: name, exercises: exercisesList);

    setState(() {
      savedRoutines.add(routine);
      addedExercises.clear();
    });

    // ✅ pushReplacement عشان يروح لـ BuildWeeklyPlanView
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BuildWeeklyPlanView(
          weekCount: widget.weekCount,
          weeksCalories: widget.weeksCalories,
          savedRoutines: savedRoutines,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F0F0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBack(),
                  SizedBox(height: 4.h),
                  Text(
                    'Select Your Workouts',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Choose exercises for your custom plan',
                    style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                  ),
                  SizedBox(height: 14.h),

                  // ── Search ──────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: _onSearch,
                      decoration: InputDecoration(
                        hintText: 'Search exercises...',
                        hintStyle: TextStyle(
                            color: const Color(0xff9CA3AF), fontSize: 14.sp),
                        prefixIcon: const Icon(Icons.search,
                            color: Color(0xff9CA3AF)),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 14.h),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // ── Muscle filter chips ─────────────────────
                  MuscleFilterChips(
                    muscles: muscles,
                    selectedMuscle: selectedMuscle,
                    onSelected: _onMuscleFilter,
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),

            // ── Exercise list ─────────────────────────────────
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : exercises.isEmpty
                  ? Center(
                child: Text(
                  'No exercises found',
                  style:
                  TextStyle(color: Colors.grey, fontSize: 14.sp),
                ),
              )
                  : ListView.separated(
                padding:
                EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                itemCount: exercises.length,
                separatorBuilder: (_, __) =>
                    SizedBox(height: 10.h),
                itemBuilder: (_, i) {
                  final ex = exercises[i];
                  return ExerciseCard(
                    exercise: ex,
                    isExpanded: expandedIndex == i,
                    isAdded: addedExercises.containsKey(ex.id),
                    addedExercise: addedExercises[ex.id],
                    onToggleExpand: () => setState(() =>
                    expandedIndex =
                    expandedIndex == i ? null : i),
                    onExerciseChanged: (updated) => setState(
                            () => addedExercises[ex.id] = updated),
                    onAddExercise: () => setState(() {
                      addedExercises[ex.id] =
                          addedExercises[ex.id] ??
                              ex.copyWith(
                                sets: ex.hasSets
                                    ? (ex.sets ?? 4)
                                    : null,
                                reps: ex.hasReps
                                    ? (ex.reps ?? 4)
                                    : null,
                                weight: ex.hasWeight
                                    ? (ex.weight ?? 4)
                                    : null,
                                duration: ex.hasDuration
                                    ? (ex.duration ?? 30)
                                    : null,
                              );
                      expandedIndex = null;
                    }),
                  );
                },
              ),
            ),

            // ── Add exercises button ──────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: AppButton(
                title: 'Add exercises',
                width: double.infinity,
                onPressed: _showSaveRoutineDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
