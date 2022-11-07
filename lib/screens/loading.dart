import 'package:flutter/material.dart';
import 'package:demo_news_app/constants/constants.dart';
import 'package:demo_news_app/models/api_response.dart';
import 'package:demo_news_app/screens/home.dart';
import 'package:demo_news_app/services/user_service.dart';

import 'login.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  // checking user login or not
  void _loadUserInfo() async {
    String token = await getToken();
    if (token == '') {
      // redirect to login screen
      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    } else {
      ApiResponse response = await getUserDetail();

      // if no error found so redirecting to home screen
      if (response.error == null) {
        await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      }

      // unauthorized error
      else if (response.error == unauthorized) {
        await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()), (route) => false);
      }

      // TODO: I manually write this code
      else if (token != null) {
        await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      }

      // showing error in snackbar
      else {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text('${response.error}'),
        // ));
        print(
            '***********ERROR******************** ${response.error} ***************ERROR***********');
      }
    }
  }

  // calling loadUserInfo function in initState
  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
