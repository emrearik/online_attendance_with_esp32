part of 'student_cubit.dart';

enum StudentStatus { initial, loading, loaded, error }

class StudentState extends Equatable {
  final UserModel student;
  final Failure failure;
  final StudentStatus status;

  const StudentState(
      {required this.student, required this.failure, required this.status});

  factory StudentState.initial() {
    return const StudentState(
        student: UserModel(
            userID: '',
            email: '',
            fullName: '',
            permission: 0,
            schoolNumber: ''),
        failure: Failure(),
        status: StudentStatus.initial);
  }

  @override
  List<Object> get props => [student, failure, status];

  StudentState copyWith({
    UserModel? student,
    Failure? failure,
    StudentStatus? status,
  }) {
    return StudentState(
      student: student ?? this.student,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }
}
