import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/department_shift_day_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/repositories/schedule_repository.dart';

/// UseCase to fetch assigned shift schedules for subordinates in department
/// (GET /api/ShiftSchedules).
class GetDepartmentShiftScheduleUseCase {
  const new(this._repository);

  final ScheduleRepository _repository;

  Future<Either<Failure, List<DepartmentShiftDayEntity>>> call({
    required String from,
    required String to,
    String? departmentCode,
  }) {
    return _repository.getDepartmentShiftSchedule(
      from: from,
      to: to,
      departmentCode: departmentCode,
    );
  }
}
