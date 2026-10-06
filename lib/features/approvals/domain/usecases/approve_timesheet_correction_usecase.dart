import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/approval_result_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/repositories/approvals_repository.dart';

class ApproveTimesheetCorrectionUseCase {
  const new(this._repository);

  final ApprovalsRepository _repository;

  Future<Either<Failure, ApprovalResultEntity>> call(
    int id, {
    double? confirmedWorktime,
    String? note,
  }) {
    return _repository.approveTimesheetCorrection(
      id,
      confirmedWorktime: confirmedWorktime,
      note: note,
    );
  }
}
