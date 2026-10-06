import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/requests/domain/repositories/requests_repository.dart';

/// UseCase revoking/canceling a leave request by ID.
class CancelLeaveRequestUseCase {
  const new(this._repository);

  final RequestsRepository _repository;

  Future<Either<Failure, bool>> call(String id) {
    return _repository.cancelLeaveRequest(id);
  }
}
