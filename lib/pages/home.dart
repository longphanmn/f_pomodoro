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

  @override
  void initState() {
    super.initState();
    taskManager.loadAllTasks();
  }

  void _addTask(BuildContext context) async {

    Task task = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewTaskPage()),
    );

    if (task != null){
      await Manager().addNewTask(task);
      await taskManager.loadAllTasks();
      setState((){
        final snackBar = SnackBar(content: Text('Added: ${task.title}'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTask(context);
        },
        tooltip: 'Add new task',
        child: Icon(Icons.add),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 80.0,
              floating: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                ),
            ),
          ];
        },
        body: Container(
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
                      child: new TaskWidget(task: item
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
      ),
    );
  }
}

class TaskWidget extends StatelessWidget{
  TaskWidget({Key key, this.task}) : super(key: key);
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: Container(
        height: 56.0,
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              task.description,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              task.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
    )
    );
  }
}
