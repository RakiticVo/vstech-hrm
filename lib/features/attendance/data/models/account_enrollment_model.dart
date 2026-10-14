import 'package:vstech_hrm/features/attendance/data/models/account_timesheet_model.dart';
import 'package:vstech_hrm/features/attendance/data/models/attendance_record_model.dart';

/// DTO Data Model for AccountEnrollmentItemDoc in OpenAPI 3.0.1 (GET /api/Account/enrollment).
class AccountEnrollmentModel {
  const AccountEnrollmentModel({
    required this.id,
    this.enrollDate,
    this.enrollDateRaw,
    this.shiftName,
    this.department,
    this.checkinTime,
    this.checkoutTime,
    this.lateHours = 0.0,
    this.earlyHours = 0.0,
    this.actualTime = 0.0,
    this.ipIn,
    this.ipOut,
    this.lateWarning,
    this.earlyWarning,
  });

  static double normalizeMinutes(double val) {
    if (val <= 0) return 0;
    if (val < 5.0) return (val * 60).roundToDouble();
    return val;
  }

  factory AccountEnrollmentModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0;
    }

    final rawLate = parseDouble(json['late'] ?? json['lateMinutes'] ?? json['lateHours']);
    final rawEarly = parseDouble(json['early'] ?? json['earlyMinutes'] ?? json['earlyHours']);

    return AccountEnrollmentModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      enrollDate: (json['enrollDate'] ?? json['date'] ?? json['workDate'])?.toString(),
      enrollDateRaw: json['enrollDateRaw'] != null
          ? DateTime.tryParse(json['enrollDateRaw'].toString())
          : null,
      shiftName: json['shiftName']?.toString(),
      department: (json['department'] ?? json['departmentName'] ?? json['location'])?.toString(),
      checkinTime: (json['checkinTime'] ?? json['checkInTime'] ?? json['checkin'])?.toString(),
      checkoutTime: (json['checkoutTime'] ?? json['checkOutTime'] ?? json['checkout'])?.toString(),
      lateHours: normalizeMinutes(rawLate),
      earlyHours: normalizeMinutes(rawEarly),
      actualTime: parseDouble(json['actualTime'] ?? json['actualWorkTime'] ?? json['workTime']),
      ipIn: json['ipIn']?.toString(),
      ipOut: json['ipOut']?.toString(),
      lateWarning: json['lateWarning'] as bool?,
      earlyWarning: json['earlyWarning'] as bool?,
    );
  }

  final int id;
  final String? enrollDate;
  final DateTime? enrollDateRaw;
  final String? shiftName;
  final String? department;
  final String? checkinTime;
  final String? checkoutTime;
  final double lateHours;
  final double earlyHours;
  final double actualTime;
  final String? ipIn;
  final String? ipOut;
  final bool? lateWarning;
  final bool? earlyWarning;

  /// Parses server UTC date & time and converts to device local DateTime.
  /// (DB stores CheckinTime/CheckoutTime in UTC; app converts to local time).
  static DateTime? parseServerUtcDateTime(String? dateStr, String? timeStr) {
    if (dateStr == null || timeStr == null || timeStr.isEmpty || timeStr == '00:00:00') {
      return null;
    }
    final trimmedTime = timeStr.trim();
    if (trimmedTime == '00:00' || trimmedTime == '--:--' || trimmedTime == '—') {
      return null;
    }

    // Direct ISO string with offset or Z
    if (trimmedTime.contains('T')) {
      final isoParsed = DateTime.tryParse(trimmedTime);
      if (isoParsed != null) {
        return isoParsed.isUtc ? isoParsed.toLocal() : (trimmedTime.contains('Z') || trimmedTime.contains('+') ? isoParsed.toUtc().toLocal() : DateTime.utc(isoParsed.year, isoParsed.month, isoParsed.day, isoParsed.hour, isoParsed.minute, isoParsed.second).toLocal());
      }
    }

    var year = DateTime.now().year;
    var month = 1;
    var day = 1;
    final cleanDate = dateStr.split('T')[0].trim();
    if (cleanDate.contains('-')) {
      final dParts = cleanDate.split('-');
      if (dParts.length == 3) {
        if (dParts[0].length == 4) {
          year = int.tryParse(dParts[0]) ?? year;
          month = int.tryParse(dParts[1]) ?? month;
          day = int.tryParse(dParts[2]) ?? day;
        } else {
          day = int.tryParse(dParts[0]) ?? day;
          month = int.tryParse(dParts[1]) ?? month;
          year = int.tryParse(dParts[2]) ?? year;
        }
      }
    } else if (cleanDate.contains('/')) {
      final dParts = cleanDate.split('/');
      if (dParts.length == 3) {
        if (dParts[2].length == 4) {
          day = int.tryParse(dParts[0]) ?? day;
          month = int.tryParse(dParts[1]) ?? month;
          year = int.tryParse(dParts[2]) ?? year;
        } else if (dParts[0].length == 4) {
          year = int.tryParse(dParts[0]) ?? year;
          month = int.tryParse(dParts[1]) ?? month;
          day = int.tryParse(dParts[2]) ?? day;
        }
      }
    }

    final tParts = trimmedTime.split(':');
    if (tParts.length >= 2) {
      final h = int.tryParse(tParts[0]);
      final min = int.tryParse(tParts[1]);
      if (h == null || min == null) return null;
      if (h == 0 && min == 0 && (tParts.length < 3 || int.tryParse(tParts[2].split('.')[0]) == 0)) {
        return null;
      }
      final sec = tParts.length > 2 ? (int.tryParse(tParts[2].split('.')[0]) ?? 0) : 0;
      // Convert server UTC to device local time
      return DateTime.utc(year, month, day, h, min, sec).toLocal();
    }
    return null;
  }

  static String? cleanTimeStr(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty || timeStr == '00:00:00' || timeStr == '00:00' || timeStr == '--:--' || timeStr == '—') {
      return null;
    }
    final trimmed = timeStr.trim();
    if (trimmed.length >= 5 && trimmed.contains(':')) {
      final parts = trimmed.split(':');
      if (parts.length >= 2) {
        final h = parts[0].padLeft(2, '0');
        final m = parts[1].padLeft(2, '0');
        return '$h:$m';
      }
    }
    return trimmed;
  }

  static String? formatLocalTimeStr(DateTime? dt) {
    if (dt == null) return null;
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Converts this enrollment log into AttendanceRecordModel items (Check-in and Check-out).
  List<AttendanceRecordModel> toAttendanceRecords() {
    final records = <AttendanceRecordModel>[];
    final location = department ?? '';
    final workDate = AccountTimesheetModel.parseWorkDate(
      enrollDate ?? enrollDateRaw?.toIso8601String(),
    );

    final isCheckedOut = checkoutTime != null &&
        checkoutTime!.isNotEmpty &&
        checkoutTime != '00:00:00' &&
        checkoutTime != '00:00';

    final cleanIn = cleanTimeStr(checkinTime);
    final inParsed = parseServerUtcDateTime(enrollDate, checkinTime);
    final localIn = formatLocalTimeStr(inParsed) ?? cleanIn;

    final inTimestamp = inParsed != null
        ? DateTime(workDate.year, workDate.month, workDate.day, inParsed.hour, inParsed.minute, inParsed.second)
        : (cleanIn != null
            ? DateTime(workDate.year, workDate.month, workDate.day, int.tryParse(cleanIn.split(':')[0]) ?? 8, int.tryParse(cleanIn.split(':')[1]) ?? 0)
            : DateTime(workDate.year, workDate.month, workDate.day, 8, 0));

    final cleanOut = cleanTimeStr(checkoutTime);
    final outParsed = isCheckedOut ? parseServerUtcDateTime(enrollDate, checkoutTime) : null;
    final localOut = isCheckedOut ? (formatLocalTimeStr(outParsed) ?? cleanOut) : null;

    final outTimestamp = outParsed != null
        ? DateTime(workDate.year, workDate.month, workDate.day, outParsed.hour, outParsed.minute, outParsed.second)
        : (cleanOut != null
            ? DateTime(workDate.year, workDate.month, workDate.day, int.tryParse(cleanOut.split(':')[0]) ?? 17, int.tryParse(cleanOut.split(':')[1]) ?? 30)
            : DateTime(workDate.year, workDate.month, workDate.day, 17, 30));

    final isEarlyWarning = earlyWarning ?? (earlyHours > 0);
    final isLateWarning = lateWarning ?? (lateHours > 0);

    if (isCheckedOut) {
      records.add(
        AttendanceRecordModel(
          id: '${id}_out',
          timestamp: outTimestamp,
          type: 'checkOut',
          classification: isEarlyWarning ? 'earlyLeave' : 'onTime',
          locationName: location,
          shiftName: shiftName,
          checkinTime: localIn,
          checkoutTime: localOut,
          actualHours: actualTime,
          lateHours: lateHours,
          earlyHours: earlyHours,
          earlyWarning: earlyWarning,
          note: shiftName,
          bssid: ipOut,
        ),
      );
    }

    records.add(
      AttendanceRecordModel(
        id: '${id}_in',
        timestamp: inTimestamp,
        type: 'checkIn',
        classification: isLateWarning ? 'late' : 'onTime',
        locationName: location,
        shiftName: shiftName,
        checkinTime: localIn,
        checkoutTime: localOut,
        actualHours: actualTime,
        lateHours: lateHours,
        earlyHours: earlyHours,
        lateWarning: lateWarning,
        note: shiftName,
        bssid: ipIn,
      ),
    );

    return records;
  }
}
