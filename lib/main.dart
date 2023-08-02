import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home:LearnWords() );
  }
}

class LearnWords extends StatefulWidget {
  const LearnWords({Key? key}) : super(key: key);

  @override
  State<LearnWords> createState() => _LearnWordsState();
}

class _LearnWordsState extends State<LearnWords> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}