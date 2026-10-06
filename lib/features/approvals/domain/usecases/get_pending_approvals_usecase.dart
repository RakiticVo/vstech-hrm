import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/approvals/domain/repositories/approvals_repository.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';

class GetPendingApprovalsUseCase {
  const new(this._repository);

  final ApprovalsRepository _repository;

  Future<Either<Failure, List<CorrectionItemEntity>>> call({String? month}) {
    return _repository.getPendingTimesheetApprovals(month: month);
  }
}
