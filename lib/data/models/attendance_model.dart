class AttendanceItem {
  final String studentId;
  final bool present;

  AttendanceItem({
    required this.studentId,
    required this.present,
  });

  AttendanceItem copyWith({
    String? studentId,
    bool? present,
  }) {
    return AttendanceItem(
      studentId: studentId ?? this.studentId,
      present: present ?? this.present,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'present': present,
    };
  }

  factory AttendanceItem.fromMap(Map<String, dynamic> map) {
    return AttendanceItem(
      studentId: map['studentId'] as String? ?? '',
      present: map['present'] as bool? ?? false,
    );
  }
}

class AttendanceRecord {
  final String id;
  final String date;
  final String courseId;
  final List<AttendanceItem> records;

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.courseId,
    required this.records,
  });

  AttendanceRecord copyWith({
    String? id,
    String? date,
    String? courseId,
    List<AttendanceItem>? records,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      courseId: courseId ?? this.courseId,
      records: records ?? this.records,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'courseId': courseId,
      'records': records.map((r) => r.toMap()).toList(),
    };
  }

  factory AttendanceRecord.fromMap(String id, Map<String, dynamic> map) {
    final rawRecords = map['records'] as List<dynamic>? ?? [];
    final items = rawRecords
        .map((e) => AttendanceItem.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();

    return AttendanceRecord(
      id: id,
      date: map['date'] as String? ?? '',
      courseId: map['courseId'] as String? ?? '',
      records: items,
    );
  }
}
