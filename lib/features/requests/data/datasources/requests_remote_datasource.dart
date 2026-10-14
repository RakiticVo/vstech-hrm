import 'package:vstech_hrm/features/requests/data/models/leave_request_models.dart';
import 'package:vstech_hrm/features/requests/data/models/overtime_request_models.dart';
import 'package:vstech_hrm/features/requests/data/models/timesheet_confirm_models.dart';
import 'package:vstech_hrm/features/requests/data/models/valid_leave_plan_model.dart';
import 'package:vstech_hrm/features/requests/data/models/valid_max_hour_model.dart';

export 'requests_remote_datasource_impl.dart';

abstract class RequestsRemoteDataSource {
  Future<List<LeaveRequestResponseItem>> getLeaveRequests({String? from, String? to});
  Future<List<LeavePlanModel>> getLeavePlans();
  Future<List<ValidLeavePlanModel>> getValidLeavePlans({String? execDate, String? customEmployeeCode, int all = 0});
  Future<bool> createLeaveRequest(LeaveRequestCreateCommand command);
  Future<bool> deleteLeaveRequest(String id);

  Future<List<OvertimeRequestSelfItemModel>> getOvertimeRequests({String? month});
  Future<List<OvertimeTypeModel>> getOvertimeTypes();
  Future<bool> createOvertimeRequest(OvertimeRequestCreateModel command);
  Future<bool> deleteOvertimeRequest(String id);
  Future<ValidMaxHourModel> getValidMaxHour({
    required String date,
    String? overtimeTypeCode,
    String? adminEmployee,
  });

  Future<List<TimesheetCorrectionItemModel>> getCorrectionRequests({String? month, bool personal = true});
  Future<List<CorrectionReasonTypeModel>> getCorrectionReasons();
  Future<bool> createCorrectionRequest(CreateTimesheetCorrectionCommand command);
}
