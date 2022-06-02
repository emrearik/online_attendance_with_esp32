import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:online_yoklama/core/extension/init/models/failure.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/lesson/model/lesson_model.dart';
import 'package:online_yoklama/view/admin/lesson/repository/lesson_repository.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';
import 'package:online_yoklama/view/admin/session/repository/session_repository.dart';
import 'package:online_yoklama/view/auth/repository/auth_repository.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final SessionRepository _sessionRepository = locator<SessionRepository>();
  final LessonRepository _lessonRepository = locator<LessonRepository>();
  final AuthRepository _authRepository = locator<AuthRepository>();

  SessionCubit() : super(SessionState.initial());

  Stream<List<LessonModel>> get lessonList {
    emit(state.copyWith(status: SessionStatus.loading));
    var response = _lessonRepository.getLessonList(
        userID: _authRepository.currentUser?.uid);
    emit(state.copyWith(status: SessionStatus.loaded));
    return response;
  }

  Stream<List<SessionModel>> get sessionList {
    emit(state.copyWith(status: SessionStatus.loading));
    var response = _sessionRepository.getSessionList(
        userID: _authRepository.currentUser?.uid);
    emit(state.copyWith(status: SessionStatus.loaded));

    return response;
  }

  changedSelectedLesson(LessonModel value) {
    emit(state.copyWith(selectedLesson: value));
  }

  Future<bool> createSession(String _selectedDate, String _selectedTime,
      LessonModel _selectedLesson) async {
    try {
      emit(state.copyWith(status: SessionStatus.loading));
      await _sessionRepository.createSession(
          userID: _authRepository.currentUser?.uid,
          selectedDate: _selectedDate,
          selectedTime: _selectedTime,
          selectedLesson: _selectedLesson);
      emit(state.copyWith(status: SessionStatus.loaded));
      return Future.value(true);
    } on Failure catch (err) {
      emit(state.copyWith(status: SessionStatus.error, failure: err));
      return Future.value(false);
    }
  }

  Future<bool> updateSession(
      {required String selectedDate,
      required String selectedTime,
      required SessionModel oldSession,
      required LessonModel selectedLesson}) async {
    try {
      emit(state.copyWith(status: SessionStatus.loading));
      await _sessionRepository.updateSession(
        userID: _authRepository.currentUser?.uid,
        oldSession: oldSession,
        selectedDate: selectedDate,
        selectedTime: selectedTime,
        selectedLesson: selectedLesson,
      );
      emit(state.copyWith(status: SessionStatus.loaded));
      return Future.value(true);
    } on Failure catch (err) {
      emit(state.copyWith(status: SessionStatus.error, failure: err));
      return Future.value(false);
    }
  }

  Future<void> deleteSession(SessionModel session) async {
    UserModel? user = await _authRepository.currentUserModel;
    try {
      await _sessionRepository.deleteSession(
        user: user!,
        session: session,
      );
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: SessionStatus.error));
    }
  }
}
