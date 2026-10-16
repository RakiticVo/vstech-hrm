import 'package:equatable/equatable.dart';

/// DTO mapping to TimesheetConfirmRequestType from OpenAPI 3.0.1 (docs/api/api-1.json).
class CorrectionReasonTypeModel extends Equatable {
  const new({
    required this.code,
    required this.name,
    this.mustHaveNote = false,
    this.mustHaveImage = false,
    this.isActive = true,
  });

  factory fromJson(Map<String, dynamic> json) {
    return CorrectionReasonTypeModel(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      mustHaveNote: json['mustHaveNote'] as bool? ?? false,
      mustHaveImage: json['mustHaveImage'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  final String code;
  final String name;
  final bool mustHaveNote;
  final bool mustHaveImage;
  final bool isActive;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'name': name,
        'mustHaveNote': mustHaveNote,
        'mustHaveImage': mustHaveImage,
        'isActive': isActive,
      };

  @override
  List<Object?> get props => [code, name, mustHaveNote, mustHaveImage, isActive];
}

/// DTO mapping to CreateTimesheetConfirmRequestCommand from OpenAPI 3.0.1 (docs/api/api-1.json).
class CreateTimesheetCorrectionCommand extends Equatable {
  const new({
    required this.employeeCode,
    required this.workDate,
    required this.worktime,
    required this.reasonTypeCode,
    this.note,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.address,
  });

  final String employeeCode;
  final String workDate;
  final double worktime;
  final String reasonTypeCode;
  final String? note;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final String? address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'workDate': workDate,
      'reasonTypeCode': reasonTypeCode,
    };
    if (employeeCode.isNotEmpty) map['employeeCode'] = employeeCode;
    if (note != null && note!.trim().isNotEmpty) map['note'] = note!.trim();
    return map;
  }

  @override
  List<Object?> get props => [
        employeeCode,
        workDate,
        worktime,
        reasonTypeCode,
        note,
        imageUrl,
        latitude,
        longitude,
      ];
}

/// DTO mapping to TimesheetConfirmRequestQuery from OpenAPI 3.0.1 (docs/api/api-1.json).
class TimesheetCorrectionItemModel extends Equatable {
  const new({
    required this.id,
    this.employeeCode,
    this.employeeName,
    this.workDate,
    this.worktime,
    this.confirmedWorktime,
    this.note,
    this.imageUrl,
    this.reasonTypeName,
    this.confirmLevel = 0,
    this.isReject = false,
    this.isLock = false,
    this.confirmerName,
    this.shiftCode,
    this.shiftName,
    this.shiftStart,
    this.shiftEnd,
  });

  factory fromJson(Map<String, dynamic> json) {
    return TimesheetCorrectionItemModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      employeeCode: json['employeeCode']?.toString(),
      employeeName: json['employeeName']?.toString(),
      workDate: json['workDate']?.toString(),
      worktime: (json['worktime'] as num?)?.toDouble(),
      confirmedWorktime: (json['confirmedWorktime'] as num?)?.toDouble(),
      note: json['note']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      reasonTypeName: json['reasonTypeName']?.toString(),
      confirmLevel: json['confirmLevel'] is int ? json['confirmLevel'] as int : 0,
      isReject: json['isReject'] as bool? ?? false,
      isLock: json['isLock'] as bool? ?? false,
      confirmerName: json['hrManagerName']?.toString() ??
          json['hrAdminName']?.toString() ??
          json['managerName']?.toString() ??
          json['confirmByName']?.toString() ??
          json['confirmBy']?.toString(),
      shiftCode: json['shiftCode']?.toString(),
      shiftName: json['shiftName']?.toString(),
      shiftStart: json['shiftStart']?.toString(),
      shiftEnd: json['shiftEnd']?.toString(),
    );
  }

  final int id;
  final String? employeeCode;
  final String? employeeName;
  final String? workDate;
  final double? worktime;
  final double? confirmedWorktime;
  final String? note;
  final String? imageUrl;
  final String? reasonTypeName;
  final int confirmLevel;
  final bool isReject;
  final bool isLock;
  final String? confirmerName;
  final String? shiftCode;
  final String? shiftName;
  final String? shiftStart;
  final String? shiftEnd;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'employeeCode': employeeCode,
        'employeeName': employeeName,
        'workDate': workDate,
        'worktime': worktime,
        'confirmedWorktime': confirmedWorktime,
        'note': note,
        'imageUrl': imageUrl,
        'reasonTypeName': reasonTypeName,
        'confirmLevel': confirmLevel,
        'isReject': isReject,
        'isLock': isLock,
        'shiftCode': shiftCode,
        'shiftName': shiftName,
        'shiftStart': shiftStart,
        'shiftEnd': shiftEnd,
      };

  @override
  List<Object?> get props => [
        id,
        employeeCode,
        workDate,
        worktime,
        reasonTypeName,
        confirmLevel,
        isReject,
        isLock,
        shiftCode,
        shiftName,
        shiftStart,
        shiftEnd,
      ];
}
