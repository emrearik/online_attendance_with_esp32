import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:online_yoklama/view/admin/lesson/model/lesson_model.dart';

class SessionModel extends Equatable {
  final String sessionID;
  final LessonModel selectedLesson;
  final String sessionDate;
  final String selectedTime;

  final DateTime createdDate;

  const SessionModel({
    required this.sessionID,
    required this.selectedLesson,
    required this.sessionDate,
    required this.selectedTime,
    required this.createdDate,
  });

  SessionModel copyWith({
    String? sessionID,
    LessonModel? selectedLesson,
    String? sessionDate,
    String? selectedTime,
    DateTime? createdDate,
  }) {
    return SessionModel(
      sessionID: sessionID ?? this.sessionID,
      selectedLesson: selectedLesson ?? this.selectedLesson,
      sessionDate: sessionDate ?? this.sessionDate,
      selectedTime: selectedTime ?? this.selectedTime,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionID': sessionID,
      'selectedLesson': selectedLesson.toMap(),
      'selectedTime': selectedTime,
      'sessionDate': sessionDate,
      'createdDate': createdDate.millisecondsSinceEpoch,
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
        sessionID: map['sessionID'],
        selectedLesson: LessonModel.fromMap(map['selectedLesson']),
        sessionDate: map['sessionDate'],
        selectedTime: map['selectedTime'],
        createdDate: DateTime.parse(
          map['createdDate'].toDate().toString(),
        ));
  }

  String toJson() => json.encode(toMap());

  factory SessionModel.fromJson(String source) =>
      SessionModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'SessionModel(selectedLesson: $selectedLesson, sessionDate: $sessionDate, createdDate: $createdDate)';

  @override
  List<Object> get props =>
      [sessionID, selectedLesson, sessionDate, selectedTime, createdDate];
}
