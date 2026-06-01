import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_image.dart';

class AppSearch extends StatelessWidget {
  const AppSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Search',
        suffixIcon: Padding(
          padding: EdgeInsets.all(12.w),
          child: Icon(Icons.search, color: Colors.grey)
        ),
      ),
    );
  }
}
