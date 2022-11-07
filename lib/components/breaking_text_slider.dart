import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

Widget BuildAnimatedText({List? text, String? startEndWith}) {
  return Row(
    children: [
      Container(
        width: 130.0,
        height: 50.0,
        // color: Colors.deepOrangeAccent,
        child: const Center(
          child: Text(
            'Breaking News',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ),
      ),
      Container(
        width: 5.0,
        height: 35.0,
        decoration: new BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: new BorderRadius.circular(40.0),
        ),
      ),
      Container(
        width: 210.0,
        height: 50.0,
        child: Center(
          child: Marquee(
            text: '${text?.join(" * ")}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
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
    ],
  );
}
