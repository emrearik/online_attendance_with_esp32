part of 'login_cubit.dart';

enum LoginStatus { initial, loading, loaded, error }

@immutable
class LoginState extends Equatable {
  final String userID;
  final String email;
  final String password;
  final String fullName;
  final String schoolNumber;
  final LoginStatus status;
  final Failure? failure;

  const LoginState({
    required this.userID,
    required this.email,
    required this.password,
    required this.fullName,
    required this.schoolNumber,
    required this.status,
    required this.failure,
  });

  factory LoginState.initial() {
    return const LoginState(
        email: '',
        userID: '',
        password: '',
        fullName: '',
        schoolNumber: '',
        status: LoginStatus.initial,
        failure: Failure());
  }

  LoginState copyWith({
    String? email,
    String? password,
    String? userID,
    String? fullName,
    String? schoolNumber,
    LoginStatus? status,
    Failure? failure,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      userID: userID ?? this.userID,
      fullName: fullName ?? this.fullName,
      schoolNumber: schoolNumber ?? this.schoolNumber,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props =>
      [email, userID, password, fullName, schoolNumber, status, failure];
}
