import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:lecture_link/data/models/routine_model.dart';
import 'package:lecture_link/data/services/firestore_service.dart';

class RoutineProvider with ChangeNotifier {
  List<RoutineItem> _routineItems = [
    RoutineItem(id: 'r1', courseId: 'c1', day: 'Monday', time: '08:00 – 09:30'),
    RoutineItem(id: 'r2', courseId: 'c2', day: 'Monday', time: '10:00 – 11:30'),
    RoutineItem(id: 'r3', courseId: 'c3', day: 'Tuesday', time: '09:00 – 10:30'),
    RoutineItem(id: 'r4', courseId: 'c4', day: 'Tuesday', time: '11:00 – 12:30'),
    RoutineItem(id: 'r5', courseId: 'c1', day: 'Wednesday', time: '08:00 – 09:30'),
    RoutineItem(id: 'r6', courseId: 'c2', day: 'Thursday', time: '10:00 – 11:30'),
    RoutineItem(id: 'r7', courseId: 'c3', day: 'Friday', time: '09:00 – 10:30'),
    RoutineItem(id: 'r8', courseId: 'c4', day: 'Saturday', time: '08:00 – 09:30'),
  ];

  StreamSubscription? _subscription;

  RoutineProvider() {
    _listenToFirestore();
  }

  void _listenToFirestore() {
    final col = FirestoreService.instance.routineCollection;
    if (col != null) {
      _subscription = col.snapshots().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          _routineItems = snapshot.docs.map((doc) {
            return RoutineItem.fromMap(doc.id, doc.data());
          }).toList();
          notifyListeners();
        }
      }, onError: (e) {
        debugPrint("Error listening to Firestore routine: $e");
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  List<RoutineItem> get routineItems => List.unmodifiable(_routineItems);

  List<RoutineItem> getRoutineForDay(String day) {
    return _routineItems.where((r) => r.day == day).toList()
      ..sort((a, b) => a.time.compareTo(b.time));
  }

  Future<void> addRoutineItem({
    required String courseId,
    required String day,
    required String startTime,
    required String endTime,
  }) async {
    final id = 'r_${DateTime.now().millisecondsSinceEpoch}';
    final newItem = RoutineItem(
      id: id,
      courseId: courseId,
      day: day,
      time: '$startTime – $endTime',
    );

    _routineItems.add(newItem);
    notifyListeners();

    final col = FirestoreService.instance.routineCollection;
    if (col != null) {
      await col.doc(id).set(newItem.toMap());
    }
  }

  Future<void> deleteRoutineItem(String id) async {
    _routineItems.removeWhere((r) => r.id == id);
    notifyListeners();

    final col = FirestoreService.instance.routineCollection;
    if (col != null) {
      await col.doc(id).delete();
    }
  }
}
