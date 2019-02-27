import 'package:flutter/material.dart';
import 'package:fpomodoro/pages/new_task.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _addTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewTaskPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Add new task',
        child: Icon(Icons.add),
      ),
    );
  }
}
