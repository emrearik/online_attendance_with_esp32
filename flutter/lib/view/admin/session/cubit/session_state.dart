part of 'session_cubit.dart';

enum SessionStatus { initial, loading, loaded, error }

@immutable
class SessionState extends Equatable {
  final DateTime sessionDate;
  final LessonModel selectedLesson;
  final SessionStatus status;
  final Failure failure;

  const SessionState({
    required this.sessionDate,
    required this.selectedLesson,
    required this.status,
    required this.failure,
  });

  factory SessionState.initial() {
    return SessionState(
        sessionDate: DateTime.now(),
        selectedLesson: const LessonModel(
            lessonCode: '',
            lessonName: '',
            user: UserModel(
                userID: '',
                email: '',
                fullName: '',
                permission: 0,
                schoolNumber: '')),
        status: SessionStatus.initial,
        failure: const Failure());
  }

  SessionState copyWith({
    DateTime? sessionDate,
    LessonModel? selectedLesson,
    SessionStatus? status,
    Failure? failure,
  }) {
    return SessionState(
      sessionDate: sessionDate ?? this.sessionDate,
      selectedLesson: selectedLesson ?? this.selectedLesson,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object> get props => [sessionDate, selectedLesson, status, failure];
}
