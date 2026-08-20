import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:lecture_link/data/models/attendance_model.dart';
import 'package:lecture_link/data/services/firestore_service.dart';

class AttendanceProvider with ChangeNotifier {
  List<AttendanceRecord> _records = [
    AttendanceRecord(
      id: 'a1',
      date: '2026-08-01',
      courseId: 'c1',
      records: [
        AttendanceItem(studentId: 's1', present: true),
        AttendanceItem(studentId: 's2', present: true),
        AttendanceItem(studentId: 's3', present: false),
        AttendanceItem(studentId: 's4', present: true),
        AttendanceItem(studentId: 's5', present: true),
      ],
    ),
    AttendanceRecord(
      id: 'a2',
      date: '2026-08-03',
      courseId: 'c1',
      records: [
        AttendanceItem(studentId: 's1', present: true),
        AttendanceItem(studentId: 's2', present: false),
        AttendanceItem(studentId: 's3', present: true),
        AttendanceItem(studentId: 's4', present: true),
        AttendanceItem(studentId: 's5', present: false),
      ],
    ),
    AttendanceRecord(
      id: 'a3',
      date: '2026-08-05',
      courseId: 'c1',
      records: [
        AttendanceItem(studentId: 's1', present: true),
        AttendanceItem(studentId: 's2', present: true),
        AttendanceItem(studentId: 's3', present: true),
        AttendanceItem(studentId: 's4', present: false),
        AttendanceItem(studentId: 's5', present: true),
      ],
    ),
    AttendanceRecord(
      id: 'a4',
      date: '2026-08-07',
      courseId: 'c1',
      records: [
        AttendanceItem(studentId: 's1', present: true),
        AttendanceItem(studentId: 's2', present: true),
        AttendanceItem(studentId: 's3', present: true),
        AttendanceItem(studentId: 's4', present: true),
        AttendanceItem(studentId: 's5', present: true),
      ],
    ),
  ];

  StreamSubscription? _subscription;

  AttendanceProvider() {
    _listenToFirestore();
  }

  void _listenToFirestore() {
    final col = FirestoreService.instance.attendanceCollection;
    if (col != null) {
      _subscription = col.snapshots().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          _records = snapshot.docs.map((doc) {
            return AttendanceRecord.fromMap(doc.id, doc.data());
          }).toList();
          notifyListeners();
        }
      }, onError: (e) {
        debugPrint("Error listening to Firestore attendance: $e");
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  List<AttendanceRecord> get records => List.unmodifiable(_records);

  List<AttendanceRecord> getRecordsForCourse(String courseId) {
    return _records.where((r) => r.courseId == courseId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> saveAttendanceRecord(AttendanceRecord record) async {
    _records.add(record);
    notifyListeners();

    final col = FirestoreService.instance.attendanceCollection;
    if (col != null) {
      await col.doc(record.id).set(record.toMap());
    }
  }
}
