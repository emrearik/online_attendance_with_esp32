part of 'adminhome_cubit.dart';

enum AdminHomeStatus { initial, loading, loaded, error }

@immutable
class AdminHomeState extends Equatable {
  final UserModel user;
  final AdminHomeStatus status;
  final Failure failure;

  const AdminHomeState(
      {required this.user, required this.status, required this.failure});

  factory AdminHomeState.initial() {
    return const AdminHomeState(
        user: UserModel(
            email: '',
            userID: '',
            fullName: '',
            permission: 0,
            schoolNumber: ''),
        status: AdminHomeStatus.initial,
        failure: Failure());
  }

  @override
  List<Object?> get props => [user, status, failure];

  AdminHomeState copyWith({
    UserModel? user,
    AdminHomeStatus? status,
    Failure? failure,
  }) {
    return AdminHomeState(
      user: user ?? this.user,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
