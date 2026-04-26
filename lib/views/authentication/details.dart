import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/core/ui/app_input.dart';

import '../home/pages/home_page/view.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({super.key});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  final dio = ApiHelper.createDio();

  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final birthYearController = TextEditingController();

  String selectedGender = "Male";
  String selectedHeightUnit = "cm";
  String selectedWeightUnit = "Kg";
  bool isLoading = false;

  Future<void> submitDetails() async {
    // ✅ validation بسيطة
    if (heightController.text.isEmpty ||
        weightController.text.isEmpty ||
        birthYearController.text.isEmpty) {
      showMsg("Please fill all fields", isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await dio.post(
        "api/userprofile/",
        data: {
          "height": double.tryParse(heightController.text) ?? 0,
          "weight": double.tryParse(weightController.text) ?? 0,
          "sex": selectedGender == "Male" ? "M" : "F",
          "weight_unit": selectedWeightUnit.toLowerCase(), // "kg" or "lbs"
          "height_unit": selectedHeightUnit.toLowerCase(), // "cm" or "ft"
          "birth_year": int.tryParse(birthYearController.text) ?? 0,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ البيانات اتحفظت → روح Home
        goTo(HomePageView());
      } else {
        showMsg("Something went wrong", isError: true);
      }
    } on DioException catch (e) {
      showMsg(e.response?.data?['message'] ?? "Something went wrong", isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    birthYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(top: 40, start: 16, end: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter Your Details",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                "This helps personalize your plan",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 40),

              AppInput(
                hintText: "Height",
                isHeight: true,
                controller: heightController,
                onHeightUnitChanged: (unit) => selectedHeightUnit = unit,
              ),
              AppInput(
                hintText: "Weight",
                isWeight: true,
                controller: weightController,
                onWeightUnitChanged: (unit) => selectedWeightUnit = unit,
              ),
              AppInput(
                hintText: "Birth Year",
                controller: birthYearController,
              ),

              SizedBox(height: 8),
              Text(
                "Gender",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0D1B2A),
                ),
              ),
              SizedBox(height: 8),

              Row(
                children: [
                  _buildGenderButton("Male"),
                  SizedBox(width: 16),
                  _buildGenderButton("Female"),
                ],
              ),

              SizedBox(height: 40),

              // ✅ لو بيعمل loading يعرض CircularProgressIndicator
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : AppButton(onPressed: submitDetails, title: 'Next',width: double.infinity,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderButton(String gender) {
    final isSelected = selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedGender = gender),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF1E2D6E) : Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            gender,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}