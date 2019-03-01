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

  int maxTitleLength = 24;
  bool _isSaveButtonVisible = false;

  void _saveTaskAndClose() {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (title.trim().isEmpty) {
      return;
    }

    Navigator.pop(context, new Task(0, title, description, false));
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
    final saveButton = IconButton(
        onPressed: _saveTaskAndClose,
        tooltip: 'Save task',
        icon: Icon(
          Icons.save,
          size: 32,
          color: Theme.of(context).primaryColor,
        ));
    return Scaffold(
        body: new Material(
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
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 32,
                          color: Colors.grey,
                        )),
                    Spacer(),
                    _isSaveButtonVisible ? saveButton : Spacer(),
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
                  contentPadding:
                      EdgeInsets.only(left: 32, right: 32, bottom: 4),
                ),
                onChanged: (text) {
                  final needSaveButton =
                      _titleController.text.trim().length > 0;
                  if (_isSaveButtonVisible != needSaveButton) {
                    setState(() {
                      _isSaveButtonVisible = needSaveButton;
                    });
                  }
                },
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
                  contentPadding:
                      EdgeInsets.only(left: 32, right: 32, bottom: 4),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
