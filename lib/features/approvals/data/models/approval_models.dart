import 'package:equatable/equatable.dart';

/// DTO command for ConfirmTimesheetConfirmRequestCommand in OpenAPI 3.0.1.
class TimesheetConfirmApproveCommand extends Equatable {
  const new({
    this.confirmedWorktime,
    this.confirmNote,
  });

  final double? confirmedWorktime;
  final String? confirmNote;

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (confirmedWorktime != null) 'confirmedWorktime': confirmedWorktime,
        if (confirmNote != null) 'confirmNote': confirmNote,
      };

  @override
  List<Object?> get props => [confirmedWorktime, confirmNote];
}

/// DTO for ServiceResultResponse in OpenAPI 3.0.1 (common response for accept/deny actions).
class ServiceResultResponseModel extends Equatable {
  const new({this.message});

  factory fromJson(Map<String, dynamic> json) {
    return ServiceResultResponseModel(
      message: json['message']?.toString(),
    );
  }

  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Request type category enumeration for Manager Approvals.
enum ApprovalCategory {
  leave,
  overtime,
  correction,
  timesheet,
  businessTrip,
  swap,
}

/// DTO model for AdminConfirmTimesheet in OpenAPI 3.0.1 (POST /api/TimeSheets/admin-confirm-timesheet).
class AdminConfirmTimesheetCommand extends Equatable {
  const new({
    this.employeeCode,
    this.workDate,
    this.validActualTime,
    this.overtime = 0.0,
    this.validOvertime = 0.0,
  });

  final String? employeeCode;
  final String? workDate;
  final double? validActualTime;
  final double? overtime;
  final double? validOvertime;

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (employeeCode != null) 'employeeCode': employeeCode,
        if (workDate != null) 'workDate': workDate,
        if (validActualTime != null) 'validActualTime': validActualTime,
        'overtime': overtime ?? 0.0,
        'validOvertime': validOvertime ?? 0.0,
      };

  @override
  List<Object?> get props => [employeeCode, workDate, validActualTime, overtime, validOvertime];
}

/// DTO command for RejectTimesheet in OpenAPI 3.0.1 (POST /api/TimeSheets/reject-timesheet).
class RejectTimesheetCommand extends Equatable {
  const new({
    required this.reason,
    this.employeeCode,
    this.workDate,
  });

  final String? employeeCode;
  final String? workDate;
  final String reason;

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (employeeCode != null) 'employeeCode': employeeCode,
        if (workDate != null) 'workDate': workDate,
        'reason': reason,
      };

  @override
  List<Object?> get props => [employeeCode, workDate, reason];
}

/// DTO for TimesheetMobileItemDoc in OpenAPI 3.0.1 (GET /api/TimeSheets/mobile).
class TimesheetMobileItemModel extends Equatable {
  const new({
    this.code,
    this.employeeCode,
    this.employee,
    this.department,
    this.actualWorkTime,
    this.validActualTime,
    this.overtime,
    this.leaveTime,
    this.shiftHour,
    this.staticSymbol,
    this.isConfirmed = false,
    this.isConfirmText,
    this.hasPendingConfirmRequest = false,
    this.workDate,
    this.workDateRaw,
    this.note,
  });

  factory fromJson(Map<String, dynamic> json) {
    return TimesheetMobileItemModel(
      code: json['code']?.toString(),
      employeeCode: json['employeeCode']?.toString(),
      employee: json['employee']?.toString(),
      department: json['department']?.toString(),
      actualWorkTime: (json['actualWorkTime'] as num?)?.toDouble(),
      validActualTime: (json['validActualTime'] as num?)?.toDouble(),
      overtime: (json['overtime'] as num?)?.toDouble(),
      leaveTime: (json['leaveTime'] as num?)?.toDouble(),
      shiftHour: (json['shiftHour'] as num?)?.toDouble(),
      staticSymbol: json['staticSymbol']?.toString(),
      isConfirmed: json['isConfirmed'] == true,
      isConfirmText: json['isConfirmText']?.toString(),
      hasPendingConfirmRequest: json['hasPendingConfirmRequest'] == true,
      workDate: json['workDate']?.toString(),
      workDateRaw: json['workDateRaw']?.toString(),
      note: json['note']?.toString(),
    );
  }

  final String? code;
  final String? employeeCode;
  final String? employee;
  final String? department;
  final double? actualWorkTime;
  final double? validActualTime;
  final double? overtime;
  final double? leaveTime;
  final double? shiftHour;
  final String? staticSymbol;
  final bool isConfirmed;
  final String? isConfirmText;
  final bool hasPendingConfirmRequest;
  final String? workDate;
  final String? workDateRaw;
  final String? note;

  @override
  List<Object?> get props => [
        code,
        employeeCode,
        employee,
        department,
        actualWorkTime,
        validActualTime,
        overtime,
        leaveTime,
        shiftHour,
        staticSymbol,
        isConfirmed,
        isConfirmText,
        hasPendingConfirmRequest,
        workDate,
        workDateRaw,
        note,
      ];
}
