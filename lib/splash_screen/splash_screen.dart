import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo_news_app/constants/constants.dart';
import 'package:demo_news_app/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../screens/Comman/check_connectitvity.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String status = "Waiting...";

  final Connectivity _connectivity = Connectivity();

  late StreamSubscription _streamSubscription;

  initState() {
    super.initState();

    // for OneSignal notification
    OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
    OneSignal.shared.setAppId("fb7c639d-8247-4dd6-b8d0-85cd402e7640");

    // internet  connectivity
    checkRealtimeConnection();
  }

  void checkConnectivity() async {
    var connectionResult = await _connectivity.checkConnectivity();
    print(status);

    if (connectionResult == ConnectivityResult.mobile) {
      status = "MobileData";
      print(status);
    } else if (connectionResult == ConnectivityResult.wifi) {
      status = "Wifi";
      print(status);
    } else {
      status = "Not Connected";
      print(status);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => CheckConnectivity(),
          ),
          (route) => false);
    }
    setState(() {});
  }

  void checkRealtimeConnection() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile) {
        status = "MobileData";
        print(status);
      } else if (event == ConnectivityResult.wifi) {
        status = "Wifi";
        print(status);
      } else {
        status = "Not Connected";
        print(status);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => CheckConnectivity(),
            ),
            (route) => false);
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
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
