import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:controleOrcamentos/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.white,
      childWidget: SizedBox(
          height: 300,
          width: 300,
          child: Lottie.asset("assets/img/splash.json")),
      nextScreen: const HomeScreen(),
    );
  }
}
