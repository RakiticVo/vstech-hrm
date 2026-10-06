import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/holidays/domain/entities/holiday_entity.dart';

abstract class HolidaysRepository {
  Future<Either<Failure, List<HolidayEntity>>> getHolidays();
}
