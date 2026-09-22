import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/attendance/data/models/attendance_record_model.dart';
import 'package:vstech_hrm/features/attendance/data/models/attendance_today_model.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceTodayModel> getTodayAttendance();

  Future<AttendanceRecordModel> checkIn(CheckInParams params);

  Future<AttendanceRecordModel> checkOut(CheckInParams params);

  Future<List<AttendanceRecordModel>> getAttendanceHistory({
    DateTime? from,
    DateTime? to,
  });
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  const new({required this._dioClient});

  final DioClient _dioClient;

  @override
  Future<AttendanceTodayModel> getTodayAttendance() async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiEndpoints.attendanceToday,
      );
      final body = response.data;
      if (body != null && body['data'] is Map<String, dynamic>) {
        return AttendanceTodayModel.fromJson(body['data'] as Map<String, dynamic>);
      }
      throw const ServerException(message: 'Dữ liệu ca làm việc không hợp lệ');
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi tải thông tin chấm công hôm nay: $e');
    }
  }

  @override
  Future<AttendanceRecordModel> checkIn(CheckInParams params) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        ApiEndpoints.attendanceCheckIn,
        data: <String, dynamic>{
          'imagePath': params.imagePath,
          'lat': params.lat,
          'lng': params.lng,
          'bssid': params.bssid,
          'capturedAt': params.capturedAt.toIso8601String(),
          'note': params.note,
        },
      );
      final body = response.data;
      if (body != null && body['data'] is Map<String, dynamic>) {
        return AttendanceRecordModel.fromJson(body['data'] as Map<String, dynamic>);
      }
      return AttendanceRecordModel(
        id: 'att_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        type: 'checkIn',
        classification: 'onTime',
        locationName: 'Trụ sở chính VSTech',
        lat: params.lat,
        lng: params.lng,
        bssid: params.bssid,
      );
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi thực hiện Check-in: $e');
    }
  }

  @override
  Future<AttendanceRecordModel> checkOut(CheckInParams params) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        ApiEndpoints.attendanceCheckOut,
        data: <String, dynamic>{
          'imagePath': params.imagePath,
          'lat': params.lat,
          'lng': params.lng,
          'bssid': params.bssid,
          'capturedAt': params.capturedAt.toIso8601String(),
          'note': params.note,
        },
      );
      final body = response.data;
      if (body != null && body['data'] is Map<String, dynamic>) {
        return AttendanceRecordModel.fromJson(body['data'] as Map<String, dynamic>);
      }
      return AttendanceRecordModel(
        id: 'att_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        type: 'checkOut',
        classification: 'onTime',
        locationName: 'Trụ sở chính VSTech',
        lat: params.lat,
        lng: params.lng,
        bssid: params.bssid,
      );
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi thực hiện Check-out: $e');
    }
  }

  @override
  Future<List<AttendanceRecordModel>> getAttendanceHistory({
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiEndpoints.attendanceHistory,
        queryParameters: {
          if (from != null) 'from': from.toIso8601String(),
          if (to != null) 'to': to.toIso8601String(),
        },
      );
      final body = response.data;
      if (body != null && body['data'] is List) {
        final list = body['data'] as List;
        return list
            .map((e) => AttendanceRecordModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi tải lịch sử chấm công: $e');
    }
  }
}
