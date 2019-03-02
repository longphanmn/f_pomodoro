import 'dart:async';
import 'package:flutter/material.dart';

import 'package:fpomodoro/pages/new_task.dart';
import 'package:fpomodoro/models/task.dart';
import 'package:fpomodoro/utils/manager.dart';
import 'package:fpomodoro/pages/timer.dart';

import 'package:highlighter_coachmark/highlighter_coachmark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Manager taskManager = Manager();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _fabKey = GlobalObjectKey("fab");

  @override
  void initState() {
    super.initState();
    taskManager.loadAllTasks();
    Timer(Duration(seconds: 1), () => showCoachMarkFAB());
  }

  void _startTimer(Task task) async {
    Task result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TimerPage(
                task: task,
              )),
    );
    if (result != null) {
      await Manager().updateTask(result);
      await taskManager.loadAllTasks();
      setState(() {
        final snackBar = SnackBar(content: Text('Finished: ${result.title}'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      });
    }
  }

  void _addTask() async {
    Task task = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewTaskPage()),
    );

    if (task != null) {
      await Manager().addNewTask(task);
      await taskManager.loadAllTasks();
      setState(() {
        final snackBar = SnackBar(content: Text('Added: ${task.title}'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      });
    }
  }

  void showCoachMarkFAB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('fab') != null && prefs.getBool('fab')) {
      return;
    }
    CoachMark coachMarkFAB = CoachMark();
    RenderBox target = _fabKey.currentContext.findRenderObject();

    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = Rect.fromCircle(
        center: markRect.center, radius: markRect.longestSide * 0.6);

    coachMarkFAB.show(
        targetContext: _fabKey.currentContext,
        markRect: markRect,
        children: [
          Center(
              child: Text("Tap on button\nto add a tasks",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  )))
        ],
        duration: null,
        onClose: () {
          prefs.setBool('fab', true);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: () {
          _addTask();
        },
        tooltip: 'Add new task',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 80.0,
              floating: true,
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
              builder:
                  (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                var tasks = snapshot.data.reversed;
                print('Count: ${tasks.length}');

                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (tasks != null && tasks.length == 0) {
                  return Center(
                    child: Text(
                      'No Tasks!',
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    itemCount: tasks.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      var item = tasks.elementAt(index);
                      return Hero(
                          tag: 'task-${item.id}',
                          child: Material(
                              child: InkWell(
                            child: TaskWidget(
                              task: item,
                              onRemoved: () async {
                                await taskManager.loadAllTasks();
                                setState(() {
                                  print("Reload");
                                });
                              },
                            ),
                            onTap: () {
                              _startTimer(item);
                            },
                          )));
                    },
                  );
                }
              }),
        ),
      ),
    );
  }
}

class TaskWidget extends StatefulWidget {
  final Task task;
  final VoidCallback onRemoved;

  TaskWidget({Key key, this.task, this.onRemoved}) : super(key: key);

  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    return Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: Card(
            margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            child: Container(
                height: 56.0,
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      task.done
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      color: task.done ? Colors.green : Colors.red,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Hero(
                              transitionOnUserGestures: true,
                              tag: 'text-${task.id}',
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Text(
                            task.description,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ))),
      ),
      actions: <Widget>[
        IconSlideAction(
            caption: 'Done',
            color: Colors.blue,
            icon: Icons.archive,
            onTap: () async {
              Task nTask = task..done = true;
              await Manager().updateTask(nTask);
              setState(() {});
            }),
      ],
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            await Manager().removeTask(task);
            widget.onRemoved();
          },
        ),
      ],
    );
  }
}
