import 'package:vstech_hrm/features/approvals/data/models/approval_models.dart';
import 'package:vstech_hrm/features/approvals/data/models/managed_employee_model.dart';
import 'package:vstech_hrm/features/requests/data/models/leave_request_models.dart';
import 'package:vstech_hrm/features/requests/data/models/overtime_request_models.dart';
import 'package:vstech_hrm/features/requests/data/models/timesheet_confirm_models.dart';

export 'approvals_remote_datasource_impl.dart';

abstract class ApprovalsRemoteDataSource {
  Future<ServiceResultResponseModel> approveLeave(String id);
  Future<ServiceResultResponseModel> rejectLeave(String id);

  Future<ServiceResultResponseModel> approveOvertime(String id);
  Future<ServiceResultResponseModel> rejectOvertime(String id);

  Future<ServiceResultResponseModel> approveBusinessTrip(String id);
  Future<bool> rejectBusinessTrip(String id);

  Future<ServiceResultResponseModel> approveTimesheetCorrection(
    int id,
    TimesheetConfirmApproveCommand command,
  );
  Future<ServiceResultResponseModel> rejectTimesheetCorrection(int id, {String? note});

  Future<List<TimesheetCorrectionItemModel>> getPendingTimesheetCorrections({String? month});
  Future<List<LeaveRequestResponseItem>> getPendingLeaveRequests({String? month});
  Future<List<OvertimeRequestSelfItemModel>> getPendingOvertimeRequests({String? month});
  Future<List<TimesheetMobileItemModel>> getTimeSheetsMobile({String? from, String? to});
  Future<List<ManagedEmployeeModel>> getManagedEmployees({String? from, String? to});
  Future<ServiceResultResponseModel> adminConfirmTimesheet(AdminConfirmTimesheetCommand command);
  Future<ServiceResultResponseModel> rejectTimesheet(RejectTimesheetCommand command);
}
