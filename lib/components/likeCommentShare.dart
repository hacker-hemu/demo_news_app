import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/constants.dart';

Widget likeShareComment({
  String? label,
  IconData? icon,
  Color? iconColor,
  VoidCallback? onPressed,
  double? iconSize,
}) {
  return InkWell(
    onTap: onPressed,
    child: Row(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: FaIcon(icon),
          iconSize: iconSize ?? 20.0,
          color: iconColor ?? kIconLightColor,
        ),
        Text(label ?? ''),
      ],
    ),
  );
}
