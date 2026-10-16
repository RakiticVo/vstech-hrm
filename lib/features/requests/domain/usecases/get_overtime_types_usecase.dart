import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_type_entity.dart';
import 'package:vstech_hrm/features/requests/domain/repositories/requests_repository.dart';

/// UseCase to fetch available overtime types (loại tăng ca).
class GetOvertimeTypesUseCase {
  const new(this._repository);

  final RequestsRepository _repository;

  Future<Either<Failure, List<OvertimeTypeEntity>>> call() {
    return _repository.getOvertimeTypes();
  }
}
