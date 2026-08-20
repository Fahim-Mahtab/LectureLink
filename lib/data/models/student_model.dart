class Student {
  final String id;
  final String name;
  final String studentId;
  final String courseId;

  Student({
    required this.id,
    required this.name,
    required this.studentId,
    required this.courseId,
  });

  Student copyWith({
    String? id,
    String? name,
    String? studentId,
    String? courseId,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      studentId: studentId ?? this.studentId,
      courseId: courseId ?? this.courseId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'studentId': studentId,
      'courseId': courseId,
    };
  }

  factory Student.fromMap(String id, Map<String, dynamic> map) {
    return Student(
      id: id,
      name: map['name'] as String? ?? '',
      studentId: map['studentId'] as String? ?? '',
      courseId: map['courseId'] as String? ?? '',
    );
  }
}
