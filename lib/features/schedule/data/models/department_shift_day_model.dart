import 'package:vstech_hrm/features/schedule/domain/entities/department_shift_day_entity.dart';

/// DTO model for DepartmentShiftDayDoc in OpenAPI 3.0.1 (GET /api/ShiftSchedules).
class DepartmentShiftDayModel {
  const new({
    required this.employeeCode,
    required this.employeeName,
    required this.date,
    this.shiftCode,
    this.shiftName,
    this.createdBy,
    this.createdAt,
  });

  factory fromJson(Map<String, dynamic> json) {
    return DepartmentShiftDayModel(
      employeeCode: json['employeeCode']?.toString() ?? '',
      employeeName: json['employeeName']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      shiftCode: json['shiftCode']?.toString(),
      shiftName: json['shiftName']?.toString(),
      createdBy: json['createdBy']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  final String employeeCode;
  final String employeeName;
  final String date;
  final String? shiftCode;
  final String? shiftName;
  final String? createdBy;
  final String? createdAt;

  DepartmentShiftDayEntity toEntity() {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(date);
    } on Object catch (_) {
      parsedDate = DateTime.now();
    }

    return DepartmentShiftDayEntity(
      employeeCode: employeeCode,
      employeeName: employeeName,
      date: parsedDate,
      shiftCode: shiftCode,
      shiftName: shiftName,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }
}
