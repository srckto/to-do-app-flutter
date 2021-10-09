import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/models/task.dart';

class DBHelper {
  static Database? db;
  static const _version = 5;
  static const _tableName = "tasks";

  static Future<void> initDb() async {
    if (db != null) {
      return;
    } else {
      try {
        // var error
        print("Create Database");
        String _path = await getDatabasesPath() + "task.db";
        db = await openDatabase(
          _path,
          version: _version,
          onCreate: (Database db, int version) async {
            // When creating the db, create the table
            await db.execute(
                'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, note TEXT, isCompleted INTEGER, date STRING, startTime STRING, endTime STRING, color INTEGER, remind INTEGER, repeat STRING)');
          },
        );
        print("Successful create Database");
      } catch (error) {
        print("Error in Function initDb in file db_helper");
      }
    }
  }
  
  static Future<int> insert(Task task) async {
    print("Insert Function");

    task.id = await db!.insert(_tableName, task.toJson());

    return task.id!;
  }

  static Future delete(Task task) async {
    print("delete Function");

    return await db!.delete(_tableName, where: "id = ?", whereArgs: [task.id]);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query Function");
    return await db!.query(_tableName);
  }

  static Future update(int id) async {
    print("update Function");

    return await db!.rawUpdate(
      '''
    UPDATE $_tableName
    SET isCompleted = ?
    WHERE id = ?
    ''',
      [1, id],
    );
  }

  static Future deleteAllTaskFromDatabase() async {
    return await db!.delete(_tableName);
  }
}
