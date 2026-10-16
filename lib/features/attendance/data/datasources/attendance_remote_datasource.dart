import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/network/api_error_handler.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/attendance/data/models/account_enrollment_model.dart';
import 'package:vstech_hrm/features/attendance/data/models/account_timesheet_model.dart';
import 'package:vstech_hrm/features/attendance/data/models/attendance_record_model.dart';
import 'package:vstech_hrm/features/attendance/data/models/attendance_today_model.dart';
import 'package:vstech_hrm/features/attendance/data/models/timesheet_detail_model.dart';
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

  Future<Map<String, int>> getTimesheetSummary({DateTime? month});

  Future<List<AccountTimesheetModel>> getAccountTimesheet({required String monthYear});

  Future<TimesheetDetailModel?> getTimesheetDetail(String id);
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
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi tải thông tin chấm công hôm nay');
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
        locationName: (params.lat == 10.7769 && params.lng == 106.7009)
            ? 'Trụ sở chính VSTech'
            : 'Vị trí thực tế (${params.lat.toStringAsFixed(4)}, ${params.lng.toStringAsFixed(4)})',
        lat: params.lat,
        lng: params.lng,
        bssid: params.bssid,
        note: message,
      );
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi thực hiện Check-in');
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
        locationName: (params.lat == 10.7769 && params.lng == 106.7009)
            ? 'Trụ sở chính VSTech'
            : 'Vị trí thực tế (${params.lat.toStringAsFixed(4)}, ${params.lng.toStringAsFixed(4)})',
        lat: params.lat,
        lng: params.lng,
        bssid: params.bssid,
        note: message,
      );
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi thực hiện Check-out');
    }
  }

  @override
  Future<List<AttendanceRecordModel>> getAttendanceHistory({
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final targetDate = from ?? DateTime.now();
      final monthYear =
          '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-01';

      final response = await _dioClient.get<dynamic>(
        ApiEndpoints.attendanceHistory,
        queryParameters: <String, dynamic>{
          'monthYear': monthYear,
        },
      );
      final dynamic body = response.data;
      if (body is Map<String, dynamic>) {
        if (body['items'] is List) {
          final items = body['items'] as List;
          final allRecords = <AttendanceRecordModel>[];
          for (final e in items) {
            if (e is Map<String, dynamic>) {
              final enrollment = AccountEnrollmentModel.fromJson(e);
              allRecords.addAll(enrollment.toAttendanceRecords());
            }
          }
          return allRecords;
        }
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
                final sec = tParts.length > 2
                    ? (int.tryParse(tParts[2].split('.')[0]) ?? 0)
                    : 0;
                timestamp = DateTime.utc(year, month, day, hour, min, sec).toLocal();
              }
            }
            final localTimeStr =
                '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
            return AttendanceRecordModel(
              id: 'att_${map['date']}_$timeStr',
              timestamp: timestamp,
              type: 'checkIn',
              checkinTime: localTimeStr,
              classification:
                  ((map['late'] as num?) ?? 0) > 0 ? 'late' : 'onTime',
              locationName: 'Trụ sở chính VSTech',
            );
          }).toList();
        }
      }
      return <AttendanceRecordModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi tải lịch sử chấm công');
    }
  }

  @override
  Future<List<AccountTimesheetModel>> getAccountTimesheet({required String monthYear}) async {
    try {
      final response = await _dioClient.get<dynamic>(
        ApiEndpoints.accountTimesheet,
        queryParameters: <String, dynamic>{'monthYear': monthYear},
      );
      final dynamic body = response.data;
      final dynamic raw = body is Map<String, dynamic>
          ? (body['items'] ?? body['data'])
          : body;
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map(AccountTimesheetModel.fromJson)
            .toList();
      }
      return <AccountTimesheetModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi tải bảng công tháng');
    }
  }

  @override
  Future<Map<String, int>> getTimesheetSummary({DateTime? month}) async {
    try {
      final target = month ?? DateTime.now();
      final monthStr = '${target.year}-${target.month.toString().padLeft(2, '0')}-01';
      final items = await getAccountTimesheet(monthYear: monthStr);
      final present = items.where((i) => i.validActualTime > 0 || i.actualWorkTime > 0).length;
      final leave = items.where((i) => i.leaveTime > 0).length;
      return {'present': present, 'leave': leave};
    } on Object {
      return {'present': 0, 'leave': 0};
    }
  }

  @override
  Future<TimesheetDetailModel?> getTimesheetDetail(String id) async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.timesheetDetail(id));
      if (response.data is Map<String, dynamic>) {
        return TimesheetDetailModel.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on Object catch (e) {
      throw ApiErrorHandler.toServerException(e, 'Lỗi khi tải chi tiết ngày công');
    }
  }
}
