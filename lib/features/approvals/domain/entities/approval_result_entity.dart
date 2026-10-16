import 'package:equatable/equatable.dart';

/// Pure domain entity representing action confirmation result from server.
class ApprovalResultEntity extends Equatable {
  const new({required this.success, this.message});

  final bool success;
  final String? message;

  @override
  List<Object?> get props => [success, message];
}
