import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_yoklama/core/constants/paths.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';

class FirebaseAuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = locator<FirebaseFirestore>();
  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserModel?> get currentUserModel async =>
      await getCurrentUserModel(userID: _firebaseAuth.currentUser?.uid);

  Future<bool> getPermission(User? user) async {
    var response =
        await _firebaseFirestore.collection(Paths.users).doc(user!.uid).get();
    return response.data()!['permission'] == 0 ? false : true;
  }

  Future<UserModel?> getCurrentUserModel({required String? userID}) async {
    var response =
        await _firebaseFirestore.collection(Paths.users).doc(userID).get();
    return UserModel.fromMap(response.data());
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _firebaseAuth.authStateChanges();
  }
}
