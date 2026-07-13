import 'package:flutter/material.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/views/home/pages/home main view.dart';
import 'package:neutrilift/views/plan/automatic/view.dart';
import 'package:neutrilift/views/plan/create_plan/widget/plan_card.dart';
import 'package:neutrilift/views/plan/custom/custom_lifestyle_details.dart';

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
          padding: const EdgeInsetsDirectional.only(start: 16,end: 16,bottom: 80,top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeView(initialIndex: 0)),
                          (route) => false,
                    );
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xff173272),
                ),
              ),
              const SizedBox(height: 16),
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
                      goTo(const AutomaticLifeStylView());
                    } else if (selectedPlan == "custom") {
                      goTo(CustomLifestyleDetailsView());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff173272),
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