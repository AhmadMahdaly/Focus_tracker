import 'package:flutter/material.dart';
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
  final TextEditingController _taskController = TextEditingController();

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      final task = Task(title: _taskController.text);
      tasksBox.add(task);
      _taskController.clear();
      setState(() {});
    }
  }

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
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'أضف مهمة جديدة...',
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _addTask),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: tasksBox.listenable(),
              builder: (context, Box box, _) {
                if (box.isEmpty) {
                  return const Center(child: Text('لا توجد مهام بعد!'));
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
