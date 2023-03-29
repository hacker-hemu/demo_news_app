import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../home.dart';

class CheckConnectivity extends StatefulWidget {
  const CheckConnectivity({Key? key}) : super(key: key);

  @override
  State<CheckConnectivity> createState() => _CheckConnectivityState();
}

class _CheckConnectivityState extends State<CheckConnectivity> {
  String status = "Waiting...";

  final Connectivity _connectivity = Connectivity();

  late StreamSubscription _streamSubscription;

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
    }
    setState(() {});
  }

  void checkRealtimeConnection() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile) {
        status = "MobileData";
        print(status);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
            (route) => false);
      } else if (event == ConnectivityResult.wifi) {
        status = "Wifi";
        print(status);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
            (route) => false);
      } else {
        status = "Not Connected";
        print(status);
      }
      setState(() {});
    });
  }

  initState() {
    super.initState();
    checkRealtimeConnection();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage("assets/images/no_internet.jpg"),
              alignment: Alignment.topCenter),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'No Internet!',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40,
                decoration: TextDecoration.none,
              ),
            ),
            const Padding(padding: EdgeInsets.all(5.0)),
            const Text(
              'Your Internet Connection is OFF',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                decoration: TextDecoration.none,
              ),
            ),
            const Padding(padding: EdgeInsets.all(5.0)),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width * (3 / 4),
              height: 60,
              onPressed: () {
                // webViewController?.reload();
                setState(() {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                });
              },
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: const Text(
                "Refresh",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      onRefresh: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
          (route) => false),
    );
  }
}
