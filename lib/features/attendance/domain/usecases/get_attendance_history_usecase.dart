import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';

/// UseCase fetching historical attendance logs for an employee.
class GetAttendanceHistoryUseCase {
  const new(this._repository);

  final AttendanceRepository _repository;

  Future<Either<Failure, List<AttendanceRecordEntity>>> call({
    DateTime? from,
    DateTime? to,
  }) {
    return _repository.getAttendanceHistory(from: from, to: to);
  }
}
