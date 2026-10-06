import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_plan_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_type_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';

/// Pure domain repository contract for employee requests.
abstract class RequestsRepository {
  /// Fetches personal leave requests.
  Future<Either<Failure, List<LeaveItemEntity>>> getLeaveRequests();

  /// Fetches leave plans (categories of leave).
  Future<Either<Failure, List<LeavePlanEntity>>> getLeavePlans();

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
