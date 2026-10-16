import 'package:equatable/equatable.dart';

/// DTO mapping to OvertimeRequestSelfItem from OpenAPI 3.0.1 (docs/api/api-1.json).
class OvertimeRequestSelfItemModel extends Equatable {
  const new({
    required this.code,
    this.status = 0,
    this.statusText = 'Chờ duyệt',
    this.employeeCode,
    this.employeeName,
    this.sentDate,
    this.date,
    this.confirmedBy,
    this.confirmByDate,
    this.timeRange,
    this.overtimeTypeCode,
    this.overtimeTypeName,
    this.length,
    this.overtimeReason,
    this.note,
    this.isLock = false,
    this.createdByCode,
    this.createdByName,
    this.shiftCode,
    this.shiftName,
    this.shiftStart,
    this.shiftEnd,
  });

  factory fromJson(Map<String, dynamic> json) {
    return OvertimeRequestSelfItemModel(
      code: json['code']?.toString() ?? '',
      status: json['status'] is int ? json['status'] as int : 0,
      statusText: json['statusText']?.toString() ?? 'Chờ duyệt',
      employeeCode: json['employeeCode']?.toString(),
      employeeName: json['employee']?.toString() ?? json['employeeName']?.toString(),
      sentDate: json['sentDateStr']?.toString() ?? json['sentDate']?.toString(),
      date: json['dateStr']?.toString() ?? json['date']?.toString(),
      confirmedBy: json['confirmByCode']?.toString() ?? json['confirmedBy']?.toString(),
      confirmByDate: json['confirmDate']?.toString() ?? json['confirmByDate']?.toString(),
      timeRange: json['overtimeTimeStr']?.toString() ?? json['timeRange']?.toString(),
      overtimeTypeCode: json['overtimeTypeCode']?.toString(),
      overtimeTypeName: json['overtimeTypeName']?.toString() ??
          json['overtimeType']?.toString() ??
          json['typeName']?.toString(),
      length: (json['length'] as num?)?.toDouble(),
      overtimeReason: json['overtimeReason']?.toString(),
      note: json['note']?.toString(),
      isLock: json['isLock'] as bool? ?? false,
      createdByCode: json['createdByCode']?.toString(),
      createdByName: json['createdByName']?.toString(),
      shiftCode: json['shiftCode']?.toString(),
      shiftName: json['shiftName']?.toString(),
      shiftStart: json['shiftStart']?.toString(),
      shiftEnd: json['shiftEnd']?.toString(),
    );
  }

  final String code;
  final int status;
  final String statusText;
  final String? employeeCode;
  final String? employeeName;
  final String? sentDate;
  final String? date;
  final String? confirmedBy;
  final String? confirmByDate;
  final String? timeRange;
  final String? overtimeTypeCode;
  final String? overtimeTypeName;
  final double? length;
  final String? overtimeReason;
  final String? note;
  final bool isLock;
  final String? createdByCode;
  final String? createdByName;
  final String? shiftCode;
  final String? shiftName;
  final String? shiftStart;
  final String? shiftEnd;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'status': status,
        'statusText': statusText,
        'employeeName': employeeName,
        'sentDate': sentDate,
        'date': date,
        'confirmedBy': confirmedBy,
        'confirmByDate': confirmByDate,
        'timeRange': timeRange,
        'overtimeTypeCode': overtimeTypeCode,
        'overtimeTypeName': overtimeTypeName,
        'length': length,
        'overtimeReason': overtimeReason,
        'note': note,
        'isLock': isLock,
        'createdByCode': createdByCode,
        'createdByName': createdByName,
        'shiftCode': shiftCode,
        'shiftName': shiftName,
      };

  @override
  List<Object?> get props => [
        code,
        status,
        statusText,
        date,
        timeRange,
        length,
        overtimeReason,
        isLock,
        createdByCode,
        createdByName,
      ];
}

/// DTO mapping to OvertimeRequestVM from OpenAPI 3.0.1 (docs/api/api-1.json).
class OvertimeRequestCreateModel extends Equatable {
  const new({
    required this.employeeCode,
    required this.date,
    required this.length,
    this.overtimeTypeCode,
    this.startOvertime,
    this.endOvertime,
    this.note,
    this.overtimeReasonCode,
    this.adminEmployeeCode,
    this.accept,
  });

  final String employeeCode;
  final String date;
  final double length;
  final String? overtimeTypeCode;
  final String? startOvertime;
  final String? endOvertime;
  final String? note;
  final String? overtimeReasonCode;
  final String? adminEmployeeCode;
  final bool? accept;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'date': date,
      'length': length,
      'note': note ?? '',
    };
    if (adminEmployeeCode != null && adminEmployeeCode!.isNotEmpty) {
      map['adminEmployeeCode'] = adminEmployeeCode;
      if (accept != null) {
        map['accept'] = accept;
      }
    } else if (employeeCode.isNotEmpty) {
      map['employeeCode'] = employeeCode;
    }
    if (startOvertime != null) map['startOvertime'] = startOvertime;
    if (endOvertime != null) map['endOvertime'] = endOvertime;
    if (overtimeTypeCode != null && overtimeTypeCode!.toLowerCase() != 'default') {
      map['overtimeTypeCode'] = overtimeTypeCode;
    }
    return map;
  }

  @override
  List<Object?> get props => [
        employeeCode,
        date,
        length,
        overtimeTypeCode,
        startOvertime,
        endOvertime,
        note,
        adminEmployeeCode,
        accept,
      ];
}

/// DTO mapping to OvertimeType from OpenAPI 3.0.1 (docs/api/api-1.json).
class OvertimeTypeModel extends Equatable {
  const new({
    required this.code,
    required this.name,
    this.scale = 1.5,
  });

  factory fromJson(Map<String, dynamic> json) {
    return OvertimeTypeModel(
      code: json['code']?.toString() ?? json['overtimeTypeCode']?.toString() ?? '',
      name: json['name']?.toString() ?? json['overtimeTypeName']?.toString() ?? '',
      scale: (json['scale'] as num?)?.toDouble() ?? 1.5,
    );
  }

  final String code;
  final String name;
  final double scale;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'name': name,
        'scale': scale,
      };

  @override
  List<Object?> get props => [code, name, scale];
}
