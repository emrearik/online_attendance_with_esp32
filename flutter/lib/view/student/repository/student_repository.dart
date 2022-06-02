import 'package:online_yoklama/core/base/student_base.dart';
import 'package:online_yoklama/core/constants/app_mode.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/attendance/model/attendance_model.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';
import 'package:online_yoklama/view/student/services/firestore_student_services.dart';

class StudentRepository extends StudentBase {
  final FirestoreStudentServices _firestoreStudentServices =
      locator<FirestoreStudentServices>();
  @override
  Stream<List<AttendanceModel>> getStudentAttendanceList() {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return _firestoreStudentServices.getStudentAttendanceList();
    } else {
      return _firestoreStudentServices.getStudentAttendanceList();
    }
  }

  @override
  Future<SessionModel> findSession({required String? sessionID}) {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return _firestoreStudentServices.findSession(sessionID: sessionID);
    } else {
      return _firestoreStudentServices.findSession(sessionID: sessionID);
    }
  }
}
