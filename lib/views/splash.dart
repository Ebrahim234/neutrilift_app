import 'package:flutter/material.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/views/authentication/register.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    goTo(RegisterView(),delayInSeconds: 3);

  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Neutrlift",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),))
        ],
      ),
    );
  }
}
