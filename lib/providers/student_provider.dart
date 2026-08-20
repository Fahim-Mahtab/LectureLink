import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:lecture_link/data/models/student_model.dart';
import 'package:lecture_link/data/services/firestore_service.dart';

class StudentProvider with ChangeNotifier {
  List<Student> _students = [
    Student(id: 's1', name: 'Arham Shaikh', studentId: '2021-CSE-001', courseId: 'c1'),
    Student(id: 's2', name: 'Fatima Noor', studentId: '2021-CSE-002', courseId: 'c1'),
    Student(id: 's3', name: 'Bilal Raza', studentId: '2021-CSE-003', courseId: 'c1'),
    Student(id: 's4', name: 'Zara Ahmad', studentId: '2021-CSE-004', courseId: 'c1'),
    Student(id: 's5', name: 'Hamza Khan', studentId: '2021-CSE-005', courseId: 'c1'),
    Student(id: 's6', name: 'Ayesha Malik', studentId: '2021-CSE-006', courseId: 'c2'),
    Student(id: 's7', name: 'Usman Ali', studentId: '2021-CSE-007', courseId: 'c2'),
  ];

  StreamSubscription? _subscription;

  StudentProvider() {
    _listenToFirestore();
  }

  void _listenToFirestore() {
    final col = FirestoreService.instance.studentsCollection;
    if (col != null) {
      _subscription = col.snapshots().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          _students = snapshot.docs.map((doc) {
            return Student.fromMap(doc.id, doc.data());
          }).toList();
          notifyListeners();
        }
      }, onError: (e) {
        debugPrint("Error listening to Firestore students: $e");
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  List<Student> get students => List.unmodifiable(_students);

  List<Student> getStudentsForCourse(String courseId) {
    return _students.where((s) => s.courseId == courseId).toList();
  }

  int getStudentCountForCourse(String courseId) {
    return _students.where((s) => s.courseId == courseId).length;
  }

  // Create
  Future<void> addStudent({
    required String name,
    required String studentId,
    required String courseId,
  }) async {
    final id = 's_${DateTime.now().millisecondsSinceEpoch}';
    final newStudent = Student(
      id: id,
      name: name,
      studentId: studentId,
      courseId: courseId,
    );

    _students.add(newStudent);
    notifyListeners();

    final col = FirestoreService.instance.studentsCollection;
    if (col != null) {
      await col.doc(id).set(newStudent.toMap());
    }
  }

  // Update
  Future<void> updateStudent({
    required String id,
    required String name,
    required String studentId,
  }) async {
    final index = _students.indexWhere((s) => s.id == id);
    if (index != -1) {
      _students[index] = _students[index].copyWith(
        name: name,
        studentId: studentId,
      );
      notifyListeners();

      final col = FirestoreService.instance.studentsCollection;
      if (col != null) {
        await col.doc(id).update({
          'name': name,
          'studentId': studentId,
        });
      }
    }
  }

  // Delete
  Future<void> deleteStudent(String id) async {
    _students.removeWhere((s) => s.id == id);
    notifyListeners();

    final col = FirestoreService.instance.studentsCollection;
    if (col != null) {
      await col.doc(id).delete();
    }
  }
}
