import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:online_yoklama/locator.dart';
import 'package:online_yoklama/view/auth/repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository = locator<AuthRepository>();

  AuthCubit() : super(AuthState.initial()) {
    attemptAutoLogin();
  }

  attemptAutoLogin() async {
    try {
      final user = await _authRepository.currentUser;
      if (user != null) {
        bool response = await _authRepository.getPermission(user);
        if (response) {
          emit(state.copyWith(
              user: user, status: AuthStatus.adminAuthenticated));
        } else {
          emit(state.copyWith(user: user, status: AuthStatus.authenticated));
        }
      } else {
        emit(state.copyWith(user: null, status: AuthStatus.unauthenticated));
      }
    } on Exception {
      emit(state.copyWith(user: null, status: AuthStatus.unauthenticated));
    }
  }

  void signOut() async {
    await _authRepository.signOut();
    emit(state.copyWith(user: null, status: AuthStatus.unauthenticated));
  }
}
