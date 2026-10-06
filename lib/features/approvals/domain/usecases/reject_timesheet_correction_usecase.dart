import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/approval_result_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/repositories/approvals_repository.dart';

class RejectTimesheetCorrectionUseCase {
  const new(this._repository);

  final ApprovalsRepository _repository;

  Future<Either<Failure, ApprovalResultEntity>> call(int id, {String? note}) {
    return _repository.rejectTimesheetCorrection(id, note: note);
  }
}
