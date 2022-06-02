import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  User? get currentUser;
  Future<void> signOut();
  Stream<User?> authStateChanges();
  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password});
  Future<User?> createUserWithEmailandPassword(
      {required String email,
      required String fullName,
      required String schoolNumber,
      required String password});
}
