import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/attendance/data/models/attendance_record_model.dart';
import 'package:vstech_hrm/features/attendance/data/models/attendance_today_model.dart';
import 'package:vstech_hrm/features/attendance/domain/repositories/attendance_repository.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceTodayModel> getTodayAttendance();

  Future<String> getAttendMode();

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
      final response = await _dioClient.get<dynamic>(
        ApiEndpoints.attendanceToday,
      );
      final dynamic body = response.data;
      if (body is Map<String, dynamic>) {
        if (body.containsKey('data') && body['data'] is Map<String, dynamic>) {
          return AttendanceTodayModel.fromJson(body['data'] as Map<String, dynamic>);
        }
        return AttendanceTodayModel.fromJson(body);
      }
      throw const ServerException(message: 'Dữ liệu ca làm việc không hợp lệ');
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi tải thông tin chấm công hôm nay: $e');
    }
  }

  @override
  Future<String> getAttendMode() async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiEndpoints.enrollmentAttend,
      );
      final dynamic body = response.data;
      if (body is Map<String, dynamic>) {
        return body['mode']?.toString() ?? 'IN';
      }
      return 'IN';
    } on AppException {
      rethrow;
    } on Object {
      return 'IN';
    }
  }

  @override
  Future<AttendanceRecordModel> checkIn(CheckInParams params) async {
    try {
      final enrollForm = <String, dynamic>{
        'coordinate': '${params.lat},${params.lng}',
        'local': params.bssid,
        'fingerprint': 'device_fingerprint_01',
      };

      final response = await _dioClient.post<dynamic>(
        ApiEndpoints.attendanceCheckIn,
        data: enrollForm,
      );
      final dynamic body = response.data;
      var message = 'Ghi nhận chấm công thành công';
      if (body is Map<String, dynamic>) {
        if (body['message'] != null && body['message'].toString().isNotEmpty) {
          message = body['message'].toString();
        }
      }

      final isLate = params.capturedAt.hour > 8 ||
          (params.capturedAt.hour == 8 && params.capturedAt.minute > 5);
      return AttendanceRecordModel(
        id: 'att_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: params.capturedAt,
        type: 'checkIn',
        classification: isLate ? 'late' : 'onTime',
        locationName: 'Trụ sở chính VSTech',
        lat: params.lat,
        lng: params.lng,
        bssid: params.bssid,
        note: message,
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
      final enrollForm = <String, dynamic>{
        'coordinate': '${params.lat},${params.lng}',
        'local': params.bssid,
        'fingerprint': 'device_fingerprint_01',
      };

      final response = await _dioClient.post<dynamic>(
        ApiEndpoints.attendanceCheckOut,
        data: enrollForm,
      );
      final dynamic body = response.data;
      var message = 'Ghi nhận chấm công ra ca thành công';
      if (body is Map<String, dynamic>) {
        if (body['message'] != null && body['message'].toString().isNotEmpty) {
          message = body['message'].toString();
        }
      }

      final isEarly = params.capturedAt.hour < 17;
      return AttendanceRecordModel(
        id: 'att_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: params.capturedAt,
        type: 'checkOut',
        classification: isEarly ? 'earlyLeave' : 'onTime',
        locationName: 'Trụ sở chính VSTech',
        lat: params.lat,
        lng: params.lng,
        bssid: params.bssid,
        note: message,
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
      final response = await _dioClient.get<dynamic>(
        ApiEndpoints.attendanceHistory,
        queryParameters: <String, dynamic>{
          if (from != null) 'from': from.toIso8601String(),
          if (to != null) 'to': to.toIso8601String(),
        },
      );
      final dynamic body = response.data;
      if (body is Map<String, dynamic>) {
        if (body['data'] is List) {
          final list = body['data'] as List;
          return list
              .map((dynamic e) =>
                  AttendanceRecordModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        if (body['enrolls'] is List) {
          final enrolls = body['enrolls'] as List;
          return enrolls.map((dynamic e) {
            final map = e as Map<String, dynamic>;
            final dateStr = map['date']?.toString();
            final timeStr = map['checkin']?.toString() ?? '08:00:00';
            var timestamp = DateTime.now();
            if (dateStr != null && timeStr != '00:00:00') {
              final dParts = dateStr.split('-');
              final tParts = timeStr.split(':');
              if (dParts.length == 3 && tParts.length >= 2) {
                final day = int.tryParse(dParts[0]) ?? 1;
                final month = int.tryParse(dParts[1]) ?? 1;
                final year = int.tryParse(dParts[2]) ?? DateTime.now().year;
                final hour = int.tryParse(tParts[0]) ?? 0;
                final min = int.tryParse(tParts[1]) ?? 0;
                final sec = tParts.length > 2 ? (int.tryParse(tParts[2].split('.')[0]) ?? 0) : 0;
                // Add 7 hours to convert from server UTC to Vietnam Time (ICT)
                timestamp = DateTime.utc(year, month, day, hour, min, sec).add(const Duration(hours: 7));
              }
            }
            return AttendanceRecordModel(
              id: 'att_${map['date']}_$timeStr',
              timestamp: timestamp,
              type: 'checkIn',
              classification: ((map['late'] as num?) ?? 0) > 0 ? 'late' : 'onTime',
              locationName: 'Trụ sở chính VSTech',
            );
          }).toList();
        }
      }
      return <AttendanceRecordModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi khi tải lịch sử chấm công: $e');
    }
  }
}
