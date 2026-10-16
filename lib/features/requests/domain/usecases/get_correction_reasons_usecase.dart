import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';
import 'package:vstech_hrm/features/requests/domain/repositories/requests_repository.dart';

/// UseCase fetching reasons for timesheet correction.
class GetCorrectionReasonsUseCase {
  const new(this._repository);

  final RequestsRepository _repository;

  Future<Either<Failure, List<CorrectionReasonEntity>>> call() {
    return _repository.getCorrectionReasons();
  }
}
