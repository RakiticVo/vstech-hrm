import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/network/api_error_handler.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/schedule/data/datasources/schedule_remote_datasource.dart';
import 'package:vstech_hrm/features/schedule/data/models/department_shift_day_model.dart';
import 'package:vstech_hrm/features/schedule/data/models/my_shift_day_model.dart';

/// Remote data source implementation using DioClient.
class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  const new({required this.dioClient});

  final DioClient dioClient;

  List<dynamic> _extractList(dynamic body) {
    if (body is Map<String, dynamic>) {
      if (body['items'] is List) return body['items'] as List<dynamic>;
      if (body['data'] is List) return body['data'] as List<dynamic>;
    }
    return body is List ? body : const [];
  }

  @override
  Future<List<MyShiftDayModel>> getMyShiftSchedule({
    required String from,
    required String to,
  }) async {
    try {
      final response = await dioClient.get<dynamic>(
        ApiEndpoints.myShiftSchedules,
        queryParameters: <String, dynamic>{
          'from': from,
          'to': to,
        },
      );
      final list = _extractList(response.data);
      return list
          .map((dynamic e) => MyShiftDayModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi tải lịch ca làm việc cá nhân');
    }
  }

  @override
  Future<List<DepartmentShiftDayModel>> getDepartmentShiftSchedule({
    required String from,
    required String to,
    String? departmentCode,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'from': from,
        'to': to,
      };
      if (departmentCode != null && departmentCode.isNotEmpty) {
        queryParams['departmentCode'] = departmentCode;
      }

      final response = await dioClient.get<dynamic>(
        ApiEndpoints.shiftSchedules,
        queryParameters: queryParams,
      );
      final list = _extractList(response.data);
      return list
          .map((dynamic e) =>
              DepartmentShiftDayModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(
        e,
        'Lỗi tải lịch ca làm việc của bộ phận/phòng ban',
      );
    }
  }
}
