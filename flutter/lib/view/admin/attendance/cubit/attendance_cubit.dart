import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:online_yoklama/core/extension/init/models/failure.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/attendance/model/attendance_model.dart';
import 'package:online_yoklama/view/admin/attendance/repository/attendance_repository.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final AttendanceRepository _attendanceRepository =
      locator<AttendanceRepository>();
  AttendanceCubit() : super(AttendanceState.initial());

  Stream<List<AttendanceModel>> getAttandanceList({required String sessionID}) {
    try {
      emit(state.copyWith(status: AttendanceStatus.loading));
      var response =
          _attendanceRepository.getAttendanceStudentList(sessionID: sessionID);
      emit(state.copyWith(status: AttendanceStatus.loaded));
      return response;
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: AttendanceStatus.error));
      throw const Failure(code: 'Hata', message: 'Bu oturum bulunamadı');
    }
  }
}
