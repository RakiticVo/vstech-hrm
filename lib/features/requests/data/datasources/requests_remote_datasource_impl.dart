import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/network/api_error_handler.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/requests/data/datasources/requests_remote_datasource.dart';
import 'package:vstech_hrm/features/requests/data/models/leave_request_models.dart';
import 'package:vstech_hrm/features/requests/data/models/overtime_request_models.dart';
import 'package:vstech_hrm/features/requests/data/models/timesheet_confirm_models.dart';
import 'package:vstech_hrm/features/requests/data/models/valid_leave_plan_model.dart';
import 'package:vstech_hrm/features/requests/data/models/valid_max_hour_model.dart';

class RequestsRemoteDataSourceImpl implements RequestsRemoteDataSource {
  const new({required this.dioClient});

  final DioClient dioClient;

  List<dynamic>? _extractList(dynamic body, [String? key]) {
    if (body is List) return body;
    if (body is Map<String, dynamic>) {
      if (key != null && body[key] is List) return body[key] as List<dynamic>;
      if (body['results'] is List) return body['results'] as List<dynamic>;
      if (body['items'] is List) return body['items'] as List<dynamic>;
      if (body['data'] is List) return body['data'] as List<dynamic>;
    }
    return null;
  }

  void _verifySuccess(dynamic body, String defaultFailureMsg) {
    if (body is Map<String, dynamic>) {
      if (body['success'] == false || body['status'] == false || body['isSuccess'] == false) {
        final msg = ApiErrorHandler.extractErrorMessage(body, defaultFailureMsg);
        throw ServerException(message: msg);
      }
    }
  }

  @override
  Future<List<LeaveRequestResponseItem>> getLeaveRequests({String? from, String? to}) async {
    try {
      final response = await dioClient.get<dynamic>(
        ApiEndpoints.leaveRequestsSelf,
        queryParameters: <String, dynamic>{
          if (from != null && from.isNotEmpty) 'from': from,
          if (to != null && to.isNotEmpty) 'to': to,
        },
      );
      final list = _extractList(response.data);
      if (list != null) {
        return list.map((dynamic e) => LeaveRequestResponseItem.fromJson(e as Map<String, dynamic>)).toList();
      }
      return <LeaveRequestResponseItem>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi tải danh sách nghỉ phép');
    }
  }

  @override
  Future<bool> createLeaveRequest(LeaveRequestCreateCommand command) async {
    try {
      final response = await dioClient.post<dynamic>(
        ApiEndpoints.leaveRequestsSelf,
        data: command.toJson(),
      );
      _verifySuccess(response.data, 'Gửi đơn xin nghỉ phép không thành công');
      return response.statusCode == 200;
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi gửi đơn xin nghỉ phép');
    }
  }

  @override
  Future<bool> deleteLeaveRequest(String id) async {
    try {
      final response = await dioClient.delete<dynamic>(ApiEndpoints.leaveRequestDelete(id));
      _verifySuccess(response.data, 'Thu hồi đơn nghỉ phép không thành công');
      return response.statusCode == 200;
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi thu hồi đơn nghỉ phép');
    }
  }

  @override
  Future<List<OvertimeRequestSelfItemModel>> getOvertimeRequests({String? month, bool includeCreated = false}) async {
    try {
      final response = await dioClient.get<dynamic>(
        ApiEndpoints.overtimeRequestsSelf,
        queryParameters: <String, dynamic>{
          if (month != null && month.isNotEmpty) 'month': month,
          if (includeCreated) 'includeCreated': true,
        },
      );
      final list = _extractList(response.data);
      if (list != null) {
        return list.map((dynamic e) => OvertimeRequestSelfItemModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return <OvertimeRequestSelfItemModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi tải danh sách tăng ca');
    }
  }

  @override
  Future<bool> createOvertimeRequest(OvertimeRequestCreateModel command) async {
    try {
      final isProxy = command.adminEmployeeCode != null && command.adminEmployeeCode!.isNotEmpty;
      final endpoint = isProxy ? ApiEndpoints.overtimeRequestsAdmin : ApiEndpoints.overtimeRequests;
      final response = await dioClient.post<dynamic>(
        endpoint,
        data: command.toJson(),
      );
      _verifySuccess(response.data, 'Đăng ký tăng ca không thành công');
      return response.statusCode == 200;
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi đăng ký tăng ca');
    }
  }

  @override
  Future<bool> deleteOvertimeRequest(String id) async {
    try {
      final response = await dioClient.delete<dynamic>(ApiEndpoints.overtimeRequestDelete(id));
      _verifySuccess(response.data, 'Xóa đơn tăng ca không thành công');
      return response.statusCode == 200;
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi xóa đơn tăng ca');
    }
  }

  @override
  Future<ValidMaxHourModel> getValidMaxHour({
    required String date,
    String? overtimeTypeCode,
    String? adminEmployee,
  }) async {
    try {
      final response = await dioClient.get<dynamic>(
        ApiEndpoints.overtimeRequestsValidMaxHour,
        queryParameters: <String, dynamic>{
          'date': date,
          if (overtimeTypeCode != null && overtimeTypeCode.isNotEmpty) 'overtimeTypeCode': overtimeTypeCode,
          if (adminEmployee != null && adminEmployee.isNotEmpty) 'adminEmployee': adminEmployee,
        },
      );
      final dynamic body = response.data;
      if (body is Map<String, dynamic>) return ValidMaxHourModel.fromJson(body);
      return const ValidMaxHourModel(maxHour: 18, isLock: false);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi kiểm tra giờ tăng ca tối đa');
    }
  }

  @override
  Future<List<TimesheetCorrectionItemModel>> getCorrectionRequests({
    String? month,
    bool personal = true,
  }) async {
    try {
      final response = await dioClient.get<dynamic>(
        ApiEndpoints.timesheetConfirmRequests,
        queryParameters: <String, dynamic>{
          if (month != null && month.isNotEmpty) 'month': month,
          'personal': personal,
        },
      );
      final list = _extractList(response.data);
      if (list != null) {
        return list.map((dynamic e) => TimesheetCorrectionItemModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return <TimesheetCorrectionItemModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi tải phiếu giải trình công');
    }
  }

  @override
  Future<List<CorrectionReasonTypeModel>> getCorrectionReasons() async {
    try {
      final response = await dioClient.get<dynamic>(ApiEndpoints.timesheetConfirmReasons);
      final list = _extractList(response.data);
      if (list != null) {
        return list.map((dynamic e) => CorrectionReasonTypeModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return <CorrectionReasonTypeModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi tải danh mục lý do');
    }
  }

  @override
  Future<List<LeavePlanModel>> getLeavePlans() async {
    try {
      final response = await dioClient.get<dynamic>(
        ApiEndpoints.leaveRequestsSelf,
        queryParameters: <String, dynamic>{'init': 1, 'version': 1},
      );
      final list = _extractList(response.data, 'leavePlans');
      if (list != null) {
        return list.map((dynamic e) => LeavePlanModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return <LeavePlanModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi tải danh mục loại nghỉ phép');
    }
  }

  @override
  Future<List<ValidLeavePlanModel>> getValidLeavePlans({
    String? execDate,
    String? customEmployeeCode,
    int all = 0,
  }) async {
    try {
      final now = DateTime.now();
      final dateStr = execDate ?? '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final response = await dioClient.get<dynamic>(
        ApiEndpoints.validLeavePlan2,
        queryParameters: <String, dynamic>{
          'execDate': dateStr,
          if (customEmployeeCode != null && customEmployeeCode.isNotEmpty) 'customEmployeeCode': customEmployeeCode,
          if (all != 0) 'all': all,
        },
      );
      final list = _extractList(response.data);
      if (list != null) {
        return list.map((dynamic e) => ValidLeavePlanModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return <ValidLeavePlanModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi tải danh sách phép khả dụng');
    }
  }

  @override
  Future<List<OvertimeTypeModel>> getOvertimeTypes() async {
    try {
      final response = await dioClient.get<dynamic>(
        ApiEndpoints.overtimeRequestsSelf,
        queryParameters: <String, dynamic>{'init': 1},
      );
      final list = _extractList(response.data, 'overtimeTypes');
      if (list != null) {
        return list.map((dynamic e) => OvertimeTypeModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return <OvertimeTypeModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi tải danh mục loại tăng ca');
    }
  }

  @override
  Future<bool> createCorrectionRequest(CreateTimesheetCorrectionCommand command) async {
    try {
      final response = await dioClient.post<dynamic>(
        ApiEndpoints.timesheetConfirmRequests,
        data: command.toJson(),
      );
      _verifySuccess(response.data, 'Gửi phiếu giải trình không thành công');
      return response.statusCode == 200;
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi gửi phiếu giải trình');
    }
  }
}
