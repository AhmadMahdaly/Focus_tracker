import 'package:flutter/material.dart';
import 'package:focus_tracker/screens/focus_timer_screen.dart';
import 'package:focus_tracker/screens/tasks_screen.dart';
import 'package:focus_tracker/screens/widgets/add_task_button.dart';
import 'package:focus_tracker/widgets/custom_drawer.dart';

class NavyBottomBar extends StatelessWidget {
  const NavyBottomBar({super.key});

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
                border: Border.all(
                  color: Colors.blue.withAlpha(100),
                  width: 0.9,
                ),
                // color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 56,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.blue.withAlpha(100),
                        width: 0.9,
                      ),
                    ),
                    child: Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.home_filled), Text('Home')],
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
          AddTaskButton(),
          SizedBox(width: 16),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
