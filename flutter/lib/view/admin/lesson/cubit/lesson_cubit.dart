import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:online_yoklama/core/extension/init/models/failure.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/lesson/model/lesson_model.dart';
import 'package:online_yoklama/view/admin/lesson/repository/lesson_repository.dart';
import 'package:online_yoklama/view/auth/repository/auth_repository.dart';

part 'lesson_state.dart';

class LessonCubit extends Cubit<LessonState> {
  final AuthRepository _authRepository = locator<AuthRepository>();
  final LessonRepository _lessonRepository = locator<LessonRepository>();
  LessonCubit() : super(LessonState.initial());

  Future<bool> addLesson() async {
    UserModel? user = await _authRepository.currentUserModel;
    try {
      emit(state.copyWith(status: LessonStatus.loading));
      await _lessonRepository.addLesson(
        user: user!,
        lessonCode: state.lessonCode,
        lessonName: state.lessonName,
      );
      emit(state.copyWith(status: LessonStatus.loaded));
      return Future.value(true);
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LessonStatus.error));
      return Future.value(false);
    }
  }

  Stream<List<LessonModel>> get getLessonList {
    emit(state.copyWith(status: LessonStatus.loading));
    var response = _lessonRepository.getLessonList(
        userID: _authRepository.currentUser?.uid);
    emit(state.copyWith(status: LessonStatus.loaded));

    return response;
  }

  Future<void> deleteLesson(LessonModel lesson) async {
    UserModel? user = await _authRepository.currentUserModel;
    try {
      emit(state.copyWith(status: LessonStatus.loading));
      await _lessonRepository.deleteLesson(
        user: user!,
        lesson: lesson,
      );
      emit(state.copyWith(status: LessonStatus.loaded));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LessonStatus.error));
    }
  }

  Future<bool> updateLesson({
    required LessonModel oldLesson,
    required String lessonCode,
    required String lessonName,
  }) async {
    UserModel? user = await _authRepository.currentUserModel;
    try {
      emit(state.copyWith(status: LessonStatus.loading));
      await _lessonRepository.updateLesson(
        user: user!,
        oldLesson: oldLesson,
        lessonCode: lessonCode,
        lessonName: lessonName,
      );
      emit(state.copyWith(status: LessonStatus.loaded));
      return Future.value(true);
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LessonStatus.error));
      return Future.value(false);
    }
  }

  changedLessonCode(String value) {
    emit(state.copyWith(lessonCode: value, status: LessonStatus.initial));
  }

  changedLessonName(String value) {
    emit(state.copyWith(lessonName: value, status: LessonStatus.initial));
  }
}
