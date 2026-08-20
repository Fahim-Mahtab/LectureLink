import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  FirebaseFirestore? get _db {
    try {
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  CollectionReference<Map<String, dynamic>>? get coursesCollection =>
      _db?.collection('courses');

  CollectionReference<Map<String, dynamic>>? get studentsCollection =>
      _db?.collection('students');

  CollectionReference<Map<String, dynamic>>? get attendanceCollection =>
      _db?.collection('attendance');

  CollectionReference<Map<String, dynamic>>? get routineCollection =>
      _db?.collection('routine');
}
