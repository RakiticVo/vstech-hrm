import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_today_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';

/// UseCase fetching current day's attendance status and shift timing.
class GetTodayAttendanceUseCase {
  const new(this._repository);

  final AttendanceRepository _repository;

  Future<Either<Failure, AttendanceTodayEntity>> call() {
    return _repository.getTodayAttendance();
  }
}
