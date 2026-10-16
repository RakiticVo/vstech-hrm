import 'package:vstech_hrm/features/attendance/domain/entities/account_timesheet_entity.dart';

/// DTO model for AccountTimesheetItemDoc in OpenAPI 3.0.1 (GET /api/Account/timesheet).
class AccountTimesheetModel {
  const new({
    required this.workDate,
    required this.actualWorkTime,
    required this.validActualTime,
    required this.lunch,
    required this.extendedTime,
    required this.leaveTime,
    required this.overtime,
    required this.overtimeScale,
    required this.isConfirmed,
    this.late = 0.0,
    this.early = 0.0,
    this.checkinTime,
    this.checkoutTime,
    this.note,
    this.lateWarning,
    this.earlyWarning,
  });

  factory AccountTimesheetModel.fromJson(Map<String, dynamic> json) {
    final rawLate = _parseDouble(json['late'] ?? json['lateMinutes'] ?? json['lateHours']);
    final rawEarly = _parseDouble(json['early'] ?? json['earlyMinutes'] ?? json['earlyHours']);
    final lateNorm = rawLate > 0 && rawLate < 5.0 ? (rawLate * 60).roundToDouble() : rawLate;
    final earlyNorm = rawEarly > 0 && rawEarly < 5.0 ? (rawEarly * 60).roundToDouble() : rawEarly;

    return AccountTimesheetModel(
      workDate: (json['workDate'] ?? json['date'] ?? json['enrollDate'])?.toString() ?? '',
      actualWorkTime: _parseDouble(json['actualWorkTime'] ?? json['actualTime']),
      validActualTime: _parseDouble(json['validActualTime'] ?? json['validTime']),
      lunch: _parseDouble(json['lunch']),
      extendedTime: _parseDouble(json['extendedTime']),
      leaveTime: _parseDouble(json['leaveTime']),
      overtime: _parseDouble(json['overtime']),
      overtimeScale: _parseDouble(json['overtimeScale'], 1),
      isConfirmed: _parseBool(json['isConfirmed']),
      late: lateNorm,
      early: earlyNorm,
      checkinTime: (json['checkinTime'] ?? json['checkInTime'] ?? json['checkin'])?.toString(),
      checkoutTime: (json['checkoutTime'] ?? json['checkOutTime'] ?? json['checkout'])?.toString(),
      note: json['note']?.toString(),
      lateWarning: json['lateWarning'] as bool?,
      earlyWarning: json['earlyWarning'] as bool?,
    );
  }

  static double _parseDouble(dynamic v, [double defaultValue = 0.0]) {
    if (v == null) return defaultValue;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? defaultValue;
    return defaultValue;
  }

  static bool _parseBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is num) return v == 1;
    final s = v.toString().toLowerCase();
    return s == 'true' || s == '1';
  }

  static DateTime parseWorkDate(String? raw) {
    if (raw == null || raw.isEmpty) return DateTime.now();
    final clean = raw.split('T')[0].trim();
    if (clean.contains('-')) {
      final parts = clean.split('-');
      if (parts.length == 3) {
        if (parts[0].length == 4) {
          final y = int.tryParse(parts[0]) ?? DateTime.now().year;
          final m = int.tryParse(parts[1]) ?? 1;
          final d = int.tryParse(parts[2]) ?? 1;
          return DateTime(y, m, d);
        } else {
          final d = int.tryParse(parts[0]) ?? 1;
          final m = int.tryParse(parts[1]) ?? 1;
          final y = int.tryParse(parts[2]) ?? DateTime.now().year;
          return DateTime(y, m, d);
        }
      }
    } else if (clean.contains('/')) {
      final parts = clean.split('/');
      if (parts.length == 3) {
        if (parts[2].length == 4) {
          final d = int.tryParse(parts[0]) ?? 1;
          final m = int.tryParse(parts[1]) ?? 1;
          final y = int.tryParse(parts[2]) ?? DateTime.now().year;
          return DateTime(y, m, d);
        } else if (parts[0].length == 4) {
          final y = int.tryParse(parts[0]) ?? DateTime.now().year;
          final m = int.tryParse(parts[1]) ?? 1;
          final d = int.tryParse(parts[2]) ?? 1;
          return DateTime(y, m, d);
        }
      }
    }
    return DateTime.tryParse(raw) ?? DateTime.now();
  }

  final String workDate;
  final double actualWorkTime;
  final double validActualTime;
  final double lunch;
  final double extendedTime;
  final double leaveTime;
  final double overtime;
  final double overtimeScale;
  final bool isConfirmed;
  final double late;
  final double early;
  final String? checkinTime;
  final String? checkoutTime;
  final String? note;
  final bool? lateWarning;
  final bool? earlyWarning;

  AccountTimesheetEntity toEntity() {
    final noteLower = note?.toLowerCase() ?? '';
    final isRej = !isConfirmed && (noteLower.contains('từ chối') || noteLower.contains('reject'));
    final effectiveValidTime = (!isConfirmed || isRej) ? 0.0 : validActualTime;

    return AccountTimesheetEntity(
      workDate: parseWorkDate(workDate),
      actualWorkTime: actualWorkTime,
      validActualTime: effectiveValidTime,
      lunch: lunch,
      extendedTime: extendedTime,
      leaveTime: leaveTime,
      overtime: overtime,
      overtimeScale: overtimeScale,
      isConfirmed: isConfirmed,
      late: late,
      early: early,
      checkinTime: checkinTime,
      checkoutTime: checkoutTime,
      note: note,
      lateWarning: lateWarning,
      earlyWarning: earlyWarning,
    );
  }
}
