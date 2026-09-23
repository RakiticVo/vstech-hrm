import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/labor_profile/domain/entities/labor_profile_entity.dart';
import 'package:vstech_hrm/features/labor_profile/domain/repositories/labor_profile_repository.dart';

/// UseCase to retrieve the authenticated employee's labor and contract information.
class GetLaborProfileUseCase {
  const new(this._repository);

  final LaborProfileRepository _repository;

  Future<Either<Failure, LaborProfileEntity>> call() {
    return _repository.getLaborProfile();
  }
}
