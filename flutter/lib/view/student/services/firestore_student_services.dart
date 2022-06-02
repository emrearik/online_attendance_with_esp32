import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_yoklama/core/base/student_base.dart';
import 'package:online_yoklama/core/constants/paths.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/attendance/model/attendance_model.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';
import 'package:online_yoklama/view/admin/session/services/firestore_session_service.dart';
import 'package:online_yoklama/view/auth/repository/auth_repository.dart';

class FirestoreStudentServices extends StudentBase {
  final FirebaseFirestore _firebaseFirestore = locator<FirebaseFirestore>();
  final FirestoreSessionService _firestoreSessionService =
      locator<FirestoreSessionService>();
  final AuthRepository _authRepository = locator<AuthRepository>();

  @override
  Stream<List<AttendanceModel>> getStudentAttendanceList() async* {
    final user = await _authRepository.currentUserModel;

    yield* _firebaseFirestore
        .collection(Paths.attendance)
        .where('studentID', isEqualTo: user?.userID)
        .snapshots()
        .asyncMap((snapshot) async {
      final list = snapshot.docs.map((doc) async {
        final sessionModelDoc = await _getSessionModel(doc['sessionID']);

        final AttendanceModel attendance = AttendanceModel(
            session: SessionModel.fromMap(sessionModelDoc!),
            attendanceTime: doc['attendanceTime']);

        return attendance;
      }).toList();
      return await Future.wait(list);
    });
  }

  @override
  Future<SessionModel> findSession({required String? sessionID}) async {
    var response = await _firebaseFirestore
        .collection(Paths.session)
        .where('sessionID', isEqualTo: sessionID)
        .get();

    return response.docs.map((e) => SessionModel.fromMap(e.data())).first;
  }

  Future<Map<String, dynamic>?> _getSessionModel(String sessionCode) async {
    String sessionID =
        await _firestoreSessionService.findSessionID(sessionID: sessionCode);
    final docRef = _firebaseFirestore.collection(Paths.session).doc(sessionID);
    final document = await docRef.get();
    final story = document.data();
    return story;
  }
}
