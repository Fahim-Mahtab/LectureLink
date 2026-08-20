import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_link/app/app_theme.dart';
import 'package:lecture_link/providers/course_provider.dart';
import 'package:lecture_link/providers/student_provider.dart';
import 'package:lecture_link/ui/screens/add_course_screen.dart';
import 'package:lecture_link/ui/screens/students_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  static const String routeName = 'courses';

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _searchQuery = '';

  void _confirmDeleteCourse(BuildContext context, String courseId, String courseName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Course"),
        content: Text("Are you sure you want to delete '$courseName'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Provider.of<CourseProvider>(context, listen: false).deleteCourse(courseId);
              Navigator.pop(ctx);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final studentProvider = Provider.of<StudentProvider>(context);

    final courses = courseProvider.courses.where((c) {
      final query = _searchQuery.toLowerCase();
      return c.name.toLowerCase().contains(query) ||
          c.code.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Courses"),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list, size: 18, color: AppTheme.primaryBlue),
              onPressed: () {},
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search courses...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                fillColor: const Color(0xFFF8FAFC),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 1.5),
                ),
              ),
            ),
          ),
          const Divider(height: 1),

          // Course List
          Expanded(
            child: courses.isEmpty
                ? const Center(
                    child: Text(
                      "No courses found",
                      style: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      final studentCount = studentProvider.getStudentCountForCourse(course.id);

                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            StudentsScreen.routeName,
                            arguments: course.id,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0F0F172A),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.menu_book,
                                  color: AppTheme.primaryBlue,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF0F172A),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      course.code,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.group,
                                            size: 14,
                                            color: Color(0xFF94A3B8),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "$studentCount",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        "Students",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Color(0xFF94A3B8),
                                      size: 20,
                                    ),
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        Navigator.pushNamed(
                                          context,
                                          AddCourseScreen.routeName,
                                          arguments: course,
                                        );
                                      } else if (value == 'delete') {
                                        _confirmDeleteCourse(context, course.id, course.name);
                                      }
                                    },
                                    itemBuilder: (ctx) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 18, color: AppTheme.primaryBlue),
                                            SizedBox(width: 8),
                                            Text("Edit Course"),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, size: 18, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text("Delete Course", style: TextStyle(color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddCourseScreen.routeName);
        },
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
