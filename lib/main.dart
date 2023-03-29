import 'package:demo_news_app/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upgrader/upgrader.dart';

import 'notification/local_notification_service.dart';

// push notification code
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  // for push notification using firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  // for the handsome notification view
  LocalNotificationService.initialize();
  runApp(const MyApp());

  // forcefully set portrait mode only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

Color themeColor = Colors.blue;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Popular Tv',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Hind',
      ),
      themeMode: ThemeMode.light,
      // home: const Loading(),
      home: UpgradeAlert(
        upgrader: Upgrader(
          onIgnore: () {
            SystemNavigator.pop();
            throw UnsupportedError('_');
          },
          durationUntilAlertAgain: const Duration(days: 10),
          showIgnore: false,
          showLater: false,
          shouldPopScope: () => false,
          languageCode: "hi",
        ),
        child: const SplashScreen(),
      ),
    );
  }
}
