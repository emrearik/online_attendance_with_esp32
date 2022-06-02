import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class UserModel extends Equatable {
  final String userID;
  final String email;
  final String fullName;
  final int permission;
  final String schoolNumber;
  const UserModel({
    required this.userID,
    required this.email,
    required this.fullName,
    required this.permission,
    required this.schoolNumber,
  });

  @override
  List<Object> get props {
    return [
      userID,
      email,
      fullName,
      permission,
      schoolNumber,
    ];
  }

  UserModel copyWith({
    String? userID,
    String? email,
    String? fullName,
    int? permission,
    String? schoolNumber,
  }) {
    return UserModel(
      userID: userID ?? this.userID,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      permission: permission ?? this.permission,
      schoolNumber: schoolNumber ?? this.schoolNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'fullName': fullName,
      'permission': permission,
      'schoolNumber': schoolNumber,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic>? map) {
    return UserModel(
      userID: map?['userID'] ?? '',
      email: map?['email'] ?? '',
      fullName: map?['fullName'] ?? '',
      permission: map?['permission']?.toInt() ?? 0,
      schoolNumber: map?['schoolNumber'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(userID: $userID, email: $email, fullName: $fullName, permission: $permission, schoolNumber: $schoolNumber)';
  }
}
