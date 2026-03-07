import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_image.dart';

class AppBack extends StatefulWidget {
  const AppBack({super.key});

  @override
  State<AppBack> createState() => _AppBackState();
}
class _AppBackState extends State<AppBack> {
  int currentView = 0;
  @override
  Widget build(BuildContext context) {
    return  Align(alignment: AlignmentDirectional.centerStart,
      child: CircleAvatar(
        radius: 15.r,
        backgroundColor: Color(0xff1010100D),
        child: IconButton(
          onPressed: () {
            currentView--;
            setState(() {});
          },
          icon: AppImage(image: "arrowleft.svg", height: 21.h, width: 21.w,fit: BoxFit.fill,),
        ),
      ),
    );
  }
}
