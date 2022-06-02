import 'package:online_yoklama/core/base/admin_session_base.dart';
import 'package:online_yoklama/core/constants/app_mode.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/lesson/model/lesson_model.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';
import 'package:online_yoklama/view/admin/session/services/firestore_session_service.dart';

class SessionRepository extends AdminSessionBase {
  final FirestoreSessionService _firestoreSessionService =
      locator<FirestoreSessionService>();

  @override
  Future<void> createSession(
      {required String? userID,
      required String selectedDate,
      required String selectedTime,
      required LessonModel selectedLesson}) {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return _firestoreSessionService.createSession(
          userID: userID,
          selectedDate: selectedDate,
          selectedTime: selectedTime,
          selectedLesson: selectedLesson);
    } else {
      return _firestoreSessionService.createSession(
          userID: userID,
          selectedDate: selectedDate,
          selectedTime: selectedTime,
          selectedLesson: selectedLesson);
    }
  }

  @override
  Stream<List<SessionModel>> getSessionList({required String? userID}) {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return _firestoreSessionService.getSessionList(userID: userID);
    } else {
      return _firestoreSessionService.getSessionList(userID: userID);
    }
  }

  @override
  Stream<List<SessionModel>> getLastSession({required String? userID}) {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return _firestoreSessionService.getLastSession(userID: userID);
    } else {
      return _firestoreSessionService.getLastSession(userID: userID);
    }
  }

  @override
  Future<void> deleteSession(
      {required UserModel user, required SessionModel session}) {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return _firestoreSessionService.deleteSession(
          user: user, session: session);
    } else {
      return _firestoreSessionService.deleteSession(
          user: user, session: session);
    }
  }

  @override
  Future<void> updateSession(
      {required String? userID,
      required String selectedDate,
      required String selectedTime,
      required SessionModel oldSession,
      required LessonModel selectedLesson}) {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return _firestoreSessionService.updateSession(
          userID: userID,
          selectedDate: selectedDate,
          selectedTime: selectedTime,
          oldSession: oldSession,
          selectedLesson: selectedLesson);
    } else {
      return _firestoreSessionService.updateSession(
          userID: userID,
          selectedDate: selectedDate,
          selectedTime: selectedTime,
          oldSession: oldSession,
          selectedLesson: selectedLesson);
    }
  }
}
