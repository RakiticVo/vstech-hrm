import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/holidays/data/datasources/holidays_remote_datasource.dart';
import 'package:vstech_hrm/features/holidays/domain/entities/holiday_entity.dart';
import 'package:vstech_hrm/features/holidays/domain/repositories/holidays_repository.dart';

class HolidaysRepositoryImpl implements HolidaysRepository {
  const new({required HolidaysRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final HolidaysRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<HolidayEntity>>> getHolidays() async {
    try {
      final models = await _remoteDataSource.getHolidays();
      final entities = models.map((m) => HolidayEntity(
            code: m.code,
            name: m.name,
            date: m.date,
            symbol: m.symbol,
            isActive: m.isActive,
            scale: m.scale,
          )).toList();
      return Right(entities);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
