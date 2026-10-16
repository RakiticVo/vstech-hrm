import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/holidays/domain/entities/holiday_entity.dart';
import 'package:vstech_hrm/features/holidays/domain/repositories/holidays_repository.dart';

class GetHolidaysUseCase {
  const new(this._repository);

  final HolidaysRepository _repository;

  Future<Either<Failure, List<HolidayEntity>>> call() {
    return _repository.getHolidays();
  }
}
