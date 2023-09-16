import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/task_model.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.task.name;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]),
      child: widget.task.isCompleted ? _isCompleted() : _isNotCompleted(),
    );
  }

  Widget _isNotCompleted() {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          widget.task.isCompleted = !widget.task.isCompleted;
          _localStorage.updateTask(task: widget.task);
          setState(() {});
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(color: Colors.grey),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
      title: TextField(
        textInputAction: TextInputAction.done,
        minLines: 1,
        maxLines: null,
        controller: _taskNameController,
        decoration: const InputDecoration(border: InputBorder.none),
        onSubmitted: (yeniDeger) {
          widget.task.name = yeniDeger;
          _localStorage.updateTask(task: widget.task);
          setState(() {});
        },
      ),
      trailing: Text(
        DateFormat('hh:mm a').format(widget.task.createdAt),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _isCompleted() {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          widget.task.isCompleted = !widget.task.isCompleted;
          _localStorage.updateTask(task: widget.task);
          setState(() {});
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(color: Colors.grey),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        widget.task.name,
        style: const TextStyle(
            decoration: TextDecoration.lineThrough, color: Colors.grey),
      ),
      trailing: Text(
        DateFormat('hh:mm a').format(widget.task.createdAt),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }
}
