import 'package:equatable/equatable.dart';

/// Domain entity representing successful authentication result.
class AuthResultEntity extends Equatable {
  const new({
    required this.token,
    required this.validTo,
    required this.employeeName,
    required this.employeeCode,
    required this.userName,
    this.userId,
    this.email,
    this.avatar,
    this.claims = const <String>[],
  });

  final String token;
  final String validTo;
  final String employeeName;
  final String employeeCode;
  final String userName;
  final int? userId;
  final String? email;
  final String? avatar;
  final List<String> claims;

  @override
  List<Object?> get props => [
        token,
        validTo,
        employeeName,
        employeeCode,
        userName,
        userId,
        email,
        avatar,
        claims,
      ];
}
