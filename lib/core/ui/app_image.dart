import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class AppImage extends StatelessWidget {
  final String image;
  final double? height, width;
  final bool isCircle;
  final Color? color;
  final BoxFit fit;
  final double borderRadius;

  const AppImage({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.cover,
    this.isCircle = false,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    final myFit = isCircle?BoxFit.cover:fit;

    if (image.toLowerCase().endsWith(".svg")) {
      child = SvgPicture.asset(
        "assets/icons/$image",
        width: width,
        height: height,
        fit: fit,
      );
    } else if (image.toLowerCase().startsWith("http")) {
      child = Image.network(
        image,
        width: width,
        height: height,
        color: color,
        fit: myFit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: Icon(
              Icons.fitness_center, // أيقونة دامبل بديلة تظهر لو الصورة منزلتش كاملة
              color: const Color(0xff1A2D6B),
              size: 30.sp,
            ),
          );
        },
      );

    } else if (image.endsWith(".json")) {
      child = Lottie.asset(
        "assets/lotties/$image",
        width: width,
        height: height,
        fit: myFit,
      );
    } else {
      child = Image.asset(
        "assets/images/$image",
        width: width,
        height: height,
        color: color,
        fit: myFit,
      );
    }
    if (isCircle) {return ClipOval(child: child,);}
    return child;


  }
}
