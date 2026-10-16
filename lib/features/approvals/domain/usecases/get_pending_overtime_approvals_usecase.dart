import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/approvals/domain/repositories/approvals_repository.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_item_entity.dart';

class GetPendingOvertimeApprovalsUseCase {
  const new(this._repository);

  final ApprovalsRepository _repository;

  Future<Either<Failure, List<OvertimeItemEntity>>> call({String? month}) {
    return _repository.getPendingOvertimeApprovals(month: month);
  }
}
