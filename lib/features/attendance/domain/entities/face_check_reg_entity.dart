import 'package:equatable/equatable.dart';

/// Domain entity representing face biometric registration status of an employee.
class FaceCheckRegEntity extends Equatable {
  const new({
    required this.isSuccess,
    required this.isRegistered,
    required this.count,
    required this.message,
  });

  final bool isSuccess;
  final bool isRegistered;
  final int count;
  final String message;

  @override
  List<Object?> get props => [isSuccess, isRegistered, count, message];
}
