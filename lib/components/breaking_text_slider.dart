import 'package:demo_news_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

Widget BuildAnimatedText(
    {List? text, String? startEndWith, Color? textBgColor}) {
  return Row(
    children: [
      Container(
        width: 90.0,
        height: 40.0,

        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            stops: [0.1, 0.9],
            colors: [
              secondaryColor87,
              secondaryColor45,
            ],
          ),
        ),

        // color: Colors.deepOrangeAccent,
        child: const Center(
          child: Text(
            'Breaking',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
      ),

      // vertical poll
      // Container(
      //   width: 5.0,
      //   height: 35.0,
      //   decoration: new BoxDecoration(
      //     color: Colors.deepOrange,
      //     borderRadius: new BorderRadius.circular(40.0),
      //   ),
      // ),

      Expanded(
        child: Container(
          width: double.maxFinite,
          height: 40.0,
          color: textBgColor,
          child: Center(
            child: Marquee(
              text: '${text?.join(" * ")}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: Colors.white,
              ),
              scrollAxis: Axis.horizontal, //scroll direction
              crossAxisAlignment: CrossAxisAlignment.center,
              blankSpace: 20.0,
              velocity: 50.0, //speed
              pauseAfterRound: Duration(seconds: 1),
              startPadding: 10.0,
              accelerationDuration: Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            ),
          ),
        ),
      ),
    ],
  );
}
