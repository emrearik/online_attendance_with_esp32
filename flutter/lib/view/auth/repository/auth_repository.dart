import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_yoklama/core/constants/app_mode.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/auth/services/firebase_auth_services.dart';

class AuthRepository {
  final FirebaseAuthServices _firebaseAuthServices =
      locator<FirebaseAuthServices>();

  User? get currentUser {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return _firebaseAuthServices.currentUser;
    } else {
      return _firebaseAuthServices.currentUser;
    }
  }

  Future<UserModel?> get currentUserModel async {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return await _firebaseAuthServices.currentUserModel;
    } else {
      return await _firebaseAuthServices.currentUserModel;
    }
  }

  Future<void> signOut() async {
    if (AppMode.appMode == AppStatus.DEBUG) {
      await _firebaseAuthServices.signOut();
    } else {
      await _firebaseAuthServices.signOut();
    }
  }

  Future<bool> getPermission(User? user) async {
    if (AppMode.appMode == AppStatus.DEBUG) {
      return await _firebaseAuthServices.getPermission(user);
    } else {
      return await _firebaseAuthServices.getPermission(user);
    }
  }
}
