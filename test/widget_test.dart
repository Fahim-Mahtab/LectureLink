import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:lecture_link/providers/course_provider.dart';
import 'package:lecture_link/providers/student_provider.dart';
import 'package:lecture_link/providers/attendance_provider.dart';
import 'package:lecture_link/providers/routine_provider.dart';
import 'package:lecture_link/ui/screens/main_screen.dart';

void main() {
  testWidgets('MainScreen renders dashboard and navigation smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CourseProvider()),
          ChangeNotifierProvider(create: (_) => StudentProvider()),
          ChangeNotifierProvider(create: (_) => AttendanceProvider()),
          ChangeNotifierProvider(create: (_) => RoutineProvider()),
        ],
        child: const MaterialApp(
          home: MainScreen(),
        ),
      ),
    );

    expect(find.text('Dr. Sarah Ahmed'), findsOneWidget);
    expect(find.text('QUICK ACCESS'), findsOneWidget);
  });
}
