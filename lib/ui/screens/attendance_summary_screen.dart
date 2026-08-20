import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_link/app/app_theme.dart';
import 'package:lecture_link/providers/attendance_provider.dart';
import 'package:lecture_link/providers/course_provider.dart';
import 'package:lecture_link/providers/student_provider.dart';
import 'package:lecture_link/ui/widgets/circular_progress.dart';

class AttendanceSummaryScreen extends StatefulWidget {
  const AttendanceSummaryScreen({super.key});

  static const String routeName = 'attendance-summary';

  @override
  State<AttendanceSummaryScreen> createState() => _AttendanceSummaryScreenState();
}

class _AttendanceSummaryScreenState extends State<AttendanceSummaryScreen> {
  String? _selectedCourseId;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is String) {
        _selectedCourseId = arg;
      }
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final studentProvider = Provider.of<StudentProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    final courses = courseProvider.courses;
    if (_selectedCourseId == null && courses.isNotEmpty) {
      _selectedCourseId = courses.first.id;
    }

    final currentCourseId = _selectedCourseId ?? '';
    final records = attendanceProvider.getRecordsForCourse(currentCourseId);
    final students = studentProvider.getStudentsForCourse(currentCourseId);
    final totalClasses = records.length;

    // Calculate per-student stats
    final studentStats = students.map((student) {
      int attendedCount = 0;
      for (var record in records) {
        final item = record.records.firstWhere(
              (r) => r.studentId == student.id,
          orElse: () => rItem(student.id, false),
        );
        if (item.present) {
          attendedCount++;
        }
      }
      final pct = totalClasses > 0 ? ((attendedCount / totalClasses) * 100).round() : 0;
      return _StudentStat(student: student, attended: attendedCount, pct: pct);
    }).toList()
      ..sort((a, b) => b.pct.compareTo(a.pct));

    final avgPct = studentStats.isNotEmpty
        ? (studentStats.fold<int>(0, (sum, s) => sum + s.pct) / studentStats.length).round()
        : 0;

    final lowAttendanceCount = studentStats.where((s) => s.pct < 75).length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Attendance Summary"),
      ),
      body: Column(
        children: [
          // Course Selector Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: SingleChildScrollView(
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
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(height: 1),

          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Overview Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A0F172A),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CustomCircularProgress(percentage: avgPct, size: 80),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Class Average",
                                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "$avgPct%",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "attendance rate",
                                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Metric Grid
                      Row(
                        children: [
                          _buildSummaryMetricTile(
                            "Total Classes",
                            "$totalClasses",
                            AppTheme.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          _buildSummaryMetricTile(
                            "Students",
                            "${students.length}",
                            const Color(0xFF16A34A),
                          ),
                          const SizedBox(width: 8),
                          _buildSummaryMetricTile(
                            "Below 75%",
                            "$lowAttendanceCount",
                            const Color(0xFFEF4444),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Student Breakdown Title
                const Text(
                  "STUDENT BREAKDOWN",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),

                if (studentStats.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        "No student data available",
                        style: TextStyle(color: Color(0xFF94A3B8)),
                      ),
                    ),
                  )
                else
                  ...studentStats.map((s) {
                    Color progressColor;
                    if (s.pct >= 75) {
                      progressColor = const Color(0xFF22C55E);
                    } else if (s.pct >= 50) {
                      progressColor = const Color(0xFFF59E0B);
                    } else {
                      progressColor = const Color(0xFFEF4444);
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 17,
                            backgroundColor: const Color(0xFFEFF6FF),
                            child: Text(
                              s.student.name.isNotEmpty ? s.student.name[0] : 'S',
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
                                  s.student.name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  s.student.studentId,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF94A3B8),
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: LinearProgressIndicator(
                                    value: s.pct / 100,
                                    backgroundColor: const Color(0xFFF1F5F9),
                                    color: progressColor,
                                    minHeight: 4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${s.pct}%",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: progressColor,
                                ),
                              ),
                              Text(
                                "${s.attended}/$totalClasses",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMetricTile(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentStat {
  final dynamic student;
  final int attended;
  final int pct;

  _StudentStat({
    required this.student,
    required this.attended,
    required this.pct,
  });
}

dynamic rItem(String sid, bool p) {
  return _TempItem(studentId: sid, present: p);
}

class _TempItem {
  final String studentId;
  final bool present;
  _TempItem({required this.studentId, required this.present});
}
