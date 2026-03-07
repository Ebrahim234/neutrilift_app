import 'package:flutter/material.dart';
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
        // loadingBuilder: (context, child, loadingProgress) => Center(child: CircularProgressIndicator()),
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
