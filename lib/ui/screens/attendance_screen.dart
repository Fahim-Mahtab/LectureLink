import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_link/app/app_theme.dart';
import 'package:lecture_link/data/models/attendance_model.dart';
import 'package:lecture_link/providers/attendance_provider.dart';
import 'package:lecture_link/providers/course_provider.dart';
import 'package:lecture_link/providers/student_provider.dart';
import 'package:lecture_link/ui/screens/attendance_history_screen.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  static const String routeName = 'attendance';

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedCourseId;
  final Map<String, bool> _attendanceMap = {};

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final studentProvider = Provider.of<StudentProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: false);

    final courses = courseProvider.courses;
    if (_selectedCourseId == null && courses.isNotEmpty) {
      _selectedCourseId = courses.first.id;
    }

    final currentCourseId = _selectedCourseId ?? '';
    final students = studentProvider.getStudentsForCourse(currentCourseId);

    int presentCount = 0;
    for (var s in students) {
      if (_attendanceMap[s.id] == true) {
        presentCount++;
      }
    }
    final absentCount = students.length - presentCount;

    final dateStr = "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Take Attendance"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppTheme.primaryBlue),
            onPressed: () {
              Navigator.pushNamed(context, AttendanceHistoryScreen.routeName);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Date Picker Card
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: AppTheme.primaryBlue, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Select Date",
                                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                dateStr,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Course Selection Chips
                const Text(
                  "Select Course",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: courses.map((c) {
                      final isSelected = c.id == currentCourseId;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(c.code),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF475569),
                            fontWeight: FontWeight.w500,
                          ),
                          selectedColor: AppTheme.primaryBlue,
                          backgroundColor: const Color(0xFFF1F5F9),
                          side: isSelected ? BorderSide.none : const BorderSide(color: Color(0xFFE2E8F0)),
                          onSelected: (_) {
                            setState(() {
                              _selectedCourseId = c.id;
                              _attendanceMap.clear();
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Stats Cards Row
                Row(
                  children: [
                    _buildStatCard("Present", "$presentCount", const Color(0xFF16A34A), const Color(0xFFF0FDF4), Icons.check_circle),
                    const SizedBox(width: 8),
                    _buildStatCard("Absent", "$absentCount", const Color(0xFFEF4444), const Color(0xFFFEF2F2), Icons.cancel),
                    const SizedBox(width: 8),
                    _buildStatCard("Total", "${students.length}", AppTheme.primaryBlue, const Color(0xFFEFF6FF), Icons.group),
                  ],
                ),
                const SizedBox(height: 16),

                // Student Attendance List Title
                const Text(
                  "Students",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),

                if (students.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        "No students in this course",
                        style: TextStyle(color: Color(0xFF94A3B8)),
                      ),
                    ),
                  )
                else
                  ...students.map((student) {
                    final isPresent = _attendanceMap[student.id] ?? false;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isPresent ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
                          width: isPresent ? 1.5 : 1.0,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _attendanceMap[student.id] = !isPresent;
                          });
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: const Color(0xFFEFF6FF),
                              child: Text(
                                student.name.isNotEmpty ? student.name[0] : 'S',
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
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    student.studentId,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF94A3B8),
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isPresent ? const Color(0xFF22C55E) : const Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPresent ? Icons.check : Icons.close,
                                size: 18,
                                color: isPresent ? Colors.white : const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),

          // Save Attendance Button Bottom Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: students.isEmpty
                    ? null
                    : () {
                        final record = AttendanceRecord(
                          id: 'a_${DateTime.now().millisecondsSinceEpoch}',
                          date: dateStr,
                          courseId: currentCourseId,
                          records: students.map((s) {
                            return AttendanceItem(
                              studentId: s.id,
                              present: _attendanceMap[s.id] ?? false,
                            );
                          }).toList(),
                        );
                        attendanceProvider.saveAttendanceRecord(record);

                        Navigator.pushNamed(
                          context,
                          AttendanceHistoryScreen.routeName,
                        );
                      },
                icon: const Icon(Icons.save),
                label: const Text("Save Attendance"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    Color bg,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: color.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
