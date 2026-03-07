import 'package:flutter/material.dart';

import '../../views/authentication/login.dart';
import '../../views/authentication/register.dart';
import '../logic/helper_method.dart';
class AppLoginOrAppRegister extends StatelessWidget {
  final bool isLogin;

  const AppLoginOrAppRegister({super.key, this.isLogin = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom,
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: isLogin ? "Don’t have an account?" : "Already have an account?",
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                ),
                onPressed: () {
                  if (isLogin) {
                    goTo(RegisterView());
                  } else {
                    goTo(LoginView());
                  }
                },
                child: Text(isLogin ? "Register" : "Login "),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
