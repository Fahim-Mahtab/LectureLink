import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_link/app/app_theme.dart';
import 'package:lecture_link/providers/course_provider.dart';
import 'package:lecture_link/providers/routine_provider.dart';
import 'package:lecture_link/ui/screens/add_routine_screen.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  static const String routeName = 'routine';

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  static const List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  String _selectedDay = 'Monday';

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutineProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);

    final dayRoutine = routineProvider.getRoutineForDay(_selectedDay);

    final colors = [
      const Color(0xFFEFF6FF),
      const Color(0xFFF0FDF4),
      const Color(0xFFFFF7ED),
      const Color(0xFFFDF4FF),
      const Color(0xFFFFFBEB),
      const Color(0xFFF0F9FF),
    ];
    final iconColors = [
      const Color(0xFF2563EB),
      const Color(0xFF16A34A),
      const Color(0xFFEA580C),
      const Color(0xFF9333EA),
      const Color(0xFFD97706),
      const Color(0xFF0284C7),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Class Routine"),
      ),
      body: Column(
        children: [
          // Day Tabs Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: days.map((day) {
                  final isSelected = day == _selectedDay;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selected: isSelected,
                      label: Text(day.substring(0, 3)),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                        fontWeight: FontWeight.w500,
                      ),
                      selectedColor: AppTheme.primaryBlue,
                      backgroundColor: const Color(0xFFF1F5F9),
                      side: isSelected ? BorderSide.none : const BorderSide(color: Color(0xFFE2E8F0)),
                      onSelected: (_) {
                        setState(() {
                          _selectedDay = day;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(height: 1),

          // Routine Cards List
          Expanded(
            child: dayRoutine.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.event_available, size: 48, color: Color(0xFFCBD5E1)),
                        const SizedBox(height: 12),
                        Text(
                          "No classes scheduled on $_selectedDay",
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: dayRoutine.length,
                    itemBuilder: (context, index) {
                      final item = dayRoutine[index];
                      final course = courseProvider.getCourseById(item.courseId);
                      final colorIndex = index % colors.length;
                      final bg = colors[colorIndex];
                      final accent = iconColors[colorIndex];

                      final times = item.time.split('–');
                      final startTime = times[0].trim();
                      final endTime = times.length > 1 ? times[1].trim() : '';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
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
                            Container(
                              width: 4,
                              height: 44,
                              decoration: BoxDecoration(
                                color: accent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.class_, color: accent, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course?.name ?? "Unknown Course",
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
                                    course?.code ?? "",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  startTime,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  "–$endTime",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFF94A3B8)),
                              onPressed: () {
                                routineProvider.deleteRoutineItem(item.id);
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
          Navigator.pushNamed(context, AddRoutineScreen.routeName);
        },
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
