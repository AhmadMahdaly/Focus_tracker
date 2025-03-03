import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_tracker/cubit/task_manegment_cubit/task_manegment_cubit.dart';
import 'package:focus_tracker/cubit/timer_manegment_cubit/timer_manegment_cubit.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model/task_model.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskManegmentCubit, TaskManegmentState>(
      builder: (context, state) {
        final cubit = context.read<TaskManegmentCubit>();
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Here\'s your tasks',
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
            ),

            automaticallyImplyLeading: false,

            leading: LeadingIcon(),
          ),

          body: Column(
            children: [
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  context.read<TimerManegmentCubit>().isRunning
                                      ? context
                                          .read<TimerManegmentCubit>()
                                          .pauseTimer()
                                      : context
                                          .read<TimerManegmentCubit>()
                                          .startTimer();
                                  Navigator.pop(context);
                                },
                                icon:
                                    context
                                            .read<TimerManegmentCubit>()
                                            .isRunning
                                        ? const Icon(Icons.pause)
                                        : const Icon(Icons.play_arrow_rounded),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => cubit.deleteTask(index),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () => cubit.addTaskDialog(context),
            elevation: 0.5,
            tooltip: 'Add Task',

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(320),
            ),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
