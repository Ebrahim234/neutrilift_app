import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_back.dart';
import 'package:neutrilift/models/settings_models.dart';

// استدعاء الـ widgets اللي فصلناها (تم حذف التكرار من هنا)
import 'widgets/delete_account_dialog.dart';
import 'widgets/gender_selector.dart';
import 'widgets/movement_option_card.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final dio = ApiHelper.createDio();
  bool isLoading = true;
  bool isSaving = false;

  final nameController = TextEditingController(text: 'Mohamed Al-ashry');
  final birthYearController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final frequencyController = TextEditingController();

  String selectedGender = 'M';
  String selectedMovement = 'MD';

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  @override
  void dispose() {
    nameController.dispose();
    birthYearController.dispose();
    heightController.dispose();
    weightController.dispose();
    frequencyController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfileData() async {
    try {
      final response = await dio.get('/api/userprofile/');
      final profile = UserProfileModel.fromJson(response.data);

      setState(() {
        birthYearController.text = profile.birthYear.toString();
        heightController.text = profile.height.toString();
        weightController.text = profile.weight.toString();
        frequencyController.text = profile.exerciseFrequency.toString();
        selectedGender = profile.sex;
        selectedMovement = profile.dailyMovement;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching profile: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveChanges() async {
    setState(() => isSaving = true);
    try {
      final data = {
        'weight': weightController.text,
        'height': heightController.text,
        'birth_year': int.tryParse(birthYearController.text),
        'sex': selectedGender,
        'daily_movement': selectedMovement,
        'exercise_frequency': int.tryParse(frequencyController.text),
      };

      await dio.patch('/api/userprofile/', data: data);
      showMsg('Profile updated successfully!', isError: false);
    } catch (e) {
      print('Error saving profile: $e');
      showMsg('Failed to save changes.', isError: true);
    } finally {
      setState(() => isSaving = false);
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => DeleteAccountDialog(
        onDelete: (password) {
          print('Delete requested with pass: $password');
        },
      ),
    );
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
              Text('Profile', style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 24.h),

              _buildLabel('Full Name'),
              _buildTextField(nameController, 'Enter your name'),
              SizedBox(height: 16.h),

              _buildLabel('Birth year'),
              _buildTextField(birthYearController, 'e.g. 2000', keyboardType: TextInputType.number),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Height (cm)'),
                        _buildTextField(heightController, '175', keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Weight (kg)'),
                        _buildTextField(weightController, '70', keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              _buildLabel('Gender'),
              Row(
                children: [
                  GenderSelectorButton(
                    title: 'Male',
                    value: 'M',
                    groupValue: selectedGender,
                    onChanged: (val) => setState(() => selectedGender = val),
                  ),
                  SizedBox(width: 12.w),
                  GenderSelectorButton(
                    title: 'Female',
                    value: 'F',
                    groupValue: selectedGender,
                    onChanged: (val) => setState(() => selectedGender = val),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              _buildLabel('Weekly Exercise Frequency'),
              _buildTextField(frequencyController, '0-7 Days', keyboardType: TextInputType.number),
              SizedBox(height: 24.h),

              _buildLabel('Your Daily Movement'),
              MovementOptionCard(title: 'Minimum', subtitle: 'Ex. Primarily sitting - Desk job', value: 'SD', groupValue: selectedMovement, onChanged: (val) => setState(() => selectedMovement = val)),
              MovementOptionCard(title: 'Light', subtitle: 'Ex. Light walking - Daily tasks', value: 'LA', groupValue: selectedMovement, onChanged: (val) => setState(() => selectedMovement = val)),
              MovementOptionCard(title: 'Moderate', subtitle: 'Ex. Walking consistently', value: 'MD', groupValue: selectedMovement, onChanged: (val) => setState(() => selectedMovement = val)),
              MovementOptionCard(title: 'High', subtitle: 'Ex. Physically demanding job - Nurse', value: 'VA', groupValue: selectedMovement, onChanged: (val) => setState(() => selectedMovement = val)),
              MovementOptionCard(title: 'Very High', subtitle: 'Ex. Athlete', value: 'EA', groupValue: selectedMovement, onChanged: (val) => setState(() => selectedMovement = val)),
              SizedBox(height: 32.h),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSaving ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff173272),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: isSaving
                      ? SizedBox(height: 20.h, width: 20.h, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 12.h),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showDeleteDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff990000),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text('Delete Account', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(text, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color(0xff111827))),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
    );
  }
}