import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/repositories/requests_repository.dart';

/// UseCase fetching personal overtime requests.
class GetOvertimeRequestsUseCase {
  const new(this._repository);

  final RequestsRepository _repository;

  Future<Either<Failure, List<OvertimeItemEntity>>> call({String? month, bool includeCreated = false}) {
    return _repository.getOvertimeRequests(month: month, includeCreated: includeCreated);
  }
}
