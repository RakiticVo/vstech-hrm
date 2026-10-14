import 'package:equatable/equatable.dart';

/// Domain entity representing a daily timesheet row from GET /api/Account/timesheet.
class AccountTimesheetEntity extends Equatable {
  const AccountTimesheetEntity({
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

  /// Work date formatted as yyyy-MM-dd.
  final DateTime workDate;

  /// Actual recorded hours worked.
  final double actualWorkTime;

  /// Approved valid working hours.
  final double validActualTime;

  /// Lunch allowance / overtime lunch hours.
  final double lunch;

  /// Extended shift hours.
  final double extendedTime;

  /// Approved leave hours (e.g. 4.0 or 8.0).
  final double leaveTime;

  /// Overtime hours.
  final double overtime;

  /// Overtime scaling multiplier.
  final double overtimeScale;

  /// True if timesheet is approved/confirmed.
  final bool isConfirmed;

  /// Minutes arrived late (0 if on time).
  final double late;

  /// Minutes left early (0 if on time).
  final double early;

  /// Recorded check-in time (e.g. '08:00').
  final String? checkinTime;

  /// Recorded check-out time (e.g. '17:00').
  final String? checkoutTime;

  /// Optional remark/note.
  final String? note;

  /// Backend late warning indicator for factory shifts.
  final bool? lateWarning;

  /// Backend early warning indicator for factory shifts.
  final bool? earlyWarning;

  bool get hasWorked => validActualTime > 0 || actualWorkTime > 0;
  bool get hasLeave => leaveTime > 0;
  bool get hasOvertime => overtime > 0;
  bool get isLate => lateWarning ?? (late > 0);
  bool get isEarly => earlyWarning ?? (early > 0);

  /// True if timesheet is explicitly rejected by manager/admin.
  bool get isRejected {
    if (isConfirmed) return false;
    final n = note?.toLowerCase() ?? '';
    return n.contains('từ chối') || n.contains('reject');
  }

  /// Extracts the rejection reason from note if present.
  String? get rejectReason {
    if (!isRejected || note == null) return null;
    final n = note!;
    if (n.contains(']')) {
      final parts = n.split(']');
      final reasonPart = parts.sublist(1).join(']').split('|')[0].trim();
      if (reasonPart.isNotEmpty) return reasonPart;
    }
    return n;
  }

  AccountTimesheetEntity copyWith({
    DateTime? workDate,
    double? actualWorkTime,
    double? validActualTime,
    double? lunch,
    double? extendedTime,
    double? leaveTime,
    double? overtime,
    double? overtimeScale,
    bool? isConfirmed,
    double? late,
    double? early,
    String? checkinTime,
    String? checkoutTime,
    String? note,
    bool? lateWarning,
    bool? earlyWarning,
  }) {
    return AccountTimesheetEntity(
      workDate: workDate ?? this.workDate,
      actualWorkTime: actualWorkTime ?? this.actualWorkTime,
      validActualTime: validActualTime ?? this.validActualTime,
      lunch: lunch ?? this.lunch,
      extendedTime: extendedTime ?? this.extendedTime,
      leaveTime: leaveTime ?? this.leaveTime,
      overtime: overtime ?? this.overtime,
      overtimeScale: overtimeScale ?? this.overtimeScale,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      late: late ?? this.late,
      early: early ?? this.early,
      checkinTime: checkinTime ?? this.checkinTime,
      checkoutTime: checkoutTime ?? this.checkoutTime,
      note: note ?? this.note,
      lateWarning: lateWarning ?? this.lateWarning,
      earlyWarning: earlyWarning ?? this.earlyWarning,
    );
  }

  @override
  List<Object?> get props => [
        workDate,
        actualWorkTime,
        validActualTime,
        lunch,
        extendedTime,
        leaveTime,
        overtime,
        overtimeScale,
        isConfirmed,
        late,
        early,
        checkinTime,
        checkoutTime,
        note,
        lateWarning,
        earlyWarning,
      ];
}
