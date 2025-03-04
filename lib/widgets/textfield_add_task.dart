import 'package:flutter/material.dart';
import 'package:focus_tracker/cubit/task_manegment_cubit/task_manegment_cubit.dart';
import 'package:focus_tracker/utils/components/text_field_border.dart';

class TextFieldAddTask extends StatefulWidget {
  const TextFieldAddTask({required this.cubit, super.key});

  final TaskManegmentCubit cubit;

  @override
  State<TextFieldAddTask> createState() => _TextFieldAddTaskState();
}

class _TextFieldAddTaskState extends State<TextFieldAddTask> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _taskController,
      decoration: InputDecoration(
        hintText: 'Add a task',
        border: border(),
        focusedBorder: border(),
        enabledBorder: border(),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.done, size: 28),
          onPressed: () {
            widget.cubit.addTask(_taskController);
            Navigator.pop(context);
          },
        ),
      ),
      onSubmitted: (_) {
        widget.cubit.addTask(_taskController);
        Navigator.pop(context);
      },
    );
  }
}
