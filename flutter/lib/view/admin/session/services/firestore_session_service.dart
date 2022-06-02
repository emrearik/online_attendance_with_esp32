import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:online_yoklama/core/base/admin_session_base.dart';
import 'package:online_yoklama/core/constants/paths.dart';
import 'package:online_yoklama/core/extension/init/models/failure.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/lesson/model/lesson_model.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';

class FirestoreSessionService extends AdminSessionBase {
  final FirebaseFirestore _firebaseFirestore = locator<FirebaseFirestore>();

  @override
  Stream<List<SessionModel>> getSessionList({required String? userID}) {
    var response = _firebaseFirestore
        .collection(Paths.session)
        .where('selectedLesson.user.userID', isEqualTo: userID)
        .orderBy('createdDate', descending: true)
        .snapshots();

    return response.map((snapshot) {
      final result = snapshot.docs.map((e) {
        return SessionModel.fromMap(e.data());
      });
      return result.toList();
    });
  }

  Future<bool> checkExistSession(
      {required String? userID,
      required String selectedDate,
      required String selectedTime,
      required LessonModel selectedLesson}) async {
    var response = await _firebaseFirestore
        .collection(Paths.session)
        .where('selectedLesson.user.userID', isEqualTo: userID)
        .where('selectedLesson.lessonCode',
            isEqualTo: selectedLesson.lessonCode)
        .where('selectedTime', isEqualTo: selectedTime)
        .where('sessionDate', isEqualTo: selectedDate)
        .get();

    if (response.docs.isEmpty) {
      return Future.value(false);
    } else {
      debugPrint(response.docs[0].reference.id);
      return Future.value(true);
    }
  }

  Future<String> findSessionID({
    required String? sessionID,
  }) async {
    var response = await _firebaseFirestore
        .collection(Paths.session)
        .where('sessionID', isEqualTo: sessionID)
        .get();

    if (response.docs.isEmpty) {
      throw const Failure(
          code: 'Hata !', message: 'Bu kriterlerde bir oturum bulunamadı.');
    } else {
      return response.docs[0].reference.id;
    }
  }

  @override
  Future<void> createSession(
      {required String? userID,
      required String selectedDate,
      required String selectedTime,
      required LessonModel selectedLesson}) async {
    DocumentReference _documentReference =
        _firebaseFirestore.collection(Paths.session).doc();

    bool checkSession = await checkExistSession(
        userID: userID,
        selectedDate: selectedDate,
        selectedTime: selectedTime,
        selectedLesson: selectedLesson);

    if (checkSession == false) {
      await _documentReference.set({
        'sessionDate': selectedDate,
        'selectedTime': selectedTime,
        'selectedLesson': selectedLesson.toMap(),
        'createdDate': FieldValue.serverTimestamp(),
        'sessionID': _documentReference.id.substring(0, 6).toUpperCase()
      });
    } else {
      throw const Failure(
          code: 'Hata !',
          message:
              'Bu kriterlerde bir oturum zaten bulunuyor. Lütfen farklı bir oturum oluşturunuz.');
    }
  }

  @override
  Future<void> deleteSession(
      {required UserModel user, required SessionModel session}) async {
    await _firebaseFirestore
        .collection(Paths.session)
        .where('sessionID', isEqualTo: session.sessionID)
        .get()
        .then((value) => value.docs.forEach((element) {
              element.reference.delete();
            }));
  }

  @override
  Future<void> updateSession(
      {required String? userID,
      required String selectedDate,
      required String selectedTime,
      required SessionModel oldSession,
      required LessonModel selectedLesson}) async {
    bool checkSession = await checkExistSession(
        userID: userID,
        selectedDate: selectedDate,
        selectedTime: selectedTime,
        selectedLesson: selectedLesson);

    if (checkSession == false) {
      String? oldSessionID =
          await findSessionID(sessionID: oldSession.sessionID);
      _firebaseFirestore.collection(Paths.session).doc(oldSessionID).update({
        'sessionDate': selectedDate,
        'selectedTime': selectedTime,
        'selectedLesson': selectedLesson.toMap()
      });
    } else {
      throw const Failure(
          code: 'Hata !',
          message:
              'Bu kriterlerde bir oturum zaten bulunuyor. Lütfen farklı bir oturum oluşturunuz.');
    }
  }

  @override
  Stream<List<SessionModel>> getLastSession({required String? userID}) {
    var response = _firebaseFirestore
        .collection(Paths.session)
        .where('selectedLesson.user.userID', isEqualTo: userID)
        .orderBy('createdDate', descending: true)
        .limit(1)
        .snapshots();

    return response.map((snapshot) {
      final result = snapshot.docs.map((e) {
        return SessionModel.fromMap(e.data());
      });
      return result.toList();
    });
  }

  Future<SessionModel> getSession({required String sessionID}) async {
    var response = await _firebaseFirestore
        .collection(Paths.session)
        .where('sessionID', isEqualTo: sessionID)
        .get();
    return response.docs.map((e) => SessionModel.fromMap(e.data())).last;
  }

  String timestampToDate(double? timestamp) {
    return DateFormat("dd/MM/yyyy HH:mm:ss").format(
        DateTime.fromMillisecondsSinceEpoch(timestamp!.toInt() * 1000)
            .toLocal());
  }
}
