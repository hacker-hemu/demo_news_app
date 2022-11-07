import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget likeShareComment(
    {String? label,
    IconData? icon,
    Color? iconColor,
    VoidCallback? onPressed}) {
  return InkWell(
    onTap: onPressed,
    child: Row(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: FaIcon(icon),
          iconSize: 20.0,
          color: iconColor ?? Colors.black38,
        ),
        Text(label ?? ''),
      ],
    ),
  );
}
