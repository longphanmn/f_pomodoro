import 'package:flutter/material.dart';

import 'package:fpomodoro/models/task.dart';
import 'package:fpomodoro/utils/manager.dart';

class TimerPage extends StatefulWidget {
  final Task task;

  TimerPage({Key key, this.task}) : super(key: key);

  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: new Text(
           widget.task.title,
         ),
       )
    );
  }
}