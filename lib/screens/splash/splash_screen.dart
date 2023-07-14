import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:bus_booking/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.gif(
      gifPath: 'assets/images/loading.gif',
      gifWidth: 269,
      gifHeight: 474,
      defaultNextScreen: LoginScreen(),
      duration: const Duration(seconds: 5),
      onInit: () async {
        await Future.delayed(const Duration(milliseconds: 2000));
      },
      onEnd: () async {
      },
    );
  }
}
