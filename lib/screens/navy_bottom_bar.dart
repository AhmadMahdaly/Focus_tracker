import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focus_tracker/screens/focus_timer_screen.dart';
import 'package:focus_tracker/screens/stats_screen.dart';
import 'package:focus_tracker/screens/tasks_screen.dart';
import 'package:focus_tracker/screens/widgets/add_task_button.dart';
import 'package:focus_tracker/widgets/exit_dialog.dart';

class NavyBottomBar extends StatelessWidget {
  const NavyBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showExitConfirmation(context);
        return shouldExit!;
      },
      //  PopScope(
      // canPop: false,
      // onPopInvokedWithResult: (didPop, result) {
      //   if (didPop) return;
      //   showExitConfirmation(context);
      // },
      child: Scaffold(
        body: const TimerScreen(),
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
                        children: [
                          const Icon(Icons.home_filled),
                          Text('Home'.tr()),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.task_alt_rounded),
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TasksScreen(),
                            ),
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.analytics_outlined),
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StatsScreen(),
                            ),
                          ),
                    ),
                    const SizedBox(width: 0),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 50),
            const AddTaskButton(),
            const SizedBox(width: 16),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
