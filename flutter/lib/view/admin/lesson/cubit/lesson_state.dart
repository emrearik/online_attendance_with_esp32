part of 'lesson_cubit.dart';

enum LessonStatus { initial, loading, loaded, error }

@immutable
class LessonState extends Equatable {
  final String lessonCode;
  final String lessonName;
  final UserModel? user;
  final LessonStatus status;
  final Failure failure;

  const LessonState(
      {required this.lessonCode,
      required this.lessonName,
      required this.user,
      required this.status,
      required this.failure});

  factory LessonState.initial() {
    return const LessonState(
        lessonCode: '',
        lessonName: '',
        user: UserModel(
            userID: '',
            email: '',
            fullName: '',
            permission: 0,
            schoolNumber: ''),
        status: LessonStatus.initial,
        failure: Failure());
  }

  LessonState copyWith(
      {String? lessonCode,
      String? lessonName,
      UserModel? user,
      LessonStatus? status,
      Failure? failure}) {
    return LessonState(
        lessonCode: lessonCode ?? this.lessonCode,
        lessonName: lessonName ?? this.lessonName,
        user: user ?? this.user,
        status: status ?? this.status,
        failure: failure ?? this.failure);
  }

  @override
  List<Object?> get props => [lessonCode, lessonName, user, status, failure];
}
