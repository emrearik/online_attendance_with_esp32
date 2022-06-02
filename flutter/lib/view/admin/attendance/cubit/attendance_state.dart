part of 'attendance_cubit.dart';

enum AttendanceStatus { initial, loading, loaded, error }

@immutable
class AttendanceState extends Equatable {
  final String studentID;
  final String sessionID;
  final AttendanceStatus status;
  final Failure failure;

  const AttendanceState({
    required this.studentID,
    required this.sessionID,
    required this.status,
    required this.failure,
  });

  factory AttendanceState.initial() {
    return const AttendanceState(
        studentID: '',
        sessionID: '',
        status: AttendanceStatus.initial,
        failure: Failure());
  }

  @override
  List<Object?> get props => [studentID, sessionID, status, failure];

  AttendanceState copyWith({
    String? studentID,
    String? sessionID,
    AttendanceStatus? status,
    Failure? failure,
  }) {
    return AttendanceState(
      studentID: studentID ?? this.studentID,
      sessionID: sessionID ?? this.sessionID,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
