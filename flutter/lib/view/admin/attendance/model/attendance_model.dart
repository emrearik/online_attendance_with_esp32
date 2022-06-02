// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:online_yoklama/core/extension/init/models/user_model.dart';
import 'package:online_yoklama/view/admin/session/models/session_model.dart';

class AttendanceModel {
  UserModel? student;
  SessionModel? session;
  double attendanceTime;

  AttendanceModel({
    this.student,
    this.session,
    required this.attendanceTime,
  });

  AttendanceModel copyWith({
    UserModel? student,
    SessionModel? session,
    double? attendanceTime,
  }) {
    return AttendanceModel(
      student: student ?? this.student,
      session: session ?? this.session,
      attendanceTime: attendanceTime ?? this.attendanceTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'student': student?.toMap(),
      'session': session?.toMap(),
      'attendanceTime': attendanceTime,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      student: map['student'] != null
          ? UserModel.fromMap(map['student'] as Map<String, dynamic>)
          : null,
      session: map['session'] != null
          ? SessionModel.fromMap(map['session'] as Map<String, dynamic>)
          : null,
      attendanceTime: map['attendanceTime'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceModel.fromJson(String source) =>
      AttendanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AttendanceModel(student: $student, session: $session, attendanceTime: $attendanceTime)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttendanceModel &&
        other.student == student &&
        other.session == session &&
        other.attendanceTime == attendanceTime;
  }

  @override
  int get hashCode =>
      student.hashCode ^ session.hashCode ^ attendanceTime.hashCode;
}
