import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:demo_news_app/constants/constants.dart';
import 'package:demo_news_app/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  initState() {
    super.initState();

    OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
    OneSignal.shared.setAppId("fb7c639d-8247-4dd6-b8d0-85cd402e7640");
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
