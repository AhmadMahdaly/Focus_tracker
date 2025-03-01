import 'package:flutter/material.dart';
import 'package:focus_tracker/screens/focus_timer_screen.dart';
import 'package:focus_tracker/screens/tasks_screen.dart';
import 'package:focus_tracker/widgets/add_task.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavyBottomBar extends StatefulWidget {
  const NavyBottomBar({super.key});

  @override
  State<NavyBottomBar> createState() => _NavyBottomBarState();
}

class _NavyBottomBarState extends State<NavyBottomBar> {
  int _currentIndex = 0;
  void _onItemTapped(index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _currentIndex = index);
      }
    });
  }

  List<Widget> pages = [TimerScreen(), TasksScreen(), TimerScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_currentIndex),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 10,
                    spreadRadius: 5, // changes position of shadow
                  ),
                ],
              ),
              child: GNav(
                onTabChange: _onItemTapped,
                selectedIndex: _currentIndex,
                rippleColor:
                    Colors.white, // tab button ripple color when pressed
                hoverColor: Colors.white54, // tab button hover color
                haptic: true, // haptic feedback
                // tabBorder: Border.all(
                //   color: Colors.black.withAlpha(25),
                //   width: 0.5,
                // ), // tab button border
                tabBorderRadius: 56,
                tabActiveBorder: Border.all(
                  color: Colors.black.withAlpha(25),
                  width: 2,
                ), // tab button border

                duration: Duration(milliseconds: 900), // tab animation duration
                gap: 8, // the tab button gap between icon and text
                // color: Colors.red[800], // unselected icon color
                activeColor: Colors.blue, // selected icon and text color
                iconSize: 24, // tab button icon size

                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ), // navigation bar padding
                tabs: [
                  GButton(icon: Icons.home_filled, text: 'Home'),
                  GButton(icon: Icons.task_alt_rounded, text: 'Tasks'),
                  GButton(icon: Icons.access_time_rounded, text: 'Timer'),
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
