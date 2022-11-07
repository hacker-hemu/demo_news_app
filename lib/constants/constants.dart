// // base url
// const String kDevelopmentAndroidUrl = 'http://10.0.2.2:8000';
//
// // base url
// const String kDevelopmentUrl = 'http://127.0.0.1:8000';
//
// // base url
// const String kDevelopmentMobileIPUrl = '192.168.1.16';
//
// // base url
// const String kProductionUrl = '';
//
// // base url
// const String kBaseUrl = kDevelopmentAndroidUrl;
//
// // api url
// const String kApiUrl = '$kBaseUrl/api';
//
// // admin api url
// const String kAdminApiUrl = '$kApiUrl/admin';
//
// // user api url
// const String kUserApiUrl = '$kApiUrl/user';

// ^^^^^^^^^^^^^^^^^^^^^^^^^^ my old variables ^^^^^^^^^^^^^^^^^^^^^^^^^

// ==================== my new variables ====================

// -------  String  -------
// default
// const baseURL = 'http://127.0.0.1:8000/api';

// when use emulator
// const baseURL = 'http://10.0.2.2:8000/api';

import 'package:flutter/material.dart';

import '../components/vertical_line.dart';

// mobileHotSpot
// const baseURL = 'http://192.168.159.218:8000';

// localhost
// const baseURL = 'http://127.0.0.1:8000';

// emulator
// const baseURL = 'http://10.0.2.2:8000';

// home wifi
const baseURL = 'http://192.168.0.106';

// office wifi
// const baseURL = 'http://192.168.1.12';

const loginURL = '$baseURL/api/login';
const registerURL = '$baseURL/api/register';
const logoutURL = '$baseURL/api/logout';
const userURL = '$baseURL/api/user';
const newsURL = '$baseURL/api/news';
const userNewsURL = '$baseURL/api/userNews';
const commentsURL = '$baseURL/api/comments';

// news category url
const categoryURL = '$baseURL/api/category';

// advertisement url
const adsURL = '$baseURL/api/ads';

// newsImages url
const newsImagesURL = '$baseURL/api/newsImages';

// state
const stateURL = '$baseURL/api/state';

// state
const districtURL = '$baseURL/api/district';

// state
const cityURL = '$baseURL/api/city';

// image urls
const shortLogoURL = 'assets/images/logoShort.png';
const newsImageURL = '${baseURL}/uploads/news';
const newsUserImageURL = '${baseURL}/uploads/user';
const userImageURL = '';
const categoryImageURL = '';

// sharing information
//TODO: Replace URL with this app Play Store URL
// play stor aap URL
const playStoreAppLink =
    'https://play.google.com/store/apps/details?id=com.hemant.demo_news_app';

const clientMobileNumber = '1234567890';
const clientEmail = 'demmonewsapp@example.com';

// -------  Errors  -------
const serverError = 'Server Error';
const unauthorized = 'Unauthorized';
const someThingWentWrong = 'Some Thing Went Wrong, Try Again';

// -------  Form input decoration  -------
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    contentPadding: const EdgeInsets.all(10),
    border: const UnderlineInputBorder(
      borderSide: BorderSide(
        width: 1.0,
        color: Colors.black87,
      ),
    ),
  );
}

// -------  create news form input decoration  -------
InputDecoration kNewsInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    contentPadding: const EdgeInsets.all(10),
    border: const OutlineInputBorder(
      borderSide: BorderSide(
        width: 1.0,
        color: Colors.black87,
      ),
    ),
  );
}

// -------  Form text button  -------
TextButton kTextButton({String? label, VoidCallback? onPressed}) {
  return TextButton(
    // on pressed function
    onPressed: () => onPressed,
    style: ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith(
        (states) => Colors.blue,
      ),
      padding: MaterialStateProperty.resolveWith(
        (states) => const EdgeInsets.symmetric(vertical: 10),
      ),
    ),
    child: Text(
      // button name
      label!,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

// -------  Login and register hint text -------
Row kLoginRegisterHint(String? text, String? label, Function? onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text!),
      GestureDetector(
        child: Text(
          label!,
          style: const TextStyle(
            color: Colors.blue,
          ),
        ),
        onTap: () => onTap,
      ),
    ],
  );
}

//    news category name of news
Widget newsCategoryName({String? label}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        margin: EdgeInsets.fromLTRB(15.0, 15.0, 0, 0),
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.only(right: 5.0),
                child: CustomVerticalLine(Colors.deepOrange, 35.0)),
            Text(
              '$label'.toUpperCase(),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
