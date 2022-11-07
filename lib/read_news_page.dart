import 'package:flutter/material.dart';

class ReadNews extends StatefulWidget {
  const ReadNews({Key? key}) : super(key: key);

  @override
  State<ReadNews> createState() => _ReadNewsState();
}

class _ReadNewsState extends State<ReadNews> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'This is Read News Page',

        //TODO: start to  Read News page design
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
