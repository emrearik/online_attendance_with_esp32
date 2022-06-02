import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:online_yoklama/core/extension/init/models/failure.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/attendance/model/attendance_model.dart';
import 'package:online_yoklama/view/admin/session/services/firestore_session_service.dart';
import 'package:online_yoklama/view/auth/repository/auth_repository.dart';
import 'package:online_yoklama/view/student/repository/student_repository.dart';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final AuthRepository _authRepository = locator<AuthRepository>();
  final StudentRepository _studentRepository = locator<StudentRepository>();
  final FirestoreSessionService _firestoreSessionService =
      locator<FirestoreSessionService>();
  StudentCubit() : super(StudentState.initial()) {
    getStudentInformation();
  }

  getStudentInformation() async {
    try {
      emit(state.copyWith(status: StudentStatus.loading));
      UserModel? student = await _authRepository.currentUserModel;
      emit(state.copyWith(student: student, status: StudentStatus.initial));
    } on Failure catch (err) {
      emit(state.copyWith(status: StudentStatus.error, failure: err));
    }
  }

  Future<String?> findSessionID({required String? sessionID}) async {
    try {
      emit(state.copyWith(status: StudentStatus.loading));
      String response =
          await _firestoreSessionService.findSessionID(sessionID: sessionID);
      emit(state.copyWith(status: StudentStatus.loaded));
      return response;
    } on Failure catch (err) {
      emit(state.copyWith(status: StudentStatus.error, failure: err));
      return null;
    }
  }

  Stream<List<AttendanceModel>> getStudentAttendanceList() {
    try {
      return _studentRepository.getStudentAttendanceList();
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: StudentStatus.error));
      throw const Failure();
    }
  }
}
