import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/attendance/data/models/account_enrollment_model.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/timesheet_detail_entity.dart';

/// DTO Data Model for TimesheetDetailDoc from OpenAPI 3.0.1 (GET /api/TimeSheets/{id}).
class TimesheetDetailModel extends Equatable {
  const TimesheetDetailModel({
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

  factory TimesheetDetailModel.fromJson(Map<String, dynamic> json) {
    final item = json['item'] is Map<String, dynamic> ? json['item'] as Map<String, dynamic> : json;
    final rawIn = item['checkinTime']?.toString();
    final rawOut = item['checkoutTime']?.toString();
    final dateStr = item['workDate']?.toString() ?? json['workDate']?.toString();
    final localIn = AccountEnrollmentModel.formatLocalTimeStr(
            AccountEnrollmentModel.parseServerUtcDateTime(dateStr, rawIn)) ??
        rawIn;
    final localOut = AccountEnrollmentModel.formatLocalTimeStr(
            AccountEnrollmentModel.parseServerUtcDateTime(dateStr, rawOut)) ??
        rawOut;

    return TimesheetDetailModel(
      code: item['code']?.toString() ?? json['code']?.toString(),
      workDate: item['workDate']?.toString(),
      shiftName: item['shiftName']?.toString(),
      checkinTime: localIn,
      checkoutTime: localOut,
      actualWorkTime: (item['actualWorkTime'] as num?)?.toDouble() ?? 0.0,
      validActualTime: (item['validActualTime'] as num?)?.toDouble() ?? 0.0,
      lateHours: (item['late'] as num?)?.toDouble() ?? 0.0,
      earlyHours: (item['early'] as num?)?.toDouble() ?? 0.0,
      isConfirmed: item['isConfirmed'] == true,
      sumText: json['sumText']?.toString(),
      overtimeSlip: json['phieu_lam_them_str']?.toString() ?? json['phieu_lam_them']?.toString(),
      confirmRequestId: (json['confirmRequestId'] as num?)?.toInt(),
      leaveSlip: json['leaveRequest']?.toString(),
      businessSlip: json['businessRequest']?.toString(),
      note: item['note']?.toString(),
    );
  }

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

  TimesheetDetailEntity toEntity() => TimesheetDetailEntity(
        code: code,
        workDate: workDate,
        shiftName: shiftName,
        checkinTime: checkinTime,
        checkoutTime: checkoutTime,
        actualWorkTime: actualWorkTime,
        validActualTime: validActualTime,
        lateHours: lateHours,
        earlyHours: earlyHours,
        isConfirmed: isConfirmed,
        sumText: sumText,
        overtimeSlip: overtimeSlip,
        confirmRequestId: confirmRequestId,
        leaveSlip: leaveSlip,
        businessSlip: businessSlip,
        note: note,
      );

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
