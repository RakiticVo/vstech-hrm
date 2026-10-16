import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';
import 'package:vstech_hrm/features/requests/domain/repositories/requests_repository.dart';

/// UseCase submitting a new timesheet correction request.
class CreateCorrectionRequestUseCase {
  const new(this._repository);

  final RequestsRepository _repository;

  Future<Either<Failure, bool>> call(CreateCorrectionParams params) {
    return _repository.createCorrectionRequest(params);
  }
}
