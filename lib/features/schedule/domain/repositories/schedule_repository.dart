import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/department_shift_day_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/my_shift_day_entity.dart';

/// Contract for schedule repository operations (OpenAPI Tag 14).
abstract class ScheduleRepository {
  /// Fetches personal shift schedules for the authenticated employee.
  Future<Either<Failure, List<MyShiftDayEntity>>> getMyShiftSchedule({
    required String from,
    required String to,
  });

  /// Fetches assigned shift schedules for subordinates in the department.
  Future<Either<Failure, List<DepartmentShiftDayEntity>>> getDepartmentShiftSchedule({
    required String from,
    required String to,
    String? departmentCode,
  });
}
