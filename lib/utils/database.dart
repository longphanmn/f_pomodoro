import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fpomodoro/models/task.dart';

class DatabaseUtil{

  DatabaseUtil._();

  static final DatabaseUtil db = DatabaseUtil._();
  static Database _database;

  Future<Database> get database async{
    if(_database != null){
      return _database;
    }

    _database = await init();
    return _database;
  }

  init() async{

    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'tasks.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE Task ('
              'id INTEGER PRIMARY KEY,'
              'title TEXT,'
              'description TEXT,'
              'done INTEGER'
              ')');
        }
    );
  }

  insert(Task task) async{

    var db = await database;

    var table = await db.rawQuery('SELECT MAX(id)+1 as id FROM Task');
    var id = table.first['id'];

    var raw = db.rawInsert(
        'INSERT Into Task (id, title, description, done) VALUES (?,?,?,?)',
        [id, task.title, task.description, task.done ? 1 : 0]
    );

    print('Saved');
    return raw;
  }

  update(Task task) async{

    var db = await database;

    var raw = db.rawUpdate(
        'UPDATE Task SET title = ?, description = ?, done = ? WHERE id = ?',
        [task.title, task.description, task.done ? 1 : 0, task.id]
    );

    print('Updated');
    return raw;
  }

  Future<List<Task>> getAll() async {

    var db = await database;
    var query = await db.query('Task');

    List<Task> tasks = query.isNotEmpty ?
    query.map((t) => Task.fromMap(t)).toList() : [ ];

    return tasks;
  }
}