import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/approvals/data/datasources/approvals_remote_datasource.dart';
import 'package:vstech_hrm/features/approvals/data/models/approval_models.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/approval_result_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/repositories/approvals_repository.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';

class ApprovalsRepositoryImpl implements ApprovalsRepository {
  const new({required ApprovalsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final ApprovalsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, ApprovalResultEntity>> approveLeave(String id) async {
    try {
      final res = await _remoteDataSource.approveLeave(id);
      return Right(ApprovalResultEntity(success: true, message: res.message));
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApprovalResultEntity>> rejectLeave(String id) async {
    try {
      final res = await _remoteDataSource.rejectLeave(id);
      return Right(ApprovalResultEntity(success: true, message: res.message));
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApprovalResultEntity>> approveOvertime(String id) async {
    try {
      final res = await _remoteDataSource.approveOvertime(id);
      return Right(ApprovalResultEntity(success: true, message: res.message));
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApprovalResultEntity>> rejectOvertime(String id) async {
    try {
      final res = await _remoteDataSource.rejectOvertime(id);
      return Right(ApprovalResultEntity(success: true, message: res.message));
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApprovalResultEntity>> approveBusinessTrip(String id) async {
    try {
      final res = await _remoteDataSource.approveBusinessTrip(id);
      return Right(ApprovalResultEntity(success: true, message: res.message));
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> rejectBusinessTrip(String id) async {
    try {
      final res = await _remoteDataSource.rejectBusinessTrip(id);
      return Right(res);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApprovalResultEntity>> approveTimesheetCorrection(
    int id, {
    double? confirmedWorktime,
    String? note,
  }) async {
    try {
      final command = TimesheetConfirmApproveCommand(
        confirmedWorktime: confirmedWorktime,
        confirmNote: note,
      );
      final res = await _remoteDataSource.approveTimesheetCorrection(id, command);
      return Right(ApprovalResultEntity(success: true, message: res.message));
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApprovalResultEntity>> rejectTimesheetCorrection(
    int id, {
    String? note,
  }) async {
    try {
      final res = await _remoteDataSource.rejectTimesheetCorrection(id, note: note);
      return Right(ApprovalResultEntity(success: true, message: res.message));
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CorrectionItemEntity>>> getPendingTimesheetApprovals({
    String? month,
  }) async {
    try {
      final models = await _remoteDataSource.getPendingTimesheetCorrections(month: month);
      final entities = models.map((m) => CorrectionItemEntity(
            id: m.id,
            employeeCode: m.employeeCode,
            workDate: m.workDate,
            worktime: m.worktime,
            reasonTypeName: m.reasonTypeName,
            note: m.note,
            isReject: m.isReject,
            confirmLevel: m.confirmLevel,
          )).toList();
      return Right(entities);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
