import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final DateTime? createdAt;
  final DateTime? endDate;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? photo;
  final int? totalPoints;
  final int? streakCount;
  final String? type;
  final bool? isUserBlock;

  UserModel({
    this.createdAt,
    this.endDate,
    this.email,
    this.firstName,
    this.lastName,
    this.photo,
    this.totalPoints,
    this.streakCount,
    this.type,
    this.isUserBlock,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime? created;
    DateTime? end;

    final createdVal = json['createdAt'];
    final endVal = json['endDate'];

    if (createdVal is String) {
      created = DateTime.tryParse(createdVal);
    } else if (createdVal is Timestamp) {
      created = createdVal.toDate();
    }

    if (endVal is String) {
      end = DateTime.tryParse(endVal);
    } else if (endVal is Timestamp) {
      end = endVal.toDate();
    }

    int? points;
    final pointsVal = json['totalPoints'];
    if (pointsVal is int) {
      points = pointsVal;
    } else if (pointsVal is num) {
      points = pointsVal.toInt();
    } else if (pointsVal is String) {
      points = int.tryParse(pointsVal);
    }
    int? streakCount;
    final streakCountVal = json['streakCount'];
    if (streakCountVal is int) {
      streakCount = streakCountVal;
    } else if (streakCountVal is num) {
      streakCount = streakCountVal.toInt();
    } else if (streakCountVal is String) {
      streakCount = int.tryParse(streakCountVal);
    }
    return UserModel(
      createdAt: created,
      endDate: end,
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      type: json['type'] as String?,
      lastName: json['lastName'] as String?,
      photo: json['photo'] as String?,
      totalPoints: points,
      streakCount: streakCount,
      isUserBlock:  json['isUserBlock'],
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'photo': photo,
      'type': type,
      'totalPoints': totalPoints,
      'streakCount': streakCount,
      'isUserBlock': isUserBlock,
    };
  }
}
