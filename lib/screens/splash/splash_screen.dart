import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.gif(
      gifPath: 'assets/images/loading.gif',
      gifWidth: 269,
      gifHeight: 474,
      defaultNextScreen: null,
      duration: const Duration(milliseconds: 3515),
      onInit: () async {
        debugPrint("onInit 1");
        await Future.delayed(const Duration(milliseconds: 2000));
        debugPrint("onInit 2");
      },
      onEnd: () async {
        debugPrint("onEnd 1");
        debugPrint("onEnd 2");
      },
    );
  }
}
