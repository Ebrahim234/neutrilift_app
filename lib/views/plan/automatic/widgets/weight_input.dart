import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeightInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String unit) onUnitChanged;

  const WeightInput({
    super.key,
    required this.controller,
    required this.onUnitChanged,
  });

  @override
  State<WeightInput> createState() => _WeightInputState();
}

class _WeightInputState extends State<WeightInput> {
  String selectedUnit = "Kg";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xffE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Weight",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                border: InputBorder.none,
              ),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedUnit,
              items: ["Kg", "Lbs"].map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(
                    unit,
                    style: TextStyle(fontSize: 14.sp, color: Color(0xff0D1B2A)),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedUnit = value!);
                widget.onUnitChanged(value!);
              },
            ),
          ),
        ],
      ),
    );
  }
}