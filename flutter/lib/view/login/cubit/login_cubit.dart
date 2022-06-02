import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:online_yoklama/core/extension/init/models/failure.dart';
import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/admin/attendance/model/attendance_model.dart';
import 'package:online_yoklama/view/auth/repository/auth_repository.dart';
import 'package:online_yoklama/view/auth/services/firebase_auth_services.dart';
import 'package:online_yoklama/view/login/repository/login_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _loginRepository = locator<LoginRepository>();
  final FirebaseAuthServices _firebaseAuthServices =
      locator<FirebaseAuthServices>();
  LoginCubit() : super(LoginState.initial());

  Future<bool> loginWithEmailAndPassword() async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final User? user = await _loginRepository.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );

      final UserModel? userModel =
          await _firebaseAuthServices.getCurrentUserModel(userID: user?.uid);

      if (user != null) {
        emit(state.copyWith(
            userID: user.uid,
            email: userModel?.email,
            schoolNumber: userModel?.schoolNumber,
            fullName: userModel?.fullName,
            status: LoginStatus.loaded));
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } on Failure catch (err) {
      emit(
        state.copyWith(status: LoginStatus.error, failure: err),
      );
      return Future.value(false);
    }
  }

  void createUserWithEmailandPassword() async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final User? user = await _loginRepository.createUserWithEmailandPassword(
        email: state.email,
        fullName: state.fullName,
        schoolNumber: state.schoolNumber,
        password: state.password,
      );

      final UserModel? userModel =
          await _firebaseAuthServices.getCurrentUserModel(userID: user?.uid);

      if (user != null) {
        emit(state.copyWith(
            userID: user.uid,
            email: userModel?.email,
            schoolNumber: userModel?.schoolNumber,
            fullName: userModel?.fullName,
            status: LoginStatus.loaded));
      }
    } on Failure catch (err) {
      emit(
        state.copyWith(status: LoginStatus.error, failure: err),
      );
    }
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: LoginStatus.initial));
  }

  void fullNameChanged(String value) {
    emit(state.copyWith(fullName: value, status: LoginStatus.initial));
  }

  void schoolNumberChanged(String value) {
    emit(state.copyWith(schoolNumber: value, status: LoginStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: LoginStatus.initial));
  }
}
