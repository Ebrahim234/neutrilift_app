import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_back.dart';
import 'package:neutrilift/models/settings_models.dart';
// استدعاء الـ widgets اللي فصلناها
import 'widgets/reminder_switch_tile.dart';
import 'widgets/unit_toggle_buttons.dart';

class PreferencesView extends StatefulWidget {
  const PreferencesView({super.key});

  @override
  State<PreferencesView> createState() => _PreferencesViewState();
}

class _PreferencesViewState extends State<PreferencesView> {
  final dio = ApiHelper.createDio();
  bool isLoading = true;

  bool isWorkoutEnabled = false;
  bool isNutritionEnabled = false;
  bool isSleepEnabled = false;
  bool isSoundEnabled = true;

  String weightUnit = 'kg';
  String heightUnit = 'cm';

  @override
  void initState() {
    super.initState();
    _fetchPreferences();
  }

  Future<void> _fetchPreferences() async {
    try {
      final response = await dio.get('/api/user_preferences/');
      final pref = UserPreferencesModel.fromJson(response.data);

      setState(() {
        isWorkoutEnabled = pref.isWorkoutEnabled;
        isSleepEnabled = pref.isSleepEnabled;
        isNutritionEnabled = pref.isMealEnabled;
        isSoundEnabled = pref.notificationSound;
        weightUnit = pref.weightUnit;
        heightUnit = pref.heightUnit;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching preferences: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _updatePreference(Map<String, dynamic> data) async {
    try {
      await dio.patch('/api/user_preferences/', data: data);
    } catch (e) {
      print('Error updating preference: $e');
      showMsg('Failed to update. Please try again.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F0F0),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xff173272)))
            : SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBack(),
              SizedBox(height: 12.h),
              Text('App Preferences', style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 24.h),

              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
                child: Column(
                  children: [
                    // استخدام الـ Widget المفصول
                    ReminderSwitchTile(
                      icon: Icons.fitness_center,
                      title: 'Workout Reminder',
                      time: '8:00 Am',
                      value: isWorkoutEnabled,
                      onChanged: (val) {
                        setState(() => isWorkoutEnabled = val);
                        _updatePreference({'is_workout_notification_enabled': val});
                      },
                    ),
                    Divider(height: 30.h, color: Colors.grey[200]),
                    ReminderSwitchTile(
                      icon: Icons.restaurant,
                      title: 'Nutrition Reminder',
                      time: '2:00 Pm',
                      value: isNutritionEnabled,
                      onChanged: (val) {
                        setState(() => isNutritionEnabled = val);
                        _updatePreference({'is_meal_log_enabled': val});
                      },
                    ),
                    Divider(height: 30.h, color: Colors.grey[200]),
                    ReminderSwitchTile(
                      icon: Icons.nightlight_round,
                      title: 'Sleep Reminder',
                      time: '10:00 Pm',
                      value: isSleepEnabled,
                      onChanged: (val) {
                        setState(() => isSleepEnabled = val);
                        _updatePreference({'is_sleep_enabled': val});
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: const BoxDecoration(color: Color(0xff0EA5E9), shape: BoxShape.circle),
                      child: Icon(Icons.volume_up, color: Colors.white, size: 20.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(child: Text('Notification Sound', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500))),
                    Switch(
                      value: isSoundEnabled,
                      activeColor: const Color(0xff173272),
                      onChanged: (val) {
                        setState(() => isSoundEnabled = val);
                        _updatePreference({'notification_sound': val});
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              Text('Weight Units', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 8.h),
              Row(
                children: [
                  // استخدام الـ Widget المفصول
                  UnitToggleButton(
                      title: 'Kilogram (kg)',
                      value: 'kg',
                      groupValue: weightUnit,
                      onChanged: (val) {
                        setState(() => weightUnit = val);
                        _updatePreference({'weight_unit': val});
                      }
                  ),
                  SizedBox(width: 12.w),
                  UnitToggleButton(
                      title: 'Pounds (lb)',
                      value: 'lb',
                      groupValue: weightUnit,
                      onChanged: (val) {
                        setState(() => weightUnit = val);
                        _updatePreference({'weight_unit': val});
                      }
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text('Height Units', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 8.h),
              Row(
                children: [
                  UnitToggleButton(
                      title: 'Centimeters (cm)',
                      value: 'cm',
                      groupValue: heightUnit,
                      onChanged: (val) {
                        setState(() => heightUnit = val);
                        _updatePreference({'height_unit': val});
                      }
                  ),
                  SizedBox(width: 12.w),
                  UnitToggleButton(
                      title: 'Feet (ft)',
                      value: 'ft',
                      groupValue: heightUnit,
                      onChanged: (val) {
                        setState(() => heightUnit = val);
                        _updatePreference({'height_unit': val});
                      }
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}