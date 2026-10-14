import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/core/network/api_error_handler.dart';
import 'package:vstech_hrm/features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/account_timesheet_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_today_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/timesheet_detail_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';

/// Implementation of AttendanceRepository translating Data layer exceptions to Domain Failures.
class AttendanceRepositoryImpl implements AttendanceRepository {
  const new({
    required this.remoteDataSource,
  });

  final AttendanceRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, AttendanceTodayEntity>> getTodayAttendance() async {
    try {
      final model = await remoteDataSource.getTodayAttendance();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: ApiErrorHandler.extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, String>> getAttendMode() async {
    try {
      final mode = await remoteDataSource.getAttendMode();
      return Right(mode);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: ApiErrorHandler.extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, AttendanceRecordEntity>> checkIn(CheckInParams params) async {
    try {
      final model = await remoteDataSource.checkIn(params);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: ApiErrorHandler.extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, AttendanceRecordEntity>> checkOut(CheckInParams params) async {
    try {
      final model = await remoteDataSource.checkOut(params);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: ApiErrorHandler.extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceRecordEntity>>> getAttendanceHistory({
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final models = await remoteDataSource.getAttendanceHistory(from: from, to: to);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: ApiErrorHandler.extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, TimesheetDetailEntity?>> getTimesheetDetail(String id) async {
    try {
      final model = await remoteDataSource.getTimesheetDetail(id);
      return Right(model?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: ApiErrorHandler.extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<AccountTimesheetEntity>>> getAccountTimesheet({
    required String monthYear,
  }) async {
    try {
      final models = await remoteDataSource.getAccountTimesheet(monthYear: monthYear);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Left(UnknownFailure(message: ApiErrorHandler.extractErrorMessage(e)));
    }
  }
}
