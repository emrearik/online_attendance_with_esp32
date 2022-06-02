import 'package:online_yoklama/view/admin/attendance/model/attendance_model.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';

abstract class StudentBase {
  Future<SessionModel> findSession({required String? sessionID});
  Stream<List<AttendanceModel>> getStudentAttendanceList();
}
