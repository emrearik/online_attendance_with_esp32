import 'package:online_yoklama/core/base/attendance_base.dart';
import 'package:online_yoklama/core/constants/app_mode.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/attendance/model/attendance_model.dart';
import 'package:online_yoklama/view/admin/attendance/services/firestore_attendance_services.dart';

class AttendanceRepository extends AttendanceBase {
  final FirestoreAttendanceServices _firestoreAttendanceServices =
      locator<FirestoreAttendanceServices>();

  @override
  Stream<List<AttendanceModel>> getAttendanceStudentList(
      {required String sessionID}) {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return _firestoreAttendanceServices.getAttendanceStudentList(
          sessionID: sessionID);
    } else {
      return _firestoreAttendanceServices.getAttendanceStudentList(
          sessionID: sessionID);
    }
  }
}
