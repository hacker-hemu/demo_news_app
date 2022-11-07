import 'package:flutter/material.dart';

Widget CustomVerticalLine(Color color,  double height) {
  return Container(
    width: 5.0,
    height: height,
    decoration: new BoxDecoration(
      color: color,
      borderRadius: new BorderRadius.circular(40.0),
    ),
  );
}
