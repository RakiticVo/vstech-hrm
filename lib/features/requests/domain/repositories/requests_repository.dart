import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_plan_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_type_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';
import 'package:vstech_hrm/features/requests/domain/entities/valid_leave_plan_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/valid_max_hour_entity.dart';

/// Pure domain repository contract for employee requests.
abstract class RequestsRepository {
  /// Fetches personal leave requests for optional [from] and [to] dates.
  Future<Either<Failure, List<LeaveItemEntity>>> getLeaveRequests({String? from, String? to});

  /// Fetches leave plans (categories of leave).
  Future<Either<Failure, List<LeavePlanEntity>>> getLeavePlans();

  /// Fetches available leave plans with remaining days and validity period (GET /api/LeavePlans/valid-leave-plan2).
  Future<Either<Failure, List<ValidLeavePlanEntity>>> getValidLeavePlans({
    String? execDate,
    String? customEmployeeCode,
    int all = 0,
  });

  /// Submits a new leave request.
  Future<Either<Failure, bool>> createLeaveRequest(CreateLeaveParams params);

  /// Revokes an existing leave request by [id].
  Future<Either<Failure, bool>> cancelLeaveRequest(String id);

  /// Fetches personal overtime requests for optional [month] (yyyy-MM).
  Future<Either<Failure, List<OvertimeItemEntity>>> getOvertimeRequests({String? month});

  /// Fetches overtime types (e.g. weekday x1.5, weekend x2.0, holiday x3.0).
  Future<Either<Failure, List<OvertimeTypeEntity>>> getOvertimeTypes();

  /// Submits a new overtime request.
  Future<Either<Failure, bool>> createOvertimeRequest(CreateOvertimeParams params);

  /// Deletes/cancels an existing overtime request by [id].
  Future<Either<Failure, bool>> cancelOvertimeRequest(String id);

  /// Fetches valid max hours and lock status for overtime date (GET /api/OvertimeRequests/valid-max-hour).
  Future<Either<Failure, ValidMaxHourEntity>> getValidMaxHour({
    required String date,
    String? overtimeTypeCode,
    String? adminEmployee,
  });

  /// Fetches timesheet correction requests for optional [month] (yyyy-MM).
  Future<Either<Failure, List<CorrectionItemEntity>>> getCorrectionRequests({
    String? month,
    bool personal = true,
  });

  /// Fetches available reasons for timesheet correction.
  Future<Either<Failure, List<CorrectionReasonEntity>>> getCorrectionReasons();

  /// Submits a new timesheet correction request.
  Future<Either<Failure, bool>> createCorrectionRequest(CreateCorrectionParams params);
}
