import 'package:flutter/material.dart';
import 'package:fpomodoro/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:fpomodoro/utils/manager.dart';

class NewTaskPage extends StatefulWidget {
  NewTaskPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  TextEditingController _titleController, _descriptionController;

  int maxTitleLength = 36;

  void _saveTaskAndClose() {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if(title.trim().isEmpty) {
      return;
    }

    Navigator.pop(context, new Task(0, title, description));
  }

  @override
  void initState() {
    super.initState();
    _descriptionController = new TextEditingController(text: '');
    _titleController = new TextEditingController(text: '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              ListView(
                shrinkWrap: false,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: 32,
                                color: Colors.grey,
                              )),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: _saveTaskAndClose,
                          child: IconButton(
                              icon: Icon(
                                Icons.save,
                                size: 32,
                                color: Colors.deepOrange,
                              )),
                        )
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
                      contentPadding: EdgeInsets.only(left: 32, right: 32, bottom: 4),
                    ),
                  ),
                  new TextField(
                    controller: _descriptionController,
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
                      contentPadding: EdgeInsets.only(left: 32, right: 32, bottom: 4),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}
