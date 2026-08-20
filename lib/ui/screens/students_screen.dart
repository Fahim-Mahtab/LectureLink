import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_link/app/app_theme.dart';
import 'package:lecture_link/providers/course_provider.dart';
import 'package:lecture_link/providers/student_provider.dart';
import 'package:lecture_link/ui/screens/add_student_screen.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  static const String routeName = 'students';

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String? _courseId;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is String) {
        _courseId = arg;
      }
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final studentProvider = Provider.of<StudentProvider>(context);

    final courses = courseProvider.courses;
    final course = _courseId != null
        ? courseProvider.getCourseById(_courseId!)
        : (courses.isNotEmpty ? courses.first : null);

    final selectedCourseId = course?.id ?? '';
    final students = studentProvider.getStudentsForCourse(selectedCourseId);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(course?.name ?? "Students"),
      ),
      body: Column(
        children: [
          // Subheader Info Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tag, size: 13, color: AppTheme.primaryBlue),
                      const SizedBox(width: 4),
                      Text(
                        course?.code ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.group, size: 13, color: Color(0xFF16A34A)),
                      const SizedBox(width: 4),
                      Text(
                        "${students.length} students",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Student List
          Expanded(
            child: students.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.person_off, size: 48, color: Color(0xFFCBD5E1)),
                        SizedBox(height: 12),
                        Text(
                          "No students enrolled yet",
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final initials = student.name.isNotEmpty
                          ? student.name
                              .trim()
                              .split(' ')
                              .map((e) => e.isNotEmpty ? e[0] : '')
                              .take(2)
                              .join('')
                              .toUpperCase()
                          : 'S';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0A0F172A),
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Color.fromARGB(
                                255,
                                220,
                                230 + (index * 5) % 25,
                                250,
                              ),
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    student.studentId,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Action Buttons
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18, color: AppTheme.primaryBlue),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AddStudentScreen.routeName,
                                  arguments: student,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 18, color: Color(0xFFEF4444)),
                              onPressed: () {
                                studentProvider.deleteStudent(student.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AddStudentScreen.routeName,
            arguments: {'courseId': selectedCourseId},
          );
        },
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
