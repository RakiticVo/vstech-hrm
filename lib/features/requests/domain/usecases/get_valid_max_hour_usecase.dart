import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/requests/domain/entities/valid_max_hour_entity.dart';
import 'package:vstech_hrm/features/requests/domain/repositories/requests_repository.dart';

/// UseCase fetching maximum valid overtime hours and timesheet lock status.
class GetValidMaxHourUseCase {
  const new(this._repository);

  final RequestsRepository _repository;

  Future<Either<Failure, ValidMaxHourEntity>> call({
    required String date,
    String? overtimeTypeCode,
    String? adminEmployee,
  }) {
    return _repository.getValidMaxHour(
      date: date,
      overtimeTypeCode: overtimeTypeCode,
      adminEmployee: adminEmployee,
    );
  }
}
