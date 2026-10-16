import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/network/api_error_handler.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/approvals/data/datasources/approvals_remote_datasource.dart';
import 'package:vstech_hrm/features/approvals/data/models/approval_models.dart';
import 'package:vstech_hrm/features/approvals/data/models/managed_employee_model.dart';
import 'package:vstech_hrm/features/requests/data/models/leave_request_models.dart';
import 'package:vstech_hrm/features/requests/data/models/overtime_request_models.dart';
import 'package:vstech_hrm/features/requests/data/models/timesheet_confirm_models.dart';

class ApprovalsRemoteDataSourceImpl implements ApprovalsRemoteDataSource {
  const new({required this.dioClient});

  final DioClient dioClient;

  @override
  Future<ServiceResultResponseModel> approveLeave(String id) async {
    try {
      final response = await dioClient.get<dynamic>(ApiEndpoints.leaveAccept(id));
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi duyệt đơn nghỉ phép');
    }
  }

  @override
  Future<ServiceResultResponseModel> rejectLeave(String id) async {
    try {
      final response = await dioClient.get<dynamic>(ApiEndpoints.leaveDeny(id));
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi từ chối đơn nghỉ phép');
    }
  }

  @override
  Future<ServiceResultResponseModel> approveOvertime(String id) async {
    try {
      final response = await dioClient.get<dynamic>(ApiEndpoints.overtimeAccept(id));
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi duyệt đơn tăng ca');
    }
  }

  @override
  Future<ServiceResultResponseModel> rejectOvertime(String id) async {
    try {
      final response = await dioClient.get<dynamic>(ApiEndpoints.overtimeDeny(id));
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi từ chối đơn tăng ca');
    }
  }

  @override
  Future<ServiceResultResponseModel> approveBusinessTrip(String id) async {
    try {
      final response = await dioClient.get<dynamic>(ApiEndpoints.businessAccept(id));
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi duyệt đơn công tác');
    }
  }

  @override
  Future<bool> rejectBusinessTrip(String id) async {
    try {
      final response = await dioClient.get<dynamic>(ApiEndpoints.businessDeny(id));
      return response.statusCode == 200;
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi từ chối đơn công tác');
    }
  }

  @override
  Future<ServiceResultResponseModel> approveTimesheetCorrection(
    int id,
    TimesheetConfirmApproveCommand command,
  ) async {
    try {
      final response = await dioClient.post<dynamic>(
        ApiEndpoints.timesheetConfirmAccept(id),
        data: command.toJson(),
      );
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi duyệt phiếu giải trình');
    }
  }

  @override
  Future<ServiceResultResponseModel> rejectTimesheetCorrection(int id, {String? note}) async {
    try {
      final response = await dioClient.post<dynamic>(
        ApiEndpoints.timesheetConfirmReject(id),
        queryParameters: <String, dynamic>{
          if (note != null && note.isNotEmpty) 'note': note,
        },
      );
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi từ chối phiếu giải trình');
    }
  }

  String _normalizeMonth(String? month) {
    if (month != null && month.trim().isNotEmpty) {
      final trimmed = month.trim();
      if (trimmed.length == 7) {
        return '$trimmed-01';
      }
      return trimmed;
    }
    final now = DateTime.now();
    final m = now.month.toString().padLeft(2, '0');
    return '${now.year}-$m-01';
  }

  List<dynamic> _extractList(dynamic body) {
    if (body is Map<String, dynamic>) {
      if (body['items'] is List) return body['items'] as List;
      if (body['data'] is List) return body['data'] as List;
    }
    return body is List ? body : const [];
  }

  @override
  Future<List<TimesheetMobileItemModel>> getTimeSheetsMobile({String? from, String? to}) async {
    try {
      final response = await dioClient.get<dynamic>(
        ApiEndpoints.timesheetsMobile,
        queryParameters: <String, dynamic>{
          'from': ?from,
          'to': ?to,
        },
      );
      final list = _extractList(response.data);
      return list
          .map((dynamic e) => TimesheetMobileItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi tải danh sách chấm công cấp dưới');
    }
  }

  @override
  Future<List<ManagedEmployeeModel>> getManagedEmployees({String? from, String? to}) async {
    try {
      final response = await dioClient.get<dynamic>(
        ApiEndpoints.timesheetsMobileEmployees,
        queryParameters: <String, dynamic>{
          'from': ?from,
          'to': ?to,
        },
      );
      final list = _extractList(response.data);
      return list
          .map((dynamic e) => ManagedEmployeeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi tải danh sách nhân viên cấp dưới');
    }
  }

  @override
  Future<ServiceResultResponseModel> adminConfirmTimesheet(AdminConfirmTimesheetCommand command) async {
    try {
      final response = await dioClient.post<dynamic>(ApiEndpoints.timesheetAdminConfirm, data: command.toJson());
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi xác nhận giờ công');
    }
  }

  @override
  Future<ServiceResultResponseModel> rejectTimesheet(RejectTimesheetCommand command) async {
    try {
      final response = await dioClient.post<dynamic>(ApiEndpoints.timesheetReject, data: command.toJson());
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi từ chối giờ công');
    }
  }

  @override
  Future<List<TimesheetCorrectionItemModel>> getPendingTimesheetCorrections({String? month}) async {
    try {
      final queryMonth = _normalizeMonth(month);
      final response = await dioClient.get<dynamic>(
        ApiEndpoints.timesheetConfirmRequestsAdminMobile,
        queryParameters: <String, dynamic>{
          'month': queryMonth,
        },
      );
      final list = _extractList(response.data);
      return list
          .map((dynamic e) => TimesheetCorrectionItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi tải danh sách phê duyệt giải trình');
    }
  }

  @override
  Future<List<LeaveRequestResponseItem>> getPendingLeaveRequests({String? month}) async {
    try {
      final queryMonth = _normalizeMonth(month);
      final response = await dioClient.get<dynamic>(
        ApiEndpoints.leaveRequestsAdminMobile,
        queryParameters: <String, dynamic>{
          'version': '2',
          'month': queryMonth,
        },
      );
      final list = _extractList(response.data);
      return list
          .map((dynamic e) => LeaveRequestResponseItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi tải danh sách phê duyệt nghỉ phép');
    }
  }

  @override
  Future<List<OvertimeRequestSelfItemModel>> getPendingOvertimeRequests({String? month}) async {
    try {
      final queryMonth = _normalizeMonth(month);
      final response = await dioClient.get<dynamic>(
        ApiEndpoints.overtimeRequestsAdminMobile,
        queryParameters: <String, dynamic>{
          'month': queryMonth,
        },
      );
      final list = _extractList(response.data);
      return list
          .map((dynamic e) => OvertimeRequestSelfItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi tải danh sách phê duyệt tăng ca');
    }
  }

  ServiceResultResponseModel _parseServiceResult(dynamic data) {
    if (data is Map<String, dynamic>) {
      return ServiceResultResponseModel.fromJson(data);
    }
    return ServiceResultResponseModel(message: data?.toString() ?? 'Thành công');
  }
}
