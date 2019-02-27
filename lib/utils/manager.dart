import 'package:fpomodoro/utils/database.dart';
import 'package:fpomodoro/models/task.dart';

class Manager {

  Future<List<Task>> _tasksData;

  Future<List<Task>> get tasksData => _tasksData;

  addNewTask(Task task) {
    DatabaseUtil.db.insert(task);
  }

  loadAllTasks(){
    _tasksData = DatabaseUtil.db.getAll();
  }
}