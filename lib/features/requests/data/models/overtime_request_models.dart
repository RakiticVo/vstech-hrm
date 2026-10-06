import 'package:equatable/equatable.dart';

/// DTO mapping to OvertimeRequestSelfItem from OpenAPI 3.0.1 (docs/api/api-1.json).
class OvertimeRequestSelfItemModel extends Equatable {
  const new({
    required this.code,
    this.status = 0,
    this.statusText = 'Chờ duyệt',
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
  });

  factory fromJson(Map<String, dynamic> json) {
    return OvertimeRequestSelfItemModel(
      code: json['code']?.toString() ?? '',
      status: json['status'] is int ? json['status'] as int : 0,
      statusText: json['statusText']?.toString() ?? 'Chờ duyệt',
      employeeName: json['employeeName']?.toString(),
      sentDate: json['sentDate']?.toString(),
      date: json['date']?.toString(),
      confirmedBy: json['confirmedBy']?.toString(),
      confirmByDate: json['confirmByDate']?.toString(),
      timeRange: json['timeRange']?.toString(),
      overtimeTypeCode: json['overtimeTypeCode']?.toString(),
      overtimeTypeName: json['overtimeTypeName']?.toString(),
      length: (json['length'] as num?)?.toDouble(),
      overtimeReason: json['overtimeReason']?.toString(),
      note: json['note']?.toString(),
      isLock: json['isLock'] as bool? ?? false,
    );
  }

  final String code;
  final int status;
  final String statusText;
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
  });

  final String employeeCode;
  final String date;
  final double length;
  final String? overtimeTypeCode;
  final String? startOvertime;
  final String? endOvertime;
  final String? note;
  final String? overtimeReasonCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'employeeCode': employeeCode,
      'date': date,
      'length': length,
    };
    if (overtimeTypeCode != null) map['overtimeTypeCode'] = overtimeTypeCode;
    if (startOvertime != null) map['startOvertime'] = startOvertime;
    if (endOvertime != null) map['endOvertime'] = endOvertime;
    if (note != null) map['note'] = note;
    if (overtimeReasonCode != null) map['overtimeReasonCode'] = overtimeReasonCode;
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
      ];
}

/// DTO mapping to OvertimeType from OpenAPI 3.0.1 (docs/api/api-1.json).
class OvertimeTypeModel extends Equatable {
  const OvertimeTypeModel({
    required this.code,
    required this.name,
    this.scale = 1.5,
  });

  factory OvertimeTypeModel.fromJson(Map<String, dynamic> json) {
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

