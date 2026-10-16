import 'package:equatable/equatable.dart';

/// Pure domain entity representing detailed timesheet day record.
/// Mapped from GET /api/TimeSheets/{id}.
class TimesheetDetailEntity extends Equatable {
  const new({
    this.code,
    this.workDate,
    this.shiftName,
    this.checkinTime,
    this.checkoutTime,
    this.actualWorkTime = 0.0,
    this.validActualTime = 0.0,
    this.lateHours = 0.0,
    this.earlyHours = 0.0,
    this.isConfirmed = false,
    this.sumText,
    this.overtimeSlip,
    this.confirmRequestId,
    this.leaveSlip,
    this.businessSlip,
    this.note,
  });

  final String? code;
  final String? workDate;
  final String? shiftName;
  final String? checkinTime;
  final String? checkoutTime;
  final double actualWorkTime;
  final double validActualTime;
  final double lateHours;
  final double earlyHours;
  final bool isConfirmed;
  final String? sumText;
  final String? overtimeSlip;
  final int? confirmRequestId;
  final String? leaveSlip;
  final String? businessSlip;
  final String? note;

  @override
  List<Object?> get props => [
        code,
        workDate,
        shiftName,
        checkinTime,
        checkoutTime,
        actualWorkTime,
        validActualTime,
        lateHours,
        earlyHours,
        isConfirmed,
        sumText,
        overtimeSlip,
        confirmRequestId,
        leaveSlip,
        businessSlip,
        note,
      ];
}
