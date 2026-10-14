import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/managed_employee_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/repositories/approvals_repository.dart';

/// UseCase fetching subordinate employees within the manager's scope
/// (GET /api/TimeSheets/mobile-employees).
class GetManagedEmployeesUseCase {
  const new(this._repository);

  final ApprovalsRepository _repository;

  Future<Either<Failure, List<ManagedEmployeeEntity>>> call({
    String? from,
    String? to,
  }) {
    return _repository.getManagedEmployees(from: from, to: to);
  }
}
