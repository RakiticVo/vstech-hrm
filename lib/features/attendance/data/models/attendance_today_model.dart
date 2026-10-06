import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_today_entity.dart';

/// DTO Data Model for today's attendance status with Vietnam Timezone (UTC+7) conversion.
class AttendanceTodayModel {
  const AttendanceTodayModel({
    required this.date,
    required this.shiftName,
    required this.shiftTime,
    required this.status,
    required this.isLate,
    this.checkInTime,
    this.checkOutTime,
  });

  factory AttendanceTodayModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('enroll') || json.containsKey('startShift')) {
      final enrollMode = json['enroll']?.toString().toUpperCase() ?? 'IN';
      final start = json['startShift']?.toString() ?? '07:30';
      final end = json['endShift']?.toString() ?? '17:30';
      final enrolls = json['enrolls'] as List<dynamic>? ?? <dynamic>[];

      String? firstCheckIn;
      String? lastCheckOut;
      for (final e in enrolls) {
        if (e is Map) {
          final cin = e['checkin']?.toString();
          final cout = e['checkout']?.toString();
          final dateStr = e['date']?.toString();
          final formattedIn = formatToVietnamTime(cin, dateStr);
          final formattedOut = formatToVietnamTime(cout, dateStr);
          if (formattedIn != null && firstCheckIn == null) {
            firstCheckIn = formattedIn;
          }
          if (formattedOut != null) {
            lastCheckOut = formattedOut;
          }
        }
      }

      final ts = json['timesheet'] is Map<String, dynamic>
          ? json['timesheet'] as Map<String, dynamic>
          : null;
      final isLate = ts != null && ((ts['late'] as num?) ?? 0) > 0;

      final String status;
      if (enrollMode == 'OUT' || (firstCheckIn != null && lastCheckOut == null)) {
        status = 'working';
      } else if (lastCheckOut != null) {
        status = 'completed';
      } else {
        status = 'not_started';
      }

      return AttendanceTodayModel(
        date: json['serverTime']?.toString() ??
            DateTime.now().toIso8601String().split('T')[0],
        shiftName: 'Ca Tiêu chuẩn',
        shiftTime: '$start - $end',
        status: status,
        isLate: isLate,
        checkInTime: firstCheckIn,
        checkOutTime: lastCheckOut,
      );
    }

    return AttendanceTodayModel(
      date: json['date']?.toString() ?? '',
      shiftName: json['shiftName']?.toString() ?? 'Ca Hành chính',
      shiftTime: json['shiftTime']?.toString() ?? '08:30 - 17:30',
      status: json['status']?.toString() ?? 'not_started',
      isLate: json['isLate'] == true,
      checkInTime: formatToVietnamTime(json['checkInTime']?.toString()),
      checkOutTime: formatToVietnamTime(json['checkOutTime']?.toString()),
    );
  }

  /// Converts UTC time string (e.g. "02:44:15" or ISO string) to Vietnam Time (UTC+7) formatted as "HH:mm".
  /// Returns null if time is null, empty, "00:00:00", or "00:00".
  static String? formatToVietnamTime(String? rawTime, [String? rawDate]) {
    if (rawTime == null) return null;
    final trimmed = rawTime.trim();
    if (trimmed.isEmpty ||
        trimmed == '00:00:00' ||
        trimmed == '00:00' ||
        trimmed == '--:--' ||
        trimmed == '—') {
      return null;
    }

    final isoParsed = DateTime.tryParse(trimmed);
    if (isoParsed != null) {
      final vnDateTime = isoParsed.isUtc
          ? isoParsed.add(const Duration(hours: 7))
          : (trimmed.contains('+') || trimmed.endsWith('Z')
              ? isoParsed.toUtc().add(const Duration(hours: 7))
              : isoParsed);
      final h = vnDateTime.hour.toString().padLeft(2, '0');
      final m = vnDateTime.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }

    final parts = trimmed.split(':');
    if (parts.length >= 2) {
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) return null;
      if (hour == 0 && minute == 0 && (parts.length < 3 || int.tryParse(parts[2]) == 0)) {
        return null;
      }
      final second = parts.length > 2 ? (int.tryParse(parts[2].split('.')[0]) ?? 0) : 0;

      var year = 2026;
      var month = 1;
      var day = 1;
      if (rawDate != null && rawDate.isNotEmpty) {
        if (rawDate.contains('-')) {
          final dateParts = rawDate.split('-');
          if (dateParts.length == 3) {
            if (dateParts[0].length == 4) {
              year = int.tryParse(dateParts[0]) ?? year;
              month = int.tryParse(dateParts[1]) ?? month;
              day = int.tryParse(dateParts[2].split('T')[0]) ?? day;
            } else {
              day = int.tryParse(dateParts[0]) ?? day;
              month = int.tryParse(dateParts[1]) ?? month;
              year = int.tryParse(dateParts[2].split('T')[0]) ?? year;
            }
          }
        }
      }

      final utcTime = DateTime.utc(year, month, day, hour, minute, second);
      final vnTime = utcTime.add(const Duration(hours: 7));
      final h = vnTime.hour.toString().padLeft(2, '0');
      final m = vnTime.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }

    return trimmed;
  }

  final String date;
  final String shiftName;
  final String shiftTime;
  final String status;
  final bool isLate;
  final String? checkInTime;
  final String? checkOutTime;

  Map<String, dynamic> toJson() => {
        'date': date,
        'shiftName': shiftName,
        'shiftTime': shiftTime,
        'status': status,
        'isLate': isLate,
        'checkInTime': checkInTime,
        'checkOutTime': checkOutTime,
      };

  AttendanceTodayEntity toEntity() {
    final times = shiftTime.split('-');
    final start = times.isNotEmpty ? times[0].trim() : '07:30';
    final end = times.length > 1 ? times[1].trim() : '17:30';

    final hasValidCheckIn = checkInTime != null &&
        checkInTime!.isNotEmpty &&
        checkInTime != '00:00:00' &&
        checkInTime != '00:00';
    final hasValidCheckOut = checkOutTime != null &&
        checkOutTime!.isNotEmpty &&
        checkOutTime != '00:00:00' &&
        checkOutTime != '00:00';

    return AttendanceTodayEntity(
      hasCheckedIn: hasValidCheckIn,
      hasCheckedOut: hasValidCheckOut,
      shiftName: shiftName,
      shiftStart: start,
      shiftEnd: end,
      classification: isLate
          ? AttendanceClassification.late
          : AttendanceClassification.onTime,
      todayDate: date,
      checkInTime: hasValidCheckIn ? checkInTime : null,
      checkOutTime: hasValidCheckOut ? checkOutTime : null,
    );
  }
}
