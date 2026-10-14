import 'package:fpdart/fpdart.dart';
import 'package:vstech_hrm/core/errors/failures.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/approval_result_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/managed_employee_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/timesheet_mobile_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_item_entity.dart';

/// Pure domain contract for manager approvals.
abstract class ApprovalsRepository {
  Future<Either<Failure, ApprovalResultEntity>> approveLeave(String id);
  Future<Either<Failure, ApprovalResultEntity>> rejectLeave(String id);

  Future<Either<Failure, ApprovalResultEntity>> approveOvertime(String id);
  Future<Either<Failure, ApprovalResultEntity>> rejectOvertime(String id);

  Future<Either<Failure, ApprovalResultEntity>> approveBusinessTrip(String id);
  Future<Either<Failure, bool>> rejectBusinessTrip(String id);

  Future<Either<Failure, ApprovalResultEntity>> approveTimesheetCorrection(
    int id, {
    double? confirmedWorktime,
    String? note,
  });

  Future<Either<Failure, ApprovalResultEntity>> rejectTimesheetCorrection(
    int id, {
    String? note,
  });

  Future<Either<Failure, List<CorrectionItemEntity>>> getPendingTimesheetApprovals({
    String? month,
  });

  Future<Either<Failure, List<LeaveItemEntity>>> getPendingLeaveApprovals({
    String? month,
  });

  Future<Either<Failure, List<OvertimeItemEntity>>> getPendingOvertimeApprovals({
    String? month,
  });

  Future<Either<Failure, List<TimesheetMobileItemEntity>>> getTimeSheetsMobile({
    String? from,
    String? to,
  });

  Future<Either<Failure, List<ManagedEmployeeEntity>>> getManagedEmployees({
    String? from,
    String? to,
  });

  Future<Either<Failure, ApprovalResultEntity>> adminConfirmTimesheet({
    required String employeeCode,
    required String workDate,
    required double validActualTime,
    double overtime = 0.0,
    double validOvertime = 0.0,
  });

  Future<Either<Failure, ApprovalResultEntity>> rejectTimesheet({
    required String employeeCode,
    required String workDate,
    required String reason,
  });
}
