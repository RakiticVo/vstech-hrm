import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_today_entity.dart';

class CheckInParams extends Equatable {
  const new({
    required this.imagePath,
    required this.lat,
    required this.lng,
    required this.bssid,
    required this.capturedAt,
    this.note,
  });

  final String imagePath;
  final double lat;
  final double lng;
  final String bssid;
  final DateTime capturedAt;
  final String? note;

  @override
  List<Object?> get props => [imagePath, lat, lng, bssid, capturedAt, note];
}

/// Abstract contract for Attendance operations (Pure Dart domain).
abstract class AttendanceRepository {
  Future<Either<Failure, AttendanceTodayEntity>> getTodayAttendance();

  Future<Either<Failure, AttendanceRecordEntity>> checkIn(CheckInParams params);

  Future<Either<Failure, AttendanceRecordEntity>> checkOut(CheckInParams params);

  Future<Either<Failure, List<AttendanceRecordEntity>>> getAttendanceHistory({
    DateTime? from,
    DateTime? to,
  });
}
