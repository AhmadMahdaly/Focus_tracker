import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_tracker/cubit/task_manegment_cubit/task_manegment_cubit.dart';
import 'package:focus_tracker/models/task_model/task_model.dart';
import 'package:focus_tracker/utils/components/text_field_border.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskManegmentCubit, TaskManegmentState>(
      builder: (context, state) {
        final cubit = context.read<TaskManegmentCubit>();
        return Scaffold(
          appBar: AppBar(leading: LeadingIcon()),

          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
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
                            onPressed: () => cubit.addTask(_taskController),
                          ),
                        ),
                        onSubmitted: (_) {
                          cubit.addTask(_taskController);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: cubit.tasksBox.listenable(),
                  builder: (context, Box box, _) {
                    if (box.isEmpty) {
                      return const Center(child: Text('No tasks yet!'));
                    }
                    return ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        final task = box.getAt(index) as Task;
                        return ListTile(
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration:
                                  task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                            ),
                          ),
                          leading: Checkbox(
                            shape: const CircleBorder(),
                            value: task.isCompleted,
                            checkColor: Colors.blue,
                            activeColor: Colors.white,
                            hoverColor: Colors.blue,
                            focusColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue),
                            onChanged: (_) => cubit.toggleTaskCompletion(index),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => cubit.deleteTask(index),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
