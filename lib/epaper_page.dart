import 'package:flutter/material.dart';

class Epaper extends StatefulWidget {
  const Epaper({Key? key}) : super(key: key);

  @override
  State<Epaper> createState() => _EpaperState();
}

class _EpaperState extends State<Epaper> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Hello I am e-paper poge ',
        //TODO: start to  e-paper page design
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
