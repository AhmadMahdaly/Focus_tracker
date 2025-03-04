import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:focus_tracker/models/task_model/task_model.dart';
import 'package:focus_tracker/widgets/textfield_add_task.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'task_manegment_state.dart';

class TaskManegmentCubit extends Cubit<TaskManegmentState> {
  TaskManegmentCubit() : super(TaskInitial());

  final Box<Task> tasksBox = Hive.box<Task>('tasksBox');
  void addTaskDialog(BuildContext context) {
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
                icon: const Icon(Icons.close, size: 16),
              ),
            ],
          ),
          iconPadding: EdgeInsets.zero,
          content: TextFieldAddTask(cubit: this),
        );
      },
    );
  }

  void addTask(TextEditingController taskController) {
    if (taskController.text.isNotEmpty) {
      final task = Task(title: taskController.text);
      tasksBox.add(task);
      taskController.clear();
    }
    emit(AddTask());
  }

  void toggleTaskCompletion(int index) {
    final task = tasksBox.getAt(index)!;
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
