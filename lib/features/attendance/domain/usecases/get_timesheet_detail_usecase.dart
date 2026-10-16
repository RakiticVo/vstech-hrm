import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/timesheet_detail_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';

/// UseCase fetching detailed timesheet record for a given day or timesheet id.
class GetTimesheetDetailUseCase {
  const new(this._repository);

  final AttendanceRepository _repository;

  Future<Either<Failure, TimesheetDetailEntity?>> call(String id) {
    return _repository.getTimesheetDetail(id);
  }
}
