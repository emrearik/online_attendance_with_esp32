import 'package:online_yoklama/view/admin/attendance/model/attendance_model.dart';

abstract class StudentAttendanceBase {
  Stream<List<AttendanceModel>> getStudentAttendanceList();
}
