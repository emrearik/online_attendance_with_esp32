import 'package:online_yoklama/core/base/admin_lesson_base.dart';
import 'package:online_yoklama/core/constants/app_mode.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/lesson/model/lesson_model.dart';
import 'package:online_yoklama/view/admin/lesson/services/firestore_lesson_service.dart';

class LessonRepository extends AdminLessonBase {
  final FirestoreLessonService _firestoreLessonService =
      locator<FirestoreLessonService>();
  @override
  Future<void> addLesson(
      {required UserModel user,
      required String lessonCode,
      required String lessonName}) async {
    if (AppMode.appMode == AppStatus.DEBUG) {
      await _firestoreLessonService.addLesson(
          user: user, lessonCode: lessonCode, lessonName: lessonName);
    } else {
      await _firestoreLessonService.addLesson(
          user: user, lessonCode: lessonCode, lessonName: lessonName);
    }
  }

  @override
  Stream<List<LessonModel>> getLessonList({required String? userID}) {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return _firestoreLessonService.getLessonList(userID: userID);
    } else {
      return _firestoreLessonService.getLessonList(userID: userID);
    }
  }

  @override
  Future<void> updateLesson(
      {required UserModel user,
      required LessonModel oldLesson,
      required String lessonCode,
      required String lessonName}) async {
    if (AppMode.appMode == AppStatus.DEBUG) {
      await _firestoreLessonService.updateLesson(
          user: user,
          lessonCode: lessonCode,
          oldLesson: oldLesson,
          lessonName: lessonName);
    } else {
      await _firestoreLessonService.updateLesson(
          user: user,
          lessonCode: lessonCode,
          oldLesson: oldLesson,
          lessonName: lessonName);
    }
  }

  @override
  Future<void> deleteLesson(
      {required UserModel user, required LessonModel lesson}) {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return _firestoreLessonService.deleteLesson(user: user, lesson: lesson);
    } else {
      return _firestoreLessonService.deleteLesson(user: user, lesson: lesson);
    }
  }
}
