import 'dart:async';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void goTo(Widget page, {bool canPop = false, int? delayInSeconds}) {
  void action() {
    Navigator.pushAndRemoveUntil(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => page),
          (route) => canPop,
    );
  }

  if (delayInSeconds != null) {
    Timer(Duration(seconds: delayInSeconds), () {
      action();
    });
  } else {
    action();
  }
}

void showMsg(String msg, {bool isError = false}) {
  final context = navigatorKey.currentContext!;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red : Colors.green,
    ),
  );
}
