import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/repositories/requests_repository.dart';

/// UseCase fetching timesheet correction requests.
class GetCorrectionRequestsUseCase {
  const new(this._repository);

  final RequestsRepository _repository;

  Future<Either<Failure, List<CorrectionItemEntity>>> call({
    String? month,
    bool personal = true,
  }) {
    return _repository.getCorrectionRequests(month: month, personal: personal);
  }
}
