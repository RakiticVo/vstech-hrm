import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/approval_result_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/repositories/approvals_repository.dart';

/// UseCase rejecting employee worktime via POST /api/TimeSheets/reject-timesheet.
class RejectTimesheetUseCase {
  const new(this._repository);

  final ApprovalsRepository _repository;

  Future<Either<Failure, ApprovalResultEntity>> call({
    required String employeeCode,
    required String workDate,
    required String reason,
  }) {
    if (reason.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: 'Vui lòng nhập lý do từ chối')),
      );
    }
    return _repository.rejectTimesheet(
      employeeCode: employeeCode,
      workDate: workDate,
      reason: reason.trim(),
    );
  }
}
