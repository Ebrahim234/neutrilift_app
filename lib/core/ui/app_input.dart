import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_image.dart';

class AppInput extends StatefulWidget {
  final String? suffixIcon;
  final String labelText, hintText;
  final double? borderRadius;
  final bool isPassword;
  final bool isEmail;
  final bool isHeight;
  final bool isWeight;
  final TextEditingController? controller;
  final ValueChanged<String>? onHeightUnitChanged;
  final ValueChanged<String>? onWeightUnitChanged;
  final String initialHeightUnit;
  final String initialWeightUnit;

  const AppInput({
    super.key,
    this.labelText = "",
    this.borderRadius,
    this.hintText = "",
    this.suffixIcon,
    this.isPassword = false,
    this.isEmail = false,
    this.controller,
    this.isHeight = false,
    this.isWeight = false,
    this.onHeightUnitChanged,
    this.onWeightUnitChanged,
    this.initialHeightUnit = "cm",
    this.initialWeightUnit = "Kg",
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  bool isHidden = true;
  late String selectedHeight;
  late String selectedWeight;

  @override
  void initState() {
    super.initState();
    selectedHeight = widget.initialHeightUnit;
    selectedWeight = widget.initialWeightUnit;
  }

  // ✅ Widget مستقل بدل تكرار الكود

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 12),
      child: Row(
        children: [
          // ✅ حقل الإدخال
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 16),
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 8.r,
                  ),
                  border: Border.all(color: const Color(0x665A6690)),
                ),
                child: TextFormField(
                  controller: widget.controller,
                  keyboardType: widget.isEmail
                      ? TextInputType.emailAddress
                      : TextInputType.text,
                  textInputAction: TextInputAction.next,
                  obscureText: widget.isPassword ? isHidden : false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    suffixIcon: widget.isPassword
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isHidden = !isHidden;
                              });
                            },
                            icon: AppImage(
                              image: isHidden
                                  ? "visibility_off.svg"
                                  : "visibility.svg",
                              height: 24.h,
                              width: 24.w,
                            ),
                          )
                        : widget.suffixIcon != null
                        ? Padding(
                            padding: EdgeInsets.all(12.w),
                            child: AppImage(
                              image: widget.suffixIcon!,
                              height: 18.h,
                              width: 18.w,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // ✅ Dropdown الطول
          if (widget.isHeight)
            _unitDropdown(
              value: selectedHeight,
              items: const ["cm", "ft"],
              onChanged: (value) {
                setState(() => selectedHeight = value!);
                widget.onHeightUnitChanged?.call(value!);
              },
            ),

          // ✅ Dropdown الوزن
          if (widget.isWeight)
            _unitDropdown(
              value: selectedWeight,
              items: const ["Kg", "Lbs"],
              onChanged: (value) {
                setState(() => selectedWeight = value!);
                widget.onWeightUnitChanged?.call(value!);
              },
            ),
        ],
      ),
    );
  }
}

Widget _unitDropdown({
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return Padding(
    padding: const EdgeInsetsDirectional.only(bottom: 16),
    child: Container(
      height: 50,
      width: 67,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0x665A6690)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );
}
