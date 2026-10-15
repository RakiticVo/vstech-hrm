import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/core/network/api_error_handler.dart';
import 'package:vstech_hrm/features/approvals/data/datasources/approvals_remote_datasource.dart';
import 'package:vstech_hrm/features/approvals/data/models/approval_models.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/approval_result_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/managed_employee_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/timesheet_mobile_item_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/repositories/approvals_repository.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_item_entity.dart';

class ApprovalsRepositoryImpl implements ApprovalsRepository {
  const new({required this.remoteDataSource});

  final ApprovalsRemoteDataSource remoteDataSource;

  Future<Either<Failure, ApprovalResultEntity>> _handleAction(
    Future<ServiceResultResponseModel> Function() action,
  ) async {
    try {
      final res = await action();
      return Right(ApprovalResultEntity(success: true, message: res.message));
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: ApiErrorHandler.extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, ApprovalResultEntity>> approveLeave(String id) =>
      _handleAction(() => remoteDataSource.approveLeave(id));

  @override
  Future<Either<Failure, ApprovalResultEntity>> rejectLeave(String id) =>
      _handleAction(() => remoteDataSource.rejectLeave(id));

  @override
  Future<Either<Failure, ApprovalResultEntity>> approveOvertime(String id) =>
      _handleAction(() => remoteDataSource.approveOvertime(id));

  @override
  Future<Either<Failure, ApprovalResultEntity>> rejectOvertime(String id) =>
      _handleAction(() => remoteDataSource.rejectOvertime(id));

  @override
  Future<Either<Failure, ApprovalResultEntity>> approveBusinessTrip(String id) =>
      _handleAction(() => remoteDataSource.approveBusinessTrip(id));

  @override
  Future<Either<Failure, bool>> rejectBusinessTrip(String id) async {
    try {
      final res = await remoteDataSource.rejectBusinessTrip(id);
      return Right(res);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: ApiErrorHandler.extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, ApprovalResultEntity>> approveTimesheetCorrection(
    int id, {
    double? confirmedWorktime,
    String? note,
  }) =>
      _handleAction(() => remoteDataSource.approveTimesheetCorrection(
            id,
            TimesheetConfirmApproveCommand(
              confirmedWorktime: confirmedWorktime,
              confirmNote: note,
            ),
          ));

  @override
  Future<Either<Failure, ApprovalResultEntity>> rejectTimesheetCorrection(
    int id, {
    String? note,
  }) =>
      _handleAction(() => remoteDataSource.rejectTimesheetCorrection(id, note: note));

  @override
  Future<Either<Failure, List<CorrectionItemEntity>>> getPendingTimesheetApprovals({
    String? month,
  }) async {
    try {
      final models = await remoteDataSource.getPendingTimesheetCorrections(month: month);
      final entities = models.map((m) => CorrectionItemEntity(
            id: m.id,
            employeeCode: m.employeeCode,
            employeeName: m.employeeName,
            workDate: m.workDate,
            worktime: m.worktime,
            confirmedWorktime: m.confirmedWorktime,
            reasonTypeName: m.reasonTypeName,
            note: m.note,
            isReject: m.isReject,
            confirmLevel: m.confirmLevel,
            isLock: m.isLock,
            confirmerName: m.confirmerName,
          )).toList();
      return Right(entities);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: ApiErrorHandler.extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<LeaveItemEntity>>> getPendingLeaveApprovals({
    String? month,
  }) async {
    try {
      final models = await remoteDataSource.getPendingLeaveRequests(month: month);
      final entities = models.map((m) => LeaveItemEntity(
            code: m.code,
            leavePlan: m.leavePlan,
            statusText: m.statusText,
            status: m.status,
            employeeName: m.employeeName,
            employeeCode: m.employeeCode,
            from: m.from,
            to: m.to,
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
      return Left(ServerFailure(message: ApiErrorHandler.extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<OvertimeItemEntity>>> getPendingOvertimeApprovals({
    String? month,
  }) async {
    try {
      final models = await remoteDataSource.getPendingOvertimeRequests(month: month);
      final entities = models.map((m) => OvertimeItemEntity(
            code: m.code,
            statusText: m.statusText,
            status: m.status,
            isLock: m.isLock,
            employeeName: m.employeeName,
            employeeCode: m.employeeCode,
            date: m.date,
            timeRange: m.timeRange,
            length: m.length,
            overtimeTypeCode: m.overtimeTypeCode,
            overtimeTypeName: m.overtimeTypeName,
            overtimeReason: m.overtimeReason,
            note: m.note,
          )).toList();
      return Right(entities);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: ApiErrorHandler.extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<TimesheetMobileItemEntity>>> getTimeSheetsMobile({
    String? from,
    String? to,
  }) async {
    try {
      final models = await remoteDataSource.getTimeSheetsMobile(from: from, to: to);
      final entities = models.map((m) => TimesheetMobileItemEntity(
            code: m.code,
            employeeCode: m.employeeCode,
            employeeName: m.employee,
            department: m.department,
            actualWorkTime: m.actualWorkTime,
            validActualTime: m.validActualTime,
            overtime: m.overtime,
            leaveTime: m.leaveTime,
            shiftHour: m.shiftHour,
            staticSymbol: m.staticSymbol,
            isConfirmed: m.isConfirmed,
            isConfirmText: m.isConfirmText,
            workDate: m.workDate,
            workDateRaw: m.workDateRaw,
            note: m.note,
          )).toList();
      return Right(entities);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: ApiErrorHandler.extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<ManagedEmployeeEntity>>> getManagedEmployees({
    String? from,
    String? to,
  }) async {
    try {
      final models = await remoteDataSource.getManagedEmployees(from: from, to: to);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: ApiErrorHandler.extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, ApprovalResultEntity>> adminConfirmTimesheet({
    required String employeeCode,
    required String workDate,
    required double validActualTime,
    double overtime = 0.0,
    double validOvertime = 0.0,
  }) =>
      _handleAction(() => remoteDataSource.adminConfirmTimesheet(
            AdminConfirmTimesheetCommand(
              employeeCode: employeeCode,
              workDate: workDate,
              validActualTime: validActualTime,
              overtime: overtime,
              validOvertime: validOvertime,
            ),
          ));

  @override
  Future<Either<Failure, ApprovalResultEntity>> rejectTimesheet({
    required String employeeCode,
    required String workDate,
    required String reason,
  }) =>
      _handleAction(() => remoteDataSource.rejectTimesheet(
            RejectTimesheetCommand(
              employeeCode: employeeCode,
              workDate: workDate,
              reason: reason,
            ),
          ));
}
