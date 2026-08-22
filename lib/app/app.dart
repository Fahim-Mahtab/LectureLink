import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_link/app/app_theme.dart';

import 'package:lecture_link/providers/course_provider.dart';
import 'package:lecture_link/providers/student_provider.dart';
import 'package:lecture_link/providers/attendance_provider.dart';
import 'package:lecture_link/providers/routine_provider.dart';

import 'package:lecture_link/ui/screens/splash_screen.dart';
import 'package:lecture_link/ui/screens/sign_in_screen.dart';
import 'package:lecture_link/ui/screens/sign_up_screen.dart';
import 'package:lecture_link/ui/screens/main_screen.dart';
import 'package:lecture_link/ui/screens/dashboard_screen.dart';
import 'package:lecture_link/ui/screens/courses_screen.dart';
import 'package:lecture_link/ui/screens/add_course_screen.dart';
import 'package:lecture_link/ui/screens/students_screen.dart';
import 'package:lecture_link/ui/screens/add_student_screen.dart';
import 'package:lecture_link/ui/screens/attendance_screen.dart';
import 'package:lecture_link/ui/screens/attendance_history_screen.dart';
import 'package:lecture_link/ui/screens/attendance_summary_screen.dart';
import 'package:lecture_link/ui/screens/routine_screen.dart';
import 'package:lecture_link/ui/screens/add_routine_screen.dart';
import 'package:lecture_link/ui/screens/profile_screen.dart';

class LectureLink extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const LectureLink({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => RoutineProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: SplashScreen.routeName,
        debugShowCheckedModeBanner: false,
        title: "Lecture Link",
        theme: AppTheme.lightTheme,
        routes: <String, WidgetBuilder>{
          SplashScreen.routeName: (_) => const SplashScreen(),
          SignInScreen.routeName: (_) => const SignInScreen(),
          SignUpScreen.routeName: (_) => const SignUpScreen(),
          MainScreen.routeName: (_) => const MainScreen(),
          DashboardScreen.routeName: (_) => const DashboardScreen(),
          CoursesScreen.routeName: (_) => const CoursesScreen(),
          AddCourseScreen.routeName: (_) => const AddCourseScreen(),
          StudentsScreen.routeName: (_) => const StudentsScreen(),
          AddStudentScreen.routeName: (_) => const AddStudentScreen(),
          AttendanceScreen.routeName: (_) => const AttendanceScreen(),
          AttendanceHistoryScreen.routeName: (_) => const AttendanceHistoryScreen(),
          AttendanceSummaryScreen.routeName: (_) => const AttendanceSummaryScreen(),
          RoutineScreen.routeName: (_) => const RoutineScreen(),
          AddRoutineScreen.routeName: (_) => const AddRoutineScreen(),
          ProfileScreen.routeName: (_) => const ProfileScreen(),
        },
      ),
    );
  }
}
