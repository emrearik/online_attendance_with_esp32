import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:online_yoklama/core/base/auth_base.dart';
import 'package:online_yoklama/core/constants/paths.dart';
import 'package:online_yoklama/core/extension/init/models/failure.dart';
import 'package:online_yoklama/locator.dart';

class FirestoreLoginService implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = locator<FirebaseFirestore>();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = credential.user;
      return user;
    } on FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message);
    }
  }

  @override
  Future<User?> createUserWithEmailandPassword(
      {required String email,
      required String fullName,
      required String schoolNumber,
      required String password}) async {
    try {
      final user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final createdUser = user.user;

      _firebaseFirestore.collection(Paths.users).doc(createdUser!.uid).set({
        'userID': createdUser.uid,
        'email': email,
        'fullName': fullName,
        'schoolNumber': schoolNumber,
        'permission': 0,
      });

      return user.user;
    } on FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message);
    }
  }
}
