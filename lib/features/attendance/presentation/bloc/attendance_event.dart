import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';

abstract class AttendanceEvent extends Equatable {
  const new();

  @override
  List<Object?> get props => [];
}

/// Event to load today's attendance status and shift information.
class LoadTodayAttendanceEvent extends AttendanceEvent {
  const new();
}

/// Event to prepare scan screen (check camera, GPS location, and Wi-Fi state).
class PrepareFaceScanEvent extends AttendanceEvent {
  const new({required this.type});

  final AttendanceType type;

  @override
  List<Object?> get props => [type];
}

/// Event to submit captured face photo along with GPS & Wi-Fi data.
class SubmitFaceScanEvent extends AttendanceEvent {
  const new({
    required this.imagePath,
    required this.type,
    this.note,
  });

  final String imagePath;
  final AttendanceType type;
  final String? note;

  @override
  List<Object?> get props => [imagePath, type, note];
}

/// Event to reset the scan state after successful punch or cancel.
class ResetAttendanceStateEvent extends AttendanceEvent {
  const new();
}
