import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class MyPinCodeTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const MyPinCodeTextField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 4,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      onChanged: onChanged ?? (value) {},
      pinTheme: PinTheme(
        fieldHeight: 60,
        fieldWidth: 60,
        borderRadius: BorderRadius.circular(8),
        selectedColor: const Color(0xffD75D72),
        activeFillColor: Colors.white,
        activeColor: Colors.white,
        borderWidth: 1,
        inactiveColor: const Color(0x89899275),
        shape: PinCodeFieldShape.box,
      ),
    );
  }
}