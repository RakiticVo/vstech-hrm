import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_plan_entity.dart';
import 'package:vstech_hrm/features/requests/domain/repositories/requests_repository.dart';

/// UseCase to fetch available leave plans (loại nghỉ phép).
class GetLeavePlansUseCase {
  const new(this._repository);

  final RequestsRepository _repository;

  Future<Either<Failure, List<LeavePlanEntity>>> call() {
    return _repository.getLeavePlans();
  }
}
