import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/approvals/domain/repositories/approvals_repository.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_item_entity.dart';

class GetPendingLeaveApprovalsUseCase {
  const new(this._repository);

  final ApprovalsRepository _repository;

  Future<Either<Failure, List<LeaveItemEntity>>> call({String? month}) {
    return _repository.getPendingLeaveApprovals(month: month);
  }
}
