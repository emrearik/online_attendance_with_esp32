import 'package:online_yoklama/view/admin/attendance/model/attendance_model.dart';

abstract class AttendanceBase {
  Stream<List<AttendanceModel>> getAttendanceStudentList(
      {required String sessionID});
}
