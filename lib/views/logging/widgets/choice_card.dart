import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChoiceCard extends StatelessWidget {
 final String label;
 final VoidCallback onPressed;
 final String description;
  const ChoiceCard({super.key, required this.label, required this.description, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 8),
        child: Container(
          padding: EdgeInsetsDirectional.all(16),
        height: 92.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700,color: Colors.black)),
                  SizedBox(height: 8.h,),
                  Text(description,style: TextStyle(color: Color(0xff6B7280), fontSize: 14.sp, fontWeight: FontWeight.w400))
                ],
              ),
              Spacer(),
              Icon((Icons.arrow_forward_ios_outlined),color: Color(0xff6B7280),size: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
