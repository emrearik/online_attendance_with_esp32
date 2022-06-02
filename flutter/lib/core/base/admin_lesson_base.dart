import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/view/admin/lesson/model/lesson_model.dart';

abstract class AdminLessonBase {
  Future<void> addLesson(
      {required UserModel user,
      required String lessonCode,
      required String lessonName});

  Future<void> updateLesson(
      {required UserModel user,
      required LessonModel oldLesson,
      required String lessonCode,
      required String lessonName});

  Stream<List<LessonModel>> getLessonList({required String userID});

  Future<void> deleteLesson(
      {required UserModel user, required LessonModel lesson});
}
