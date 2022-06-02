part of 'auth_cubit.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, adminAuthenticated }

@immutable
class AuthState extends Equatable {
  final User? user;
  final AuthStatus status;

  const AuthState({required this.user, required this.status});

  factory AuthState.initial() {
    return const AuthState(
      user: null,
      status: AuthStatus.unknown,
    );
  }

  AuthState copyWith({
    User? user,
    AuthStatus? status,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [user, status];
}
