import 'package:flutter/material.dart';
import 'package:focus_tracker/screens/focus_timer_screen.dart';
import 'package:focus_tracker/screens/tasks_screen.dart';
import 'package:focus_tracker/widgets/add_task.dart';
import 'package:focus_tracker/widgets/custom_drawer.dart';

class NavyBottomBar extends StatefulWidget {
  const NavyBottomBar({super.key});

  @override
  State<NavyBottomBar> createState() => _NavyBottomBarState();
}

class _NavyBottomBarState extends State<NavyBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TimerScreen(),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),

                // color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 56,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(56),
                        border: Border.all(
                          // color: Colors.black.withAlpha(25),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.home_filled), Text('Home')],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.task_alt_rounded),
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TasksScreen(),
                          ),
                        ),
                  ),
                  IconButton(
                    icon: Icon(Icons.analytics_outlined),
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomDrawer(),
                          ),
                        ),
                  ),
                  SizedBox(width: 0),
                ],
              ),
            ),
          ),
          SizedBox(width: 50),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: FloatingActionButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddTask()),
                  ),
              elevation: 0.5,
              tooltip: 'Add Task',

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(320),
              ),
              child: const Icon(Icons.add),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
