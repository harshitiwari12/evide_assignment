import 'package:evide_assignment/pages/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EvideApp());
}

class EvideApp extends StatelessWidget {
  const EvideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evide Assignment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
