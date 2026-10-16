import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/requests/domain/entities/valid_leave_plan_entity.dart';
import 'package:vstech_hrm/features/requests/domain/repositories/requests_repository.dart';

/// UseCase fetching available leave plans with balances from GET /api/LeavePlans/valid-leave-plan2.
class GetValidLeavePlansUseCase {
  const new(this._repository);

  final RequestsRepository _repository;

  Future<Either<Failure, List<ValidLeavePlanEntity>>> call({
    String? execDate,
    String? customEmployeeCode,
    int all = 0,
  }) {
    return _repository.getValidLeavePlans(
      execDate: execDate,
      customEmployeeCode: customEmployeeCode,
      all: all,
    );
  }
}
