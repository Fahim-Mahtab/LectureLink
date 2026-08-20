import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:lecture_link/data/models/course_model.dart';
import 'package:lecture_link/data/services/firestore_service.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [
    Course(id: 'c1', name: 'Database Management Systems', code: 'CSE-301', students: 5),
    Course(id: 'c2', name: 'Software Engineering', code: 'CSE-401', students: 2),
    Course(id: 'c3', name: 'Computer Networks', code: 'CSE-311', students: 0),
    Course(id: 'c4', name: 'Operating Systems', code: 'CSE-321', students: 0),
  ];

  StreamSubscription? _subscription;

  CourseProvider() {
    _listenToFirestore();
  }

  void _listenToFirestore() {
    final col = FirestoreService.instance.coursesCollection;
    if (col != null) {
      _subscription = col.snapshots().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          _courses = snapshot.docs.map((doc) {
            return Course.fromMap(doc.id, doc.data());
          }).toList();
          notifyListeners();
        }
      }, onError: (e) {
        debugPrint("Error listening to Firestore courses: $e");
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  List<Course> get courses => List.unmodifiable(_courses);

  Course? getCourseById(String id) {
    try {
      return _courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return _courses.isNotEmpty ? _courses.first : null;
    }
  }

  // Create
  Future<void> addCourse({required String name, required String code}) async {
    final id = 'c_${DateTime.now().millisecondsSinceEpoch}';
    final newCourse = Course(
      id: id,
      name: name,
      code: code,
      students: 0,
    );


    _courses.add(newCourse);
    notifyListeners();

    final col = FirestoreService.instance.coursesCollection;
    if (col != null) {
      await col.doc(id).set(newCourse.toMap());
    }
  }

  Future<void> updateCourse({
    required String id,
    required String name,
    required String code,
  }) async {
    final index = _courses.indexWhere((c) => c.id == id);
    if (index != -1) {
      _courses[index] = _courses[index].copyWith(name: name, code: code);
      notifyListeners();

      final col = FirestoreService.instance.coursesCollection;
      if (col != null) {
        await col.doc(id).update({
          'name': name,
          'code': code,
        });
      }
    }
  }

  // Delete
  Future<void> deleteCourse(String id) async {
    _courses.removeWhere((c) => c.id == id);
    notifyListeners();

    final col = FirestoreService.instance.coursesCollection;
    if (col != null) {
      await col.doc(id).delete();
    }
  }
}
