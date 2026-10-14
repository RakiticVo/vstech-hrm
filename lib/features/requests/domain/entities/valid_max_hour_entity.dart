import 'package:equatable/equatable.dart';

/// Domain entity representing maximum valid overtime hours and timesheet lock status.
class ValidMaxHourEntity extends Equatable {
  const new({
    required this.maxHour,
    required this.isLock,
    this.message,
  });

  /// Maximum allowed overtime hours for the day (0 to 18).
  final double maxHour;

  /// true if the date falls in a locked timesheet period for employee's department.
  final bool isLock;

  /// Optional message from server if locked or restricted.
  final String? message;

  @override
  List<Object?> get props => [maxHour, isLock, message];
}
