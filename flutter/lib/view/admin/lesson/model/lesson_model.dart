import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:online_yoklama/core/extension/init/models/user_model.dart';

@immutable
class LessonModel extends Equatable {
  final String lessonCode;
  final String lessonName;
  final UserModel user;
  const LessonModel({
    required this.lessonCode,
    required this.lessonName,
    required this.user,
  });

  LessonModel copyWith({
    String? lessonCode,
    String? lessonName,
    UserModel? user,
  }) {
    return LessonModel(
      lessonCode: lessonCode ?? this.lessonCode,
      lessonName: lessonName ?? this.lessonName,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lessonCode': lessonCode,
      'lessonName': lessonName,
      'user': user.toMap(),
    };
  }

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      lessonCode: map['lessonCode'] ?? '',
      lessonName: map['lessonName'] ?? '',
      user: UserModel.fromMap(map['user']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LessonModel.fromJson(String source) =>
      LessonModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'LessonModel(lessonCode: $lessonCode, lessonName: $lessonName, user: $user)';

  @override
  List<Object> get props => [lessonCode, lessonName, user];
}
