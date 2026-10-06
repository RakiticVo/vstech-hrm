import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/requests/data/models/leave_request_models.dart';
import 'package:vstech_hrm/features/requests/data/models/overtime_request_models.dart';
import 'package:vstech_hrm/features/requests/data/models/timesheet_confirm_models.dart';

abstract class RequestsRemoteDataSource {
  Future<List<LeaveRequestResponseItem>> getLeaveRequests();
  Future<List<LeavePlanModel>> getLeavePlans();
  Future<bool> createLeaveRequest(LeaveRequestCreateCommand command);
  Future<bool> deleteLeaveRequest(String id);

  Future<List<OvertimeRequestSelfItemModel>> getOvertimeRequests({String? month});
  Future<List<OvertimeTypeModel>> getOvertimeTypes();
  Future<bool> createOvertimeRequest(OvertimeRequestCreateModel command);
  Future<bool> deleteOvertimeRequest(String id);

  Future<List<TimesheetCorrectionItemModel>> getCorrectionRequests({String? month, bool personal = true});
  Future<List<CorrectionReasonTypeModel>> getCorrectionReasons();
  Future<bool> createCorrectionRequest(CreateTimesheetCorrectionCommand command);
}

class RequestsRemoteDataSourceImpl implements RequestsRemoteDataSource {
  const new({required this._dioClient});

  final DioClient _dioClient;

  @override
  Future<List<LeaveRequestResponseItem>> getLeaveRequests() async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.leaveRequestsSelf);
      final dynamic body = response.data;
      if (body is Map<String, dynamic> && body['results'] is List) {
        final list = body['results'] as List;
        return list
            .map((dynamic e) => LeaveRequestResponseItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <LeaveRequestResponseItem>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi tải danh sách nghỉ phép: $e');
    }
  }

  @override
  Future<bool> createLeaveRequest(LeaveRequestCreateCommand command) async {
    try {
      final response = await _dioClient.post<dynamic>(
        ApiEndpoints.leaveRequests,
        data: command.toJson(),
      );
      return response.statusCode == 200;
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi gửi đơn xin nghỉ phép: $e');
    }
  }

  @override
  Future<bool> deleteLeaveRequest(String id) async {
    try {
      final response = await _dioClient.delete<dynamic>(ApiEndpoints.leaveRequestDelete(id));
      return response.statusCode == 200;
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi thu hồi đơn nghỉ phép: $e');
    }
  }

  @override
  Future<List<OvertimeRequestSelfItemModel>> getOvertimeRequests({String? month}) async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiEndpoints.overtimeRequestsSelf,
        queryParameters: <String, dynamic>{
          if (month != null) 'month': month,
        },
      );
      final dynamic body = response.data;
      if (body is List) {
        return body
            .map((dynamic e) => OvertimeRequestSelfItemModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <OvertimeRequestSelfItemModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi tải danh sách tăng ca: $e');
    }
  }

  @override
  Future<bool> createOvertimeRequest(OvertimeRequestCreateModel command) async {
    try {
      final response = await _dioClient.post<dynamic>(
        ApiEndpoints.overtimeRequests,
        data: command.toJson(),
      );
      return response.statusCode == 200;
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi đăng ký tăng ca: $e');
    }
  }

  @override
  Future<bool> deleteOvertimeRequest(String id) async {
    try {
      final response = await _dioClient.delete<dynamic>(ApiEndpoints.overtimeRequestDelete(id));
      return response.statusCode == 200;
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi xóa đơn tăng ca: $e');
    }
  }

  @override
  Future<List<TimesheetCorrectionItemModel>> getCorrectionRequests({
    String? month,
    bool personal = true,
  }) async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiEndpoints.timesheetConfirmRequests,
        queryParameters: <String, dynamic>{
          if (month != null) 'month': month,
          'personal': personal,
        },
      );
      final dynamic body = response.data;
      if (body is Map<String, dynamic> && body['data'] is List) {
        final list = body['data'] as List;
        return list
            .map((dynamic e) => TimesheetCorrectionItemModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <TimesheetCorrectionItemModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi tải phiếu giải trình công: $e');
    }
  }

  @override
  Future<List<CorrectionReasonTypeModel>> getCorrectionReasons() async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.timesheetConfirmReasons);
      final dynamic body = response.data;
      if (body is Map<String, dynamic> && body['data'] is List) {
        final list = body['data'] as List;
        return list
            .map((dynamic e) => CorrectionReasonTypeModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <CorrectionReasonTypeModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi tải danh mục lý do: $e');
    }
  }

  @override
  Future<List<LeavePlanModel>> getLeavePlans() async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiEndpoints.leaveRequestsSelf,
        queryParameters: <String, dynamic>{'init': 1, 'version': 1},
      );
      final dynamic body = response.data;
      List<dynamic>? plans;
      if (body is List) {
        plans = body;
      } else if (body is Map<String, dynamic>) {
        if (body['leavePlans'] is List) {
          plans = body['leavePlans'] as List;
        } else if (body['data'] is Map<String, dynamic> &&
            body['data']['leavePlans'] is List) {
          plans = body['data']['leavePlans'] as List;
        } else if (body['data'] is List) {
          plans = body['data'] as List;
        }
      }
      if (plans != null) {
        return plans
            .map((dynamic e) => LeavePlanModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <LeavePlanModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi tải danh mục loại nghỉ phép: $e');
    }
  }

  @override
  Future<List<OvertimeTypeModel>> getOvertimeTypes() async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiEndpoints.overtimeRequestsSelf,
        queryParameters: <String, dynamic>{'init': 1},
      );
      final dynamic body = response.data;
      List<dynamic>? types;
      if (body is List) {
        types = body;
      } else if (body is Map<String, dynamic>) {
        if (body['overtimeTypes'] is List) {
          types = body['overtimeTypes'] as List;
        } else if (body['data'] is Map<String, dynamic> &&
            body['data']['overtimeTypes'] is List) {
          types = body['data']['overtimeTypes'] as List;
        } else if (body['data'] is List) {
          types = body['data'] as List;
        }
      }
      if (types != null) {
        return types
            .map((dynamic e) => OvertimeTypeModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <OvertimeTypeModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi tải danh mục loại tăng ca: $e');
    }
  }

  @override
  Future<bool> createCorrectionRequest(CreateTimesheetCorrectionCommand command) async {
    try {
      final response = await _dioClient.post<dynamic>(
        ApiEndpoints.timesheetConfirmRequests,
        data: command.toJson(),
      );
      return response.statusCode == 200;
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi gửi phiếu giải trình: $e');
    }
  }
}

