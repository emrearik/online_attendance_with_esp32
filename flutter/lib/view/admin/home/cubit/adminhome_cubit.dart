import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:online_yoklama/core/extension/init/models/failure.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/home/repository/admin_home_repository.dart';
import 'package:online_yoklama/view/admin/lesson/model/lesson_model.dart';
import 'package:online_yoklama/view/admin/lesson/repository/lesson_repository.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';
import 'package:online_yoklama/view/admin/session/repository/session_repository.dart';
import 'package:online_yoklama/view/auth/repository/auth_repository.dart';

part 'adminhome_state.dart';

class AdminHomeCubit extends Cubit<AdminHomeState> {
  final SessionRepository _sessionRepository = locator<SessionRepository>();
  final LessonRepository _lessonRepository = locator<LessonRepository>();
  final AdminHomeRepository _adminHomeRepository =
      locator<AdminHomeRepository>();
  final AuthRepository _authRepository = locator<AuthRepository>();

  AdminHomeCubit() : super(AdminHomeState.initial()) {
    getAdminInformation();
  }

  getAdminInformation() async {
    try {
      emit(state.copyWith(status: AdminHomeStatus.loading));
      var user = await _adminHomeRepository.getAdminInformation(
          userID: _authRepository.currentUser?.uid);
      emit(state.copyWith(user: user, status: AdminHomeStatus.loaded));
    } on Failure catch (err) {
      emit(
        state.copyWith(status: AdminHomeStatus.error, failure: err),
      );
    }
  }

  Stream<List<SessionModel>> get lastSession {
    emit(state.copyWith(status: AdminHomeStatus.loading));
    var response = _sessionRepository.getLastSession(
        userID: _authRepository.currentUser?.uid);
    emit(state.copyWith(status: AdminHomeStatus.loaded));

    return response;
  }

  Stream<List<LessonModel>> get getLessonList {
    emit(state.copyWith(status: AdminHomeStatus.loading));

    var response = _lessonRepository.getLessonList(
      userID: _authRepository.currentUser?.uid,
    );
    emit(state.copyWith(status: AdminHomeStatus.loaded));
    return response;
  }
}
