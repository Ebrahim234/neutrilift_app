import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/core/ui/app_button.dart';
import 'package:neutrilift/core/ui/app_input.dart';
import 'package:neutrilift/views/authentication/widgets/daily_movement_card.dart';

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
  final frequencyController = TextEditingController();

  String selectedGender = "Male";
  String selectedHeightUnit = "cm";
  String selectedWeightUnit = "Kg";
  String selectedMovement = "Minimum";
  bool isLoading = false;

  final List<Map<String, String>> dailyMovements = [
    {"title": "Minimum", "subtitle": "Ex. Primarily sitting - Desk job"},
    {"title": "Light", "subtitle": "Ex. Light walking - Daily tasks"},
    {"title": "Moderate", "subtitle": "Ex. Walking consistently"},
    {"title": "High", "subtitle": "Ex. Physically demanding job - Nurse"},
    {"title": "Very High", "subtitle": "Ex. Athlete"},
  ];

  Future<void> submitDetails() async {
    if (heightController.text.isEmpty ||
        weightController.text.isEmpty ||
        birthYearController.text.isEmpty ||
        frequencyController.text.isEmpty) {
      showMsg("Please fill all fields", isError: true);
      return;
    }

    setState(() => isLoading = true);

    // دالة تحويل اختيار اليوزر للاختصار اللي الباك إند طالبه
    String getMovementCode(String movement) {
      switch (movement) {
        case "Minimum": return "MN";
        case "Light": return "LT";
        case "Moderate": return "MD";
        case "High": return "HG";
        case "Very High": return "VH";
        default: return "MN";
      }
    }

    try {
      final data = {
        "height": double.tryParse(heightController.text) ?? 0,
        "weight": double.tryParse(weightController.text) ?? 0,
        "sex": selectedGender == "Male" ? "M" : "F",
        "weight_unit": selectedWeightUnit.toLowerCase(),
        "height_unit": selectedHeightUnit.toLowerCase(),
        "birth_year": int.tryParse(birthYearController.text) ?? 0,
        "exercise_frequency": int.tryParse(frequencyController.text) ?? 0,
        "daily_movement": getMovementCode(selectedMovement),
        "time_zone": "Africa/Cairo", // إضافة حقل التايم زون المطلوب
      };

      print("📤 Sending Profile Data: $data");

      final response = await dio.post("/api/userprofile/", data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        goTo(HomePageView());
      } else {
        print("❌ Server Error Response: ${response.data}");
        showMsg("Server error: ${response.statusCode}", isError: true);
      }
    } on DioException catch (e) {
      print("🔴 Dio Error Status: ${e.response?.statusCode}");
      print("🔴 Dio Error Data: ${e.response?.data}");

      String errorMsg = "Something went wrong";
      if (e.response?.data is Map) {
        errorMsg = e.response?.data['message'] ?? e.response?.data.toString();
      }

      showMsg(errorMsg, isError: true);
    } catch (e) {
      showMsg("An unexpected error occurred", isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    birthYearController.dispose();
    frequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.only(top: 40, start: 16, end: 16, bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Your Details",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xff0D1B2A)),
              ),
              const Text(
                "This helps personalize your plan",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xff6B7280)),
              ),
              const SizedBox(height: 40),

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
                hintText: "Birthyear",
                controller: birthYearController,
                // عشان اليوزر يكتب أرقام بس في السنة
                // keyboardType: TextInputType.number,
                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),

              const SizedBox(height: 8),
              const Text(
                "Gender",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0D1B2A),
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  _buildGenderButton("Male"),
                  const SizedBox(width: 16),
                  _buildGenderButton("Female"),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: frequencyController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          hintText: "Weekly Exercise Frequency",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "0-7 Days",
                      style: TextStyle(
                        color: Color(0xFF1E2D6E),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                "Your Daily Movement",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0D1B2A),
                ),
              ),
              const SizedBox(height: 12),

              ...dailyMovements.map((movement) {
                return DailyMovementCard(
                  title: movement["title"]!,
                  subtitle: movement["subtitle"]!,
                  isSelected: selectedMovement == movement["title"],
                  onTap: () {
                    setState(() {
                      selectedMovement = movement["title"]!;
                    });
                  },
                );
              }),

              const SizedBox(height: 32),

              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(onPressed: submitDetails, title: 'Next', width: double.infinity),
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
            color: isSelected ? const Color(0xFF1E2D6E) : Colors.white,
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

// ---------------------------------------------------------
// Custom Widget لبناء كروت الحركة اليومية (Daily Movement)
// حطيتهولك في نفس الملف عشان تاخد الكود كله نسخ مرة واحدة
// ---------------------------------------------------------

