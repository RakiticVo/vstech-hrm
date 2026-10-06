import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/repositories/requests_repository.dart';

/// UseCase fetching personal leave requests.
class GetLeaveRequestsUseCase {
  const new(this._repository);

  final RequestsRepository _repository;

  Future<Either<Failure, List<LeaveItemEntity>>> call() {
    return _repository.getLeaveRequests();
  }
}
