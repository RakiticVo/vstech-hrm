import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/requests/data/datasources/requests_remote_datasource.dart';
import 'package:vstech_hrm/features/requests/data/models/leave_request_models.dart';
import 'package:vstech_hrm/features/requests/data/models/overtime_request_models.dart';
import 'package:vstech_hrm/features/requests/data/models/timesheet_confirm_models.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_plan_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_type_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';
import 'package:vstech_hrm/features/requests/domain/repositories/requests_repository.dart';

/// Implementation of RequestsRepository connecting to remote data source.
class RequestsRepositoryImpl implements RequestsRepository {
  const new({required RequestsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final RequestsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<LeaveItemEntity>>> getLeaveRequests() async {
    try {
      final models = await _remoteDataSource.getLeaveRequests();
      final entities = models.map((m) => LeaveItemEntity(
            code: m.code,
            leavePlan: m.leavePlan,
            statusText: m.statusText,
            status: m.status,
            validFrom: m.validFrom,
            validTo: m.validTo,
            note: m.note,
            confirmBy: m.confirmBy,
            halfShiftType: m.halfShiftType,
          )).toList();
      return Right(entities);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LeavePlanEntity>>> getLeavePlans() async {
    try {
      final models = await _remoteDataSource.getLeavePlans();
      final entities = models
          .map((m) => LeavePlanEntity(
                code: m.code,
                name: m.name,
                symbol: m.symbol,
                amount: m.amount,
                validFrom: m.validFrom,
                validTo: m.validTo,
              ))
          .toList();
      return Right(entities);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createLeaveRequest(CreateLeaveParams params) async {
    try {
      final amountStr = params.leaveAmountType != null
          ? (params.leaveAmountType! % 1 == 0
              ? params.leaveAmountType!.toInt().toString()
              : params.leaveAmountType!.toString())
          : '1';
      final command = LeaveRequestCreateCommand(
        from: params.from,
        to: params.to,
        employeeCode: params.employeeCode,
        validFrom: params.validFrom,
        validTo: params.validTo,
        isMultiple: params.isMultiple,
        departmentCode: params.departmentCode,
        leavePlanCode: params.leavePlanCode,
        shiftCode: params.shiftCode,
        leaveAmountType: amountStr,
        halfShiftType: params.halfShiftType,
        note: params.note ?? '',
      );
      final result = await _remoteDataSource.createLeaveRequest(command);
      return Right(result);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelLeaveRequest(String id) async {
    try {
      final result = await _remoteDataSource.deleteLeaveRequest(id);
      return Right(result);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OvertimeItemEntity>>> getOvertimeRequests({String? month}) async {
    try {
      final models = await _remoteDataSource.getOvertimeRequests(month: month);
      final entities = models.map((m) => OvertimeItemEntity(
            code: m.code,
            statusText: m.statusText,
            status: m.status,
            isLock: m.isLock,
            date: m.date,
            timeRange: m.timeRange,
            length: m.length,
            overtimeReason: m.overtimeReason,
            note: m.note,
          )).toList();
      return Right(entities);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OvertimeTypeEntity>>> getOvertimeTypes() async {
    try {
      final models = await _remoteDataSource.getOvertimeTypes();
      final entities = models
          .map((m) => OvertimeTypeEntity(
                code: m.code,
                name: m.name,
                scale: m.scale,
              ))
          .toList();
      return Right(entities);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createOvertimeRequest(CreateOvertimeParams params) async {
    try {
      final command = OvertimeRequestCreateModel(
        employeeCode: params.employeeCode,
        date: params.date,
        length: params.length,
        overtimeTypeCode: params.overtimeTypeCode,
        startOvertime: params.startOvertime,
        endOvertime: params.endOvertime,
        note: params.note,
        overtimeReasonCode: params.overtimeReasonCode,
      );
      final result = await _remoteDataSource.createOvertimeRequest(command);
      return Right(result);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelOvertimeRequest(String id) async {
    try {
      final result = await _remoteDataSource.deleteOvertimeRequest(id);
      return Right(result);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CorrectionItemEntity>>> getCorrectionRequests({
    String? month,
    bool personal = true,
  }) async {
    try {
      final models = await _remoteDataSource.getCorrectionRequests(
        month: month,
        personal: personal,
      );
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

  @override
  Future<Either<Failure, List<CorrectionReasonEntity>>> getCorrectionReasons() async {
    try {
      final models = await _remoteDataSource.getCorrectionReasons();
      final entities = models.map((m) => CorrectionReasonEntity(
            code: m.code,
            name: m.name,
            mustHaveNote: m.mustHaveNote,
            mustHaveImage: m.mustHaveImage,
          )).toList();
      return Right(entities);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createCorrectionRequest(CreateCorrectionParams params) async {
    try {
      final command = CreateTimesheetCorrectionCommand(
        employeeCode: params.employeeCode,
        workDate: params.workDate,
        worktime: params.worktime,
        reasonTypeCode: params.reasonTypeCode,
        note: params.note,
        imageUrl: params.imageUrl,
        latitude: params.latitude,
        longitude: params.longitude,
        address: params.address,
      );
      final result = await _remoteDataSource.createCorrectionRequest(command);
      return Right(result);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
