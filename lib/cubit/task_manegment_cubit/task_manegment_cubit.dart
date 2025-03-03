import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:focus_tracker/widgets/textfield_add_task.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

import '../../models/task_model/task_model.dart';

part 'task_manegment_state.dart';

class TaskManegmentCubit extends Cubit<TaskManegmentState> {
  TaskManegmentCubit() : super(TaskInitial());

  final Box tasksBox = Hive.box<Task>('tasksBox');
  void addTaskDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, size: 16),
              ),
            ],
          ),
          iconPadding: EdgeInsets.zero,
          content: TextFieldAddTask(cubit: this),
        );
      },
    );
  }

  void addTask(taskController) {
    if (taskController.text.isNotEmpty) {
      final task = Task(title: taskController.text);
      tasksBox.add(task);
      taskController.clear();
    }
    emit(AddTask());
  }

  void toggleTaskCompletion(int index) {
    final task = tasksBox.getAt(index) as Task;
    task.isCompleted = !task.isCompleted;
    tasksBox.putAt(index, task);
    emit(TaskUpdated());
  }

  void deleteTask(int index) {
    tasksBox.deleteAt(index);
    emit(TaskDeleted());
  }

  void deleteAllTasks() {
    tasksBox.clear();
    emit(AllTasksDeleted());
  }
}
