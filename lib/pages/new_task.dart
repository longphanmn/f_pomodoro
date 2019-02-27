import 'package:flutter/material.dart';
import 'package:fpomodoro/models/task.dart';
import 'package:flutter/cupertino.dart';

class NewTaskPage extends StatefulWidget {
  NewTaskPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  TextEditingController _titleController;

  int maxTitleLength = 36;

  Task task;

  void _saveTaskAndClose() {
    Navigator.of(context).pop(task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.navigate_before,
                              size: 40.0,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.sync,
                            size: 32.0,
                            color: Colors.white70,
                          ),
                          onPressed: () {

                          },
                        ),
                      ],
                    ),
                  ),
                  new TextField(
                    maxLength: maxTitleLength,
                    controller: _titleController,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Task title',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    ),
                  ),
                  new TextField(
                    maxLength: maxTitleLength,
                    controller: _titleController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Description',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      counterText: "",
                      contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  minWidth: double.maxFinite,
                  onPressed: _saveTaskAndClose,
                  child: Text('Save Task'.toUpperCase()),
                ),
              )
            ],
          ),
        )
    );
  }
}
