import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/core/network/api_error_handler.dart';
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
import 'package:vstech_hrm/features/requests/domain/entities/valid_leave_plan_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/valid_max_hour_entity.dart';
import 'package:vstech_hrm/features/requests/domain/repositories/requests_repository.dart';

/// Implementation of RequestsRepository connecting to remote data source.
class RequestsRepositoryImpl implements RequestsRepository {
  const new({required this._remoteDataSource});

  final RequestsRemoteDataSource _remoteDataSource;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Object catch (e) {
      return Left(ServerFailure(message: ApiErrorHandler.extractErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, List<LeaveItemEntity>>> getLeaveRequests({String? from, String? to}) => _guard(() async {
        final models = await _remoteDataSource.getLeaveRequests(from: from, to: to);
        return models.map((m) => LeaveItemEntity(
              code: m.code,
              leavePlan: m.leavePlan,
              statusText: m.statusText,
              status: m.status,
              from: m.from,
              to: m.to,
              validFrom: m.validFrom,
              validTo: m.validTo,
              note: m.note,
              confirmBy: m.confirmBy,
              halfShiftType: m.halfShiftType,
            )).toList();
      });

  @override
  Future<Either<Failure, List<LeavePlanEntity>>> getLeavePlans() => _guard(() async {
        final models = await _remoteDataSource.getLeavePlans();
        return models.map((m) => LeavePlanEntity(
              code: m.code,
              name: m.name,
              symbol: m.symbol,
              amount: m.amount,
              validFrom: m.validFrom,
              validTo: m.validTo,
            )).toList();
      });

  @override
  Future<Either<Failure, List<ValidLeavePlanEntity>>> getValidLeavePlans({
    String? execDate,
    String? customEmployeeCode,
    int all = 0,
  }) => _guard(() async {
        final models = await _remoteDataSource.getValidLeavePlans(
          execDate: execDate,
          customEmployeeCode: customEmployeeCode,
          all: all,
        );
        return models.map((m) => m.toEntity()).toList();
      });

  @override
  Future<Either<Failure, bool>> createLeaveRequest(CreateLeaveParams params) => _guard(() async {
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
        return await _remoteDataSource.createLeaveRequest(command);
      });

  @override
  Future<Either<Failure, bool>> cancelLeaveRequest(String id) => _guard(() => _remoteDataSource.deleteLeaveRequest(id));

  @override
  Future<Either<Failure, List<OvertimeItemEntity>>> getOvertimeRequests({String? month, bool includeCreated = false}) => _guard(() async {
        final models = await _remoteDataSource.getOvertimeRequests(month: month, includeCreated: includeCreated);
        return models.map((m) => OvertimeItemEntity(
              code: m.code,
              statusText: m.statusText,
              status: m.status,
              isLock: m.isLock,
              employeeCode: m.employeeCode,
              employeeName: m.employeeName,
              createdByCode: m.createdByCode,
              createdByName: m.createdByName,
              shiftName: m.shiftName,
              date: m.date,
              timeRange: m.timeRange,
              length: m.length,
              overtimeTypeCode: m.overtimeTypeCode,
              overtimeTypeName: m.overtimeTypeName,
              overtimeReason: m.overtimeReason,
              note: m.note,
              confirmedBy: m.confirmedBy,
            )).toList();
      });

  @override
  Future<Either<Failure, List<OvertimeTypeEntity>>> getOvertimeTypes() => _guard(() async {
        final models = await _remoteDataSource.getOvertimeTypes();
        return models.map((m) => OvertimeTypeEntity(
              code: m.code,
              name: m.name,
              scale: m.scale,
            )).toList();
      });

  @override
  Future<Either<Failure, bool>> createOvertimeRequest(CreateOvertimeParams params) => _guard(() async {
        final command = OvertimeRequestCreateModel(
          employeeCode: params.employeeCode,
          adminEmployeeCode: params.adminEmployeeCode,
          accept: params.accept,
          date: params.date,
          length: params.length,
          overtimeTypeCode: params.overtimeTypeCode,
          startOvertime: params.startOvertime,
          endOvertime: params.endOvertime,
          note: params.note,
        );
        return await _remoteDataSource.createOvertimeRequest(command);
      });

  @override
  Future<Either<Failure, bool>> cancelOvertimeRequest(String id) =>
      _guard(() => _remoteDataSource.deleteOvertimeRequest(id));

  @override
  Future<Either<Failure, ValidMaxHourEntity>> getValidMaxHour({
    required String date,
    String? overtimeTypeCode,
    String? adminEmployee,
  }) => _guard(() async {
        final model = await _remoteDataSource.getValidMaxHour(
          date: date,
          overtimeTypeCode: overtimeTypeCode,
          adminEmployee: adminEmployee,
        );
        return model.toEntity();
      });

  @override
  Future<Either<Failure, List<CorrectionItemEntity>>> getCorrectionRequests({
    String? month,
    bool personal = true,
  }) => _guard(() async {
        final models = await _remoteDataSource.getCorrectionRequests(
          month: month,
          personal: personal,
        );
        return models.map((m) => CorrectionItemEntity(
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
              shiftCode: m.shiftCode,
              shiftName: m.shiftName,
              shiftStart: m.shiftStart,
              shiftEnd: m.shiftEnd,
            )).toList();
      });

  @override
  Future<Either<Failure, List<CorrectionReasonEntity>>> getCorrectionReasons() => _guard(() async {
        final models = await _remoteDataSource.getCorrectionReasons();
        return models.map((m) => CorrectionReasonEntity(
              code: m.code,
              name: m.name,
              mustHaveNote: m.mustHaveNote,
              mustHaveImage: m.mustHaveImage,
            )).toList();
      });

  @override
  Future<Either<Failure, bool>> createCorrectionRequest(CreateCorrectionParams params) => _guard(() async {
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
        return await _remoteDataSource.createCorrectionRequest(command);
      });
}
