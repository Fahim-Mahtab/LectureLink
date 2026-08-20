class Course {
  final String id;
  final String name;
  final String code;
  final int students;

  Course({
    required this.id,
    required this.name,
    required this.code,
    this.students = 0,
  });

  Course copyWith({
    String? id,
    String? name,
    String? code,
    int? students,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      students: students ?? this.students,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'students': students,
    };
  }

  factory Course.fromMap(String id, Map<String, dynamic> map) {
    return Course(
      id: id,
      name: map['name'] as String? ?? '',
      code: map['code'] as String? ?? '',
      students: (map['students'] as num?)?.toInt() ?? 0,
    );
  }
}
