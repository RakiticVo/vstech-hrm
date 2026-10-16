import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/account_timesheet_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';

/// UseCase fetching authenticated employee's monthly timesheet from GET /api/Account/timesheet.
class GetAccountTimesheetUseCase {
  const new({required this.repository});

  final AttendanceRepository repository;

  Future<Either<Failure, List<AccountTimesheetEntity>>> call({
    required String monthYear,
  }) {
    return repository.getAccountTimesheet(monthYear: monthYear);
  }
}
