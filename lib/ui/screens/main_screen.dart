import 'package:flutter/material.dart';
import 'package:lecture_link/app/app_theme.dart';
import 'package:lecture_link/ui/screens/dashboard_screen.dart';
import 'package:lecture_link/ui/screens/courses_screen.dart';
import 'package:lecture_link/ui/screens/attendance_screen.dart';
import 'package:lecture_link/ui/screens/routine_screen.dart';
import 'package:lecture_link/ui/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const String routeName = 'main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onNavigateTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(onNavigateTab: _onNavigateTab),
      const CoursesScreen(),
      const AttendanceScreen(),
      const RoutineScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          border: Border(
            top: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: AppTheme.primaryBlue,
          unselectedItemColor: const Color(0xFF94A3B8),
          showUnselectedLabels: true,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFFF8FAFC),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.how_to_reg_outlined),
              activeIcon: Icon(Icons.how_to_reg),
              label: 'Attendance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: 'Routine',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
