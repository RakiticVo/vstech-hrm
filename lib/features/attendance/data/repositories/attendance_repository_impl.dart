import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_today_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';

/// Implementation of AttendanceRepository translating Data layer exceptions to Domain Failures.
class AttendanceRepositoryImpl implements AttendanceRepository {
  const new({
    required this._remoteDataSource,
  });

  final AttendanceRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, AttendanceTodayEntity>> getTodayAttendance() async {
    try {
      final model = await _remoteDataSource.getTodayAttendance();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AttendanceRecordEntity>> checkIn(CheckInParams params) async {
    try {
      final model = await _remoteDataSource.checkIn(params);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AttendanceRecordEntity>> checkOut(CheckInParams params) async {
    try {
      final model = await _remoteDataSource.checkOut(params);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceRecordEntity>>> getAttendanceHistory({
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final models = await _remoteDataSource.getAttendanceHistory(from: from, to: to);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
