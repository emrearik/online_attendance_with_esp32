import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_yoklama/core/base/attendance_base.dart';
import 'package:online_yoklama/core/constants/paths.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/attendance/model/attendance_model.dart';

class FirestoreAttendanceServices extends AttendanceBase {
  final FirebaseFirestore _firebaseFirestore = locator<FirebaseFirestore>();

  @override
  Stream<List<AttendanceModel>> getAttendanceStudentList(
      {required String sessionID}) async* {
    yield* _firebaseFirestore
        .collection(Paths.attendance)
        .where('sessionID', isEqualTo: sessionID)
        .snapshots()
        .asyncMap((snapshot) async {
      final list = snapshot.docs.map((doc) async {
        final userMap = await _getUserModel(doc['studentID']);
        final UserModel student = UserModel.fromMap(userMap);
        final attendanceTime = doc['attendanceTime'];

        AttendanceModel attendance =
            AttendanceModel(student: student, attendanceTime: attendanceTime);
        return attendance;
      }).toList();
      return await Future.wait(list);
    });
  }

  Future<Map<String, dynamic>?> _getUserModel(String userID) async {
    final docRef = _firebaseFirestore.collection(Paths.users).doc(userID);
    final document = await docRef.get();
    final story = document.data();
    return story;
  }
}
