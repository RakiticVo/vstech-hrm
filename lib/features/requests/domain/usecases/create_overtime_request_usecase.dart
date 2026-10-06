import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';
import 'package:vstech_hrm/features/requests/domain/repositories/requests_repository.dart';

/// UseCase submitting a new overtime request.
class CreateOvertimeRequestUseCase {
  const new(this._repository);

  final RequestsRepository _repository;

  Future<Either<Failure, bool>> call(CreateOvertimeParams params) {
    return _repository.createOvertimeRequest(params);
  }
}
