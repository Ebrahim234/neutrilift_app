import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_image.dart';

class AppInput extends StatefulWidget {
  final String? suffixIcon;
  final String labelText, hintText;
  final double? borderRadius;
  final bool isPassword;
  final bool isEmail;
  final TextEditingController? controller;

  const AppInput({
    super.key,
    this.labelText = "",
    this.borderRadius,
    this.hintText = "",
    this.suffixIcon,
    this.isPassword = false,
    this.isEmail = false,
    this.controller,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: const Color(0xffFFFFFF),
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.r),
                border: Border.all(color: const Color(0x665A6690)),
              ),
              child: TextFormField(
                controller: widget.controller,
                keyboardType: widget.isEmail ? TextInputType.emailAddress : TextInputType.text,
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
                      image: isHidden ? "visibility_off.svg" : "visibility.svg",
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
        ],
      ),
    );
  }
}