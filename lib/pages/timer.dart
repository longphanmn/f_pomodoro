import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:fpomodoro/models/task.dart';

import 'package:vector_math/vector_math.dart' as Vector;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';

class TimerPage extends StatefulWidget {
  final Task task;

  TimerPage({Key key, @required this.task}) : super(key: key);

  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with SingleTickerProviderStateMixin  {

  Timer timer;

  Task getTask() => widget.task;

  /// Store the time
  /// You will pass the minutes.
  String timeText = '';
  String buttonText = 'Start';
  String statusText = "Left on this Task";

  int minutes = 25;

  Stopwatch stopwatch = Stopwatch();
  static const delay = Duration(microseconds: 1);

  /// for animation
  var begin = 0.0;
  Animation<double> heightSize;
  AnimationController _controller;

    /// Called each time the time is ticking
  void updateClock(){

    // if time is up, stop the timer
    if(stopwatch.elapsed.inMinutes == minutes){
      if(Navigator.canPop(context)){
        print('--finished Timer Page--');
        Navigator.pop(context);
      }
      return;
    }

    var currentMinute = stopwatch.elapsed.inMinutes;

    setState(() {
      timeText = '${currentMinute.toString().padLeft(2,"0")}:${((stopwatch.elapsed.inSeconds%60)).toString().padLeft(2, '0')}';
    });

    if (stopwatch.isRunning) {
      setState(() {

        statusText = "${minutes-currentMinute} minutes left";
        buttonText = "Running";
      });
    }else if(stopwatch.elapsed.inSeconds == 0){
      setState(() {
        timeText = '$minutes:00';
        statusText = "Left on this Task";
        buttonText = "Start";
      });
    }else{
      setState(() {
        statusText = 'Paused';
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

    _controller.addStatusListener((state){
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

  void _restartCountDown() {
    begin = 0.0;
    _controller.reset();
    stopwatch.stop();
    stopwatch.reset();
  }

   @override
  Widget build(BuildContext context) {

    heightSize = new Tween(
        begin: begin,
        end: MediaQuery.of(context).size.height-65
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Size size = new Size(
        MediaQuery.of(context).size.width,
        heightSize.value
    );

    return Scaffold(
      backgroundColor: Colors.grey,
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
                      Icons.navigate_before,
                      size: 40.0,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.done,
                    size: 32.0,
                    color: Colors.white70,
                  ),
                  onPressed: _restartCountDown,
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
                      style: TextStyle(fontSize: 30.0, color: Colors.white),
                    ),
                    Text(
                      widget.task.description,
                      style: TextStyle(color: Colors.white70),
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
                      style: TextStyle(fontSize: 54.0, color: Colors.white),
                    ),
                    Text(
                      statusText,
                      style: TextStyle(color: Colors.white70),
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
                      print('--Paused--');
                      stopwatch.stop();
                      _controller.stop(canceled: false);
                    } else {
                      print('--Running--');
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: new Material(
  //         color: Colors.white,
  //         child: Stack(
  //           children: <Widget>[
  //             ListView(
  //               shrinkWrap: false,
  //               children: <Widget>[
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 8, bottom: 4),
  //                   child: Row(
  //                     children: <Widget>[
  //                       IconButton(
  //                         onPressed: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                         icon: Icon(
  //                               Icons.arrow_back,
  //                               size: 32,
  //                               color: Colors.grey,
  //                       )),
  //                     ],
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 0, left: 16, bottom: 8),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
  //                       new Text(
  //                         widget.task.title,
  //                         style: TextStyle(
  //                           fontSize: 24,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       new Text(
  //                         widget.task.description,
  //                         style: TextStyle(
  //                           fontSize: 20,
  //                           fontWeight: FontWeight.normal,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
                  
  //               ],
  //             )
  //           ],
  //         ),
  //       )
  //   );
  // }
}

class RoundedButton extends StatefulWidget{
  final String text;
  RoundedButton({Key key, @required this.text}): super(key: key);

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton>{

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 140.0,
      height: 140.0,
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.white,
                blurRadius: 0.0
            )
          ]
      ),
      child: Center(
        child: Text(widget.text.toUpperCase(),
          style: TextStyle(
              fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}

class DemoBody extends StatefulWidget {
  final Size size;
  final int xOffset;
  final int yOffset;
  final Color color;

  DemoBody(
      {Key key, @required this.size, this.xOffset = 0, this.yOffset = 0, this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _DemoBodyState();
  }
}

class _DemoBodyState extends State<DemoBody> with TickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> animList1 = [];

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));

    animationController.addListener(() {
      animList1.clear();
      for (int i = -2 - widget.xOffset;
      i <= widget.size.width.toInt() + 2;
      i++) {
        animList1.add(new Offset(
            i.toDouble() + widget.xOffset,
            sin((animationController.value * 360 - i) %
                360 *
                Vector.degrees2Radians) *
                10 +
                30 +
                widget.yOffset));
      }
    });
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.bottomCenter,
      child: new AnimatedBuilder(
        animation: new CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        builder: (context, child) => new ClipPath(
          child: new Container(
            width: widget.size.width,
            height: widget.size.height,
            color: widget.color,
          ),
          clipper: new WaveClipper(animationController.value, animList1),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}