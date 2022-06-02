import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/view/admin/lesson/model/lesson_model.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';

abstract class AdminSessionBase {
  Future<void> createSession(
      {required String userID,
      required String selectedDate,
      required String selectedTime,
      required LessonModel selectedLesson});
  Future<void> updateSession(
      {required String userID,
      required String selectedDate,
      required String selectedTime,
      required SessionModel oldSession,
      required LessonModel selectedLesson});
  Future<void> deleteSession({
    required UserModel user,
    required SessionModel session,
  });
  Stream<List<SessionModel>> getSessionList({required String userID});
  Stream<List<SessionModel>> getLastSession({required String userID});
}
