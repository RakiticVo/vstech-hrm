import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/approvals/data/models/approval_models.dart';
import 'package:vstech_hrm/features/requests/data/models/timesheet_confirm_models.dart';

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
}

class ApprovalsRemoteDataSourceImpl implements ApprovalsRemoteDataSource {
  const new({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<ServiceResultResponseModel> approveLeave(String id) async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.leaveAccept(id));
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi duyệt đơn nghỉ phép: $e');
    }
  }

  @override
  Future<ServiceResultResponseModel> rejectLeave(String id) async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.leaveDeny(id));
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi từ chối đơn nghỉ phép: $e');
    }
  }

  @override
  Future<ServiceResultResponseModel> approveOvertime(String id) async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.overtimeAccept(id));
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi duyệt đơn tăng ca: $e');
    }
  }

  @override
  Future<ServiceResultResponseModel> rejectOvertime(String id) async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.overtimeDeny(id));
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi từ chối đơn tăng ca: $e');
    }
  }

  @override
  Future<ServiceResultResponseModel> approveBusinessTrip(String id) async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.businessAccept(id));
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi duyệt đơn công tác: $e');
    }
  }

  @override
  Future<bool> rejectBusinessTrip(String id) async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.businessDeny(id));
      return response.statusCode == 200;
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi từ chối đơn công tác: $e');
    }
  }

  @override
  Future<ServiceResultResponseModel> approveTimesheetCorrection(
    int id,
    TimesheetConfirmApproveCommand command,
  ) async {
    try {
      final response = await _dioClient.post<dynamic>(
        ApiEndpoints.timesheetConfirmAccept(id),
        data: command.toJson(),
      );
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi duyệt phiếu giải trình: $e');
    }
  }

  @override
  Future<ServiceResultResponseModel> rejectTimesheetCorrection(int id, {String? note}) async {
    try {
      final response = await _dioClient.post<dynamic>(
        ApiEndpoints.timesheetConfirmReject(id),
        queryParameters: <String, dynamic>{
          if (note != null && note.isNotEmpty) 'note': note,
        },
      );
      return _parseServiceResult(response.data);
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi từ chối phiếu giải trình: $e');
    }
  }

  @override
  Future<List<TimesheetCorrectionItemModel>> getPendingTimesheetCorrections({String? month}) async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiEndpoints.timesheetConfirmRequests,
        queryParameters: <String, dynamic>{
          'personal': false,
          if (month != null) 'month': month,
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
      throw ServerException(message: 'Lỗi tải danh sách phê duyệt giải trình: $e');
    }
  }

  ServiceResultResponseModel _parseServiceResult(dynamic data) {
    if (data is Map<String, dynamic>) {
      return ServiceResultResponseModel.fromJson(data);
    }
    return ServiceResultResponseModel(message: data?.toString() ?? 'Thành công');
  }
}
