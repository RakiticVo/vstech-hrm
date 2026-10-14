import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/approval_result_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/repositories/approvals_repository.dart';

/// UseCase confirming employee worktime via POST /api/TimeSheets/admin-confirm-timesheet.
class AdminConfirmTimesheetUseCase {
  const new(this._repository);

  final ApprovalsRepository _repository;

  Future<Either<Failure, ApprovalResultEntity>> call({
    required String employeeCode,
    required String workDate,
    required double validActualTime,
    double overtime = 0.0,
    double validOvertime = 0.0,
  }) {
    return _repository.adminConfirmTimesheet(
      employeeCode: employeeCode,
      workDate: workDate,
      validActualTime: validActualTime,
      overtime: overtime,
      validOvertime: validOvertime,
    );
  }
}
