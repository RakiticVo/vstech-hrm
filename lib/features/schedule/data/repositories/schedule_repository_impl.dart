import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/schedule/data/datasources/schedule_remote_datasource.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/department_shift_day_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/my_shift_day_entity.dart';
import 'package:vstech_hrm/features/schedule/domain/repositories/schedule_repository.dart';

/// Implementation of ScheduleRepository using ScheduleRemoteDataSource.
class ScheduleRepositoryImpl implements ScheduleRepository {
  const new({required this.remoteDataSource});

  final ScheduleRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<MyShiftDayEntity>>> getMyShiftSchedule({
    required String from,
    required String to,
  }) async {
    try {
      final models = await remoteDataSource.getMyShiftSchedule(from: from, to: to);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DepartmentShiftDayEntity>>> getDepartmentShiftSchedule({
    required String from,
    required String to,
    String? departmentCode,
  }) async {
    try {
      final models = await remoteDataSource.getDepartmentShiftSchedule(
        departmentCode: departmentCode,
        from: from,
        to: to,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
