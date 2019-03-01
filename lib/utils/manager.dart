import 'package:fpomodoro/utils/database.dart';
import 'package:fpomodoro/models/task.dart';

class Manager {

  Future<List<Task>> tasksData;


  addNewTask(Task task) async {
    await DatabaseUtil.db.insert(task);
    loadAllTasks() ;
  }

  updateTask(Task task) async {
    await DatabaseUtil.db.update(task);
    loadAllTasks() ;
  }

  loadAllTasks() {
    tasksData = DatabaseUtil.db.getAll();
  }
}