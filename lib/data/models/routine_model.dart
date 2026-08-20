class RoutineItem {
  final String id;
  final String courseId;
  final String day;
  final String time;

  RoutineItem({
    required this.id,
    required this.courseId,
    required this.day,
    required this.time,
  });

  RoutineItem copyWith({
    String? id,
    String? courseId,
    String? day,
    String? time,
  }) {
    return RoutineItem(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      day: day ?? this.day,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'day': day,
      'time': time,
    };
  }

  factory RoutineItem.fromMap(String id, Map<String, dynamic> map) {
    return RoutineItem(
      id: id,
      courseId: map['courseId'] as String? ?? '',
      day: map['day'] as String? ?? '',
      time: map['time'] as String? ?? '',
    );
  }
}
