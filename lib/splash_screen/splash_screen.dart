import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:demo_news_app/constants/constants.dart';
import 'package:demo_news_app/screens/loading.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(
        splashScreenLogoURL,
      ),
      nextScreen: const Loading(),
      duration: 2500,
      backgroundColor: Colors.black,
      splashTransition: SplashTransition.scaleTransition,
    );
  }
}
