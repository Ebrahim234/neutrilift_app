import 'package:flutter/material.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/views/plan/automatic/view.dart';
import 'package:neutrilift/views/plan/create_plan/widget/plan_card.dart';


class CreatePlanView extends StatefulWidget {
  const CreatePlanView({super.key});

  @override
  State<CreatePlanView> createState() => _CreatePlanViewState();
}

class _CreatePlanViewState extends State<CreatePlanView> {
  String? selectedPlan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create plan",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Create your plan manually or system generated",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              PlanOptionCard(
                title: "Automatic Plan",
                subtitle: "Automatic personalized plan",
                isSelected: selectedPlan == "automatic",
                onTap: () => setState(() => selectedPlan = "automatic"),
              ),
              const SizedBox(height: 16),
              PlanOptionCard(
                title: "Custom plan",
                subtitle: "Make your own plan",
                isSelected: selectedPlan == "custom",
                onTap: () => setState(() => selectedPlan = "custom"),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: selectedPlan == null
                      ? null
                      : () {
                    if (selectedPlan == "automatic") {
                      goTo(AutomaticLifeStylView());
                    }
                    // else {
                    //   goTo(ManualLifeStylView());
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2D6E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
