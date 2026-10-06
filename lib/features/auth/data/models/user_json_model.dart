import 'package:equatable/equatable.dart';

/// DTO mapping to UserJson from OpenAPI 3.0.1 (docs/api/api-1.json).
class UserJsonModel extends Equatable {
  const new({
    required this.id,
    required this.userName,
    required this.employeeName,
    required this.employeeCode,
    this.userCode,
    this.email,
    this.avatar,
    this.claims = const <String>[],
    this.allowFaceRegisterTo,
    this.isFaceRegistered,
    this.allowFaceEnroll,
  });

  factory fromJson(Map<String, dynamic> json) {
    return UserJsonModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      userName: json['userName']?.toString() ?? '',
      employeeName: json['employeeName']?.toString() ?? '',
      employeeCode: json['employeeCode']?.toString() ?? '',
      userCode: json['userCode']?.toString(),
      email: json['email']?.toString(),
      avatar: json['avatar']?.toString(),
      claims: (json['claims'] as List<dynamic>?)
              ?.map((dynamic e) => e.toString())
              .toList() ??
          const <String>[],
      allowFaceRegisterTo: json['allowFaceRegisterTo']?.toString(),
      isFaceRegistered: json['isFaceRegistered'] as bool?,
      allowFaceEnroll: json['allowFaceEnroll'] as bool?,
    );
  }

  final int id;
  final String userName;
  final String employeeName;
  final String employeeCode;
  final String? userCode;
  final String? email;
  final String? avatar;
  final List<String> claims;
  final String? allowFaceRegisterTo;
  final bool? isFaceRegistered;
  final bool? allowFaceEnroll;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userName': userName,
        'employeeName': employeeName,
        'employeeCode': employeeCode,
        'userCode': userCode,
        'email': email,
        'avatar': avatar,
        'claims': claims,
        'allowFaceRegisterTo': allowFaceRegisterTo,
        'isFaceRegistered': isFaceRegistered,
        'allowFaceEnroll': allowFaceEnroll,
      };

  @override
  List<Object?> get props => [
        id,
        userName,
        employeeName,
        employeeCode,
        userCode,
        email,
        avatar,
        claims,
        allowFaceRegisterTo,
        isFaceRegistered,
        allowFaceEnroll,
      ];
}
