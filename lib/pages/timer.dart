import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';

import 'package:fpomodoro/models/task.dart';
import 'package:fpomodoro/ui/wave.dart';

class TimerPage extends StatefulWidget {
  final Task task;

  TimerPage({Key key, @required this.task}) : super(key: key);

  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage>
    with SingleTickerProviderStateMixin {
  Timer timer;

  Task getTask() => widget.task;

  String timeText = '';
  String buttonText = 'Start';

  int minutes = 25;

  Stopwatch stopwatch = Stopwatch();
  static const delay = Duration(microseconds: 1);

  var begin = 0.0;
  Animation<double> heightSize;
  AnimationController _controller;

  void updateClock() {
    if (stopwatch.elapsed.inMinutes == minutes) {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop(getTask());
      }
      return;
    }

    var currentMinute = stopwatch.elapsed.inMinutes;

    setState(() {
      timeText =
          '${(minutes - currentMinute - 1).toString().padLeft(2, "0")}:${((60 - stopwatch.elapsed.inSeconds % 60 - 1)).toString().padLeft(2, '0')}';
    });

    if (stopwatch.isRunning) {
      setState(() {
        buttonText = "Running";
      });
    } else if (stopwatch.elapsed.inSeconds == 0) {
      setState(() {
        timeText = '$minutes:00';
        buttonText = "Start";
      });
    } else {
      setState(() {
        buttonText = "Paused";
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(minutes: minutes),
      vsync: this,
    );

    _controller.addStatusListener((state) {
      print('-----animation state: $state');
    });

    timer = Timer.periodic(delay, (Timer t) => updateClock());
  }

  @override
  void dispose() {
    _controller.dispose();
    stopwatch.stop();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    heightSize =
        new Tween(begin: begin, end: MediaQuery.of(context).size.height - 65)
            .animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    var height = heightSize.value *
        10 *
        (minutes - stopwatch.elapsed.inMinutes - 1) /
        minutes;

    Size size = new Size(MediaQuery.of(context).size.width, height);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return DemoBody(
                size: size,
                color: Theme.of(context).primaryColor,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 4.0, right: 4.0),
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 40.0,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.done_all,
                    size: 32.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Task task = getTask();
                    task.done = true;
                    Navigator.of(context).pop(task);
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    widget.task.title,
                    style: TextStyle(fontSize: 30.0, color: Colors.grey),
                  ),
                  Text(
                    widget.task.description,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(bottom: 100),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      timeText,
                      style: TextStyle(
                          fontSize: 54.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 32),
              child: GestureDetector(
                  child: RoundedButton(text: buttonText),
                  onTap: () {
                    if (stopwatch.isRunning) {
                      stopwatch.stop();
                      _controller.stop(canceled: false);
                    } else {
                      begin = 50.0;
                      stopwatch.start();
                      _controller.forward();
                    }

                    updateClock();
                  }),
            ),
          )
        ],
      ),
    );
  }
}

class RoundedButton extends StatefulWidget {
  final String text;
  RoundedButton({Key key, @required this.text}) : super(key: key);

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 140.0,
      height: 140.0,
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.white, blurRadius: 0.0)
          ]),
      child: Center(
        child: Text(
          widget.text.toUpperCase(),
          style: TextStyle(
            fontSize: 20.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
