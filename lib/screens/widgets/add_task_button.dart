import 'package:flutter/material.dart';
import 'package:focus_tracker/widgets/add_task.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTask()),
            ),
        elevation: 0.5,
        tooltip: 'Add Task',

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(320)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
