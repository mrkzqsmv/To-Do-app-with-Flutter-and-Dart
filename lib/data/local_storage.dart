import 'dart:async';

import 'package:hive/hive.dart';
import 'package:to_do_app/models/task_model.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<List<Task>> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
}

class HiveLocalStorage extends LocalStorage {
  late Box<Task> _taskbox;

  HiveLocalStorage() {
    _taskbox = Hive.box<Task>('tasks');
  }
  @override
  Future<void> addTask({required Task task}) async {
    await _taskbox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> allTasks = [];
    allTasks = _taskbox.values.toList();

    if (allTasks.isNotEmpty) {
      allTasks.sort((Task a, Task b) => a.createdAt.compareTo(b.createdAt));
    }
    return allTasks;
  }

  @override
  Future<Task?> getTask({required String id}) async {
    if (_taskbox.containsKey(id)) {
      return _taskbox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<Task> updateTask({required Task task}) async{
    await task.save();
    return task;
  }
}
