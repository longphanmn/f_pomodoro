import 'dart:async';
import 'package:flutter/material.dart';

import 'package:fpomodoro/pages/new_task.dart';
import 'package:fpomodoro/models/task.dart';
import 'package:fpomodoro/utils/manager.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Manager taskManager = Manager();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<List<Task>> _streamController;

  @override
  void initState() {
    super.initState();
    taskManager.loadAllTasks();
    _streamController = StreamController();
  }

  void _addTask() async {
    Task task = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewTaskPage()),
    );


    if (task != null){
      await Manager().addNewTask(task);
      var allTasks = await taskManager.loadAllTasks();
      setState((){
        _streamController.add(allTasks);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTask();
        },
        tooltip: 'Add new task',
        child: Icon(Icons.add),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 24.0),
        child: StreamBuilder(
            stream: taskManager.tasksData.asStream(),
            initialData: List<Task>(),
            builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
              var tasks = snapshot.data;

              if(snapshot.connectionState != ConnectionState.done){
                return Center(child: CircularProgressIndicator(),);
              }

              if (tasks != null && tasks.length == 0) {
                return Center(
                  child: Text('No Tasks!',
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                );
              }else {
                return ListView.builder(
                  itemCount: tasks.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var item = tasks.elementAt(index);
                    return GestureDetector(
                      child: new Text(item.title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onTap: () {
                        
                      },
                    );
                  },
                );
              }
            }
        ),
      ),
    );
  }
}
