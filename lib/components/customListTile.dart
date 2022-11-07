import 'package:flutter/material.dart';

Widget customListTile(
    {IconData? icon, String? label, VoidCallback? onTap, Color? dividerColor}) {
  return Column(
    children: [
      // vertical space
      const SizedBox(
        height: 10.0,
      ),

      // list of icon and text
      InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // icon and label
            Row(
              children: [
                // icon
                Icon(
                  icon,
                  color: Colors.black87,
                ),

                // space between
                const SizedBox(
                  width: 10.0,
                ),

                // title
                Text(
                  label ?? '',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            // icon
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.black38,
              size: 16.0,
            ),
          ],
        ),
      ),

      // vertical space
      const SizedBox(
        height: 10.0,
      ),

      // horizontal line
      Divider(
        color: dividerColor,
      ),
    ],
  );
}
