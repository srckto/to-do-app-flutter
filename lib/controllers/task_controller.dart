import 'package:get/get.dart';
import 'package:to_do_app/db/db_helper.dart';
import 'package:to_do_app/models/task.dart';

class TaskController extends GetxController {
  RxList<Task> tasks = <Task>[].obs;

  Future addTask({required Task task}) async {
    return await DBHelper.insert(task);
  }

  getTasks() async {
    final List<Map<String, dynamic>> _pickedData = await DBHelper.query();
    tasks.assignAll(_pickedData.map((element) => Task.fromJson(element)).toList());
  }

  deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  taskComplete(int id) async {
    await DBHelper.update(id);
    getTasks();
  }

  deleteAllTask() async {
    await DBHelper.deleteAllTaskFromDatabase();
    getTasks();
  }
}
