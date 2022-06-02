import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_yoklama/core/base/admin_lesson_base.dart';
import 'package:online_yoklama/core/constants/paths.dart';
import 'package:online_yoklama/core/extension/init/models/failure.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/lesson/model/lesson_model.dart';

class FirestoreLessonService extends AdminLessonBase {
  final FirebaseFirestore _firebaseFirestore = locator<FirebaseFirestore>();
  @override
  Future<void> addLesson(
      {required UserModel user,
      required String lessonCode,
      required String lessonName}) async {
    bool checkLesson = await checkExistsLesson(
      user: user,
      lessonCode: lessonCode,
      lessonName: lessonName,
    );

    if (checkLesson) {
      throw const Failure(
          code: 'Hata !',
          message: 'Bu ders kodu zaten kayıtlı. Farklı bir isim deneyiniz.');
    } else {
      await _firebaseFirestore.collection(Paths.lesson).doc().set({
        'user': user.toMap(),
        'lessonCode': lessonCode,
        'lessonName': lessonName,
      });
    }
  }

  @override
  Stream<List<LessonModel>> getLessonList({required String? userID}) {
    var response = _firebaseFirestore
        .collection(Paths.lesson)
        .where('user.userID', isEqualTo: userID)
        .snapshots();

    return response.map((snapshot) {
      final result = snapshot.docs.map((e) => LessonModel.fromMap(e.data()));
      return result.toList();
    });
  }

  @override
  Future<void> deleteLesson(
      {required UserModel user, required LessonModel lesson}) async {
    await _firebaseFirestore
        .collection(Paths.lesson)
        .where('user.userID', isEqualTo: user.userID)
        .where('lessonName', isEqualTo: lesson.lessonName)
        .where('lessonCode', isEqualTo: lesson.lessonCode)
        .get()
        .then(
          (value) => value.docs.forEach((element) {
            element.reference.delete();
          }),
        );
  }

  @override
  Future<void> updateLesson(
      {required UserModel user,
      required String lessonCode,
      required LessonModel oldLesson,
      required String lessonName}) async {
    bool checkLesson = await checkExistsLesson(
      user: user,
      lessonCode: lessonCode,
      lessonName: lessonName,
    );

    if (checkLesson) {
      throw const Failure(
        code: 'Hata !',
        message: 'Bu ders kodu zaten kayıtlı. Farklı bir isim deneyiniz.',
      );
    } else {
      var snapshot = await _firebaseFirestore
          .collection(Paths.lesson)
          .where('lessonCode', isEqualTo: oldLesson.lessonCode)
          .where('lessonName', isEqualTo: oldLesson.lessonName)
          .where('user.userID', isEqualTo: user.userID)
          .get();

      String documentID = snapshot.docs[0].reference.id;

      await _firebaseFirestore.collection(Paths.lesson).doc(documentID).update({
        'lessonCode': lessonCode,
        'lessonName': lessonName,
        'user': user.toMap(),
      });
    }
  }

  Future<bool> checkExistsLesson(
      {required UserModel user,
      required String lessonCode,
      required String lessonName}) async {
    var snapshot = await _firebaseFirestore
        .collection(Paths.lesson)
        .where('lessonCode', isEqualTo: lessonCode)
        .where('user.userID', isEqualTo: user.userID)
        .get();

    if (snapshot.docs.isEmpty) {
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
