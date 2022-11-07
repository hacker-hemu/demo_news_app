import 'package:flutter/material.dart';

class EpaperScreen extends StatefulWidget {
  const EpaperScreen({Key? key}) : super(key: key);

  @override
  State<EpaperScreen> createState() => _EpaperScreenState();
}

class _EpaperScreenState extends State<EpaperScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('E-paper Screen'),
    );
  }
}
