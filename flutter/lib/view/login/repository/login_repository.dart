import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_yoklama/core/base/auth_base.dart';
import 'package:online_yoklama/core/constants/app_mode.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/login/services/firestore_login_service.dart';

class LoginRepository extends AuthBase {
  final FirestoreLoginService _firestoreLoginService =
      locator<FirestoreLoginService>();

  @override
  Stream<User?> authStateChanges() {
    throw UnimplementedError();
  }

  @override
  Future<User?> createUserWithEmailandPassword({
    required String email,
    required String fullName,
    required String schoolNumber,
    required String password,
  }) async {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return await _firestoreLoginService.createUserWithEmailandPassword(
          email: email,
          fullName: fullName,
          schoolNumber: schoolNumber,
          password: password);
    } else {
      return await _firestoreLoginService.createUserWithEmailandPassword(
          email: email,
          fullName: fullName,
          schoolNumber: schoolNumber,
          password: password);
    }
  }

  @override
  User? get currentUser => throw UnimplementedError();

  @override
  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return await _firestoreLoginService.signInWithEmailAndPassword(
          email: email, password: password);
    } else {
      return await _firestoreLoginService.signInWithEmailAndPassword(
          email: email, password: password);
    }
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }
}
