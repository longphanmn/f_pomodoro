import 'package:flutter/material.dart';
import 'package:fpomodoro/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F-Pomodoro',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(title: 'F-Pomodoro'),
    );
  }
}
