import 'package:flutter/material.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    if (!Hive.isBoxOpen('tasksBox')) {
      await Hive.openBox<Task>('tasksBox');
    }
  }

  final Box tasksBox = Hive.box<Task>('tasksBox');

  void _toggleTaskCompletion(int index) {
    final task = tasksBox.getAt(index) as Task;
    task.isCompleted = !task.isCompleted;
    tasksBox.putAt(index, task);
    setState(() {});
  }

  void _deleteTask(int index) {
    tasksBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(fontWeight: FontWeight.w200),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,

        leading: LeadingIcon(),
        // IconButton(
        //   icon: const Icon(Icons.delete),
        //   onPressed: () {
        //     tasksBox.clear();
        //     setState(() {});
        //   },
        // ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: tasksBox.listenable(),
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
                        value: task.isCompleted,
                        checkColor: Colors.blue,
                        activeColor: Colors.white,
                        hoverColor: Colors.blue,
                        focusColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                        onChanged: (_) => _toggleTaskCompletion(index),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTask(index),
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
  }
}
