import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:online_yoklama/view/admin/attendance/repository/attendance_repository.dart';
import 'package:online_yoklama/view/admin/attendance/services/firestore_attendance_services.dart';
import 'package:online_yoklama/view/admin/home/repository/admin_home_repository.dart';
import 'package:online_yoklama/view/admin/home/services/firestore_adminhome_service.dart';
import 'package:online_yoklama/view/admin/lesson/repository/lesson_repository.dart';
import 'package:online_yoklama/view/admin/lesson/services/firestore_lesson_service.dart';
import 'package:online_yoklama/view/admin/session/repository/session_repository.dart';
import 'package:online_yoklama/view/admin/session/services/firestore_session_service.dart';
import 'package:online_yoklama/view/auth/repository/auth_repository.dart';
import 'package:online_yoklama/view/auth/services/firebase_auth_services.dart';
import 'package:online_yoklama/view/login/repository/login_repository.dart';
import 'package:online_yoklama/view/login/services/firestore_login_service.dart';
import 'package:online_yoklama/view/student/repository/student_repository.dart';
import 'package:online_yoklama/view/student/services/firestore_student_services.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  //AUTH
  locator.registerLazySingleton(() => FirebaseAuthServices());
  locator.registerLazySingleton(() => AuthRepository());

  //LOGIN
  locator.registerLazySingleton(() => FirestoreLoginService());
  locator.registerLazySingleton(() => LoginRepository());

  //STUDENT
  locator.registerLazySingleton(() => FirestoreStudentServices());
  locator.registerLazySingleton(() => StudentRepository());

  //ADMIN ATTENDANCE
  locator.registerLazySingleton(() => FirestoreAttendanceServices());
  locator.registerLazySingleton(() => AttendanceRepository());

  //ADMIN HOME
  locator.registerLazySingleton(() => FirestoreAdminHomeService());
  locator.registerLazySingleton(() => AdminHomeRepository());

  //ADMIN LESSON
  locator.registerLazySingleton(() => FirestoreLessonService());
  locator.registerLazySingleton(() => LessonRepository());

  //ADMIN SESSION
  locator.registerLazySingleton(() => FirestoreSessionService());
  locator.registerLazySingleton(() => SessionRepository());

  locator.registerLazySingleton(() => FirebaseFirestore.instance);
}
