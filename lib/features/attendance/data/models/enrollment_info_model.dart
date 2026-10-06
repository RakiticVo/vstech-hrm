import 'package:equatable/equatable.dart';

/// DTO mapping to EnrollmentInfoItem from OpenAPI 3.0.1 (docs/api/api-1.json).
class EnrollmentInfoItemModel extends Equatable {
  const new({
    this.date,
    this.total,
    this.checkin,
    this.checkout,
    this.early,
    this.late,
  });

  factory fromJson(Map<String, dynamic> json) {
    return EnrollmentInfoItemModel(
      date: json['date']?.toString(),
      total: (json['total'] as num?)?.toDouble(),
      checkin: json['checkin']?.toString(),
      checkout: json['checkout']?.toString(),
      early: (json['early'] as num?)?.toDouble(),
      late: (json['late'] as num?)?.toDouble(),
    );
  }

  final String? date;
  final double? total;
  final String? checkin;
  final String? checkout;
  final double? early;
  final double? late;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'date': date,
        'total': total,
        'checkin': checkin,
        'checkout': checkout,
        'early': early,
        'late': late,
      };

  @override
  List<Object?> get props => [date, total, checkin, checkout, early, late];
}

/// DTO mapping to EnrollmentInfoTimesheet from OpenAPI 3.0.1 (docs/api/api-1.json).
class EnrollmentInfoTimesheetModel extends Equatable {
  const new({
    this.code,
    this.employeeCode,
    this.workDate,
    this.late,
    this.early,
    this.actualTime,
  });

  factory fromJson(Map<String, dynamic> json) {
    return EnrollmentInfoTimesheetModel(
      code: json['code']?.toString(),
      employeeCode: json['employeeCode']?.toString(),
      workDate: json['workDate']?.toString(),
      late: (json['late'] as num?)?.toDouble(),
      early: (json['early'] as num?)?.toDouble(),
      actualTime: (json['actualTime'] as num?)?.toDouble(),
    );
  }

  final String? code;
  final String? employeeCode;
  final String? workDate;
  final double? late;
  final double? early;
  final double? actualTime;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'employeeCode': employeeCode,
        'workDate': workDate,
        'late': late,
        'early': early,
        'actualTime': actualTime,
      };

  @override
  List<Object?> get props => [code, employeeCode, workDate, late, early, actualTime];
}

/// DTO mapping to EnrollmentInfoResponse from OpenAPI 3.0.1 (docs/api/api-1.json).
class EnrollmentInfoResponseModel extends Equatable {
  const new({
    this.timesheet,
    this.enroll = 'UNKNOWN',
    this.startShift = '08:00',
    this.startBreak,
    this.endBreak,
    this.endShift = '17:00',
    this.enrolls = const <EnrollmentInfoItemModel>[],
    this.isValidCheckIn = true,
    this.facialDisabled = false,
    this.serverTime,
  });

  factory fromJson(Map<String, dynamic> json) {
    return EnrollmentInfoResponseModel(
      timesheet: json['timesheet'] is Map<String, dynamic>
          ? EnrollmentInfoTimesheetModel.fromJson(json['timesheet'] as Map<String, dynamic>)
          : null,
      enroll: json['enroll']?.toString() ?? 'UNKNOWN',
      startShift: json['startShift']?.toString() ?? '08:00',
      startBreak: json['startBreak']?.toString(),
      endBreak: json['endBreak']?.toString(),
      endShift: json['endShift']?.toString() ?? '17:00',
      enrolls: (json['enrolls'] as List<dynamic>?)
              ?.map((dynamic e) => EnrollmentInfoItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <EnrollmentInfoItemModel>[],
      isValidCheckIn: json['isValidCheckIn'] as bool? ?? true,
      facialDisabled: json['facialDisabled'] as bool? ?? false,
      serverTime: json['serverTime']?.toString(),
    );
  }

  final EnrollmentInfoTimesheetModel? timesheet;
  final String enroll;
  final String startShift;
  final String? startBreak;
  final String? endBreak;
  final String endShift;
  final List<EnrollmentInfoItemModel> enrolls;
  final bool isValidCheckIn;
  final bool facialDisabled;
  final String? serverTime;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'timesheet': timesheet?.toJson(),
        'enroll': enroll,
        'startShift': startShift,
        'startBreak': startBreak,
        'endBreak': endBreak,
        'endShift': endShift,
        'enrolls': enrolls.map((e) => e.toJson()).toList(),
        'isValidCheckIn': isValidCheckIn,
        'facialDisabled': facialDisabled,
        'serverTime': serverTime,
      };

  @override
  List<Object?> get props => [
        timesheet,
        enroll,
        startShift,
        startBreak,
        endBreak,
        endShift,
        enrolls,
        isValidCheckIn,
        facialDisabled,
        serverTime,
      ];
}
