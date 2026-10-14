import 'package:vstech_hrm/features/approvals/domain/entities/managed_employee_entity.dart';

/// DTO Data Model for ManagedEmployeeDoc in OpenAPI 3.0.1 (GET /api/TimeSheets/mobile-employees).
class ManagedEmployeeModel {
  const new({
    required this.code,
    required this.name,
    this.departmentCode,
    this.department,
    this.shiftCode,
    this.shiftName,
    this.shiftStart,
    this.shiftEnd,
  });

  factory fromJson(Map<String, dynamic> json) {
    return ManagedEmployeeModel(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      departmentCode: json['departmentCode']?.toString(),
      department: json['department']?.toString(),
      shiftCode: json['shiftCode']?.toString(),
      shiftName: json['shiftName']?.toString(),
      shiftStart: json['shiftStart']?.toString(),
      shiftEnd: json['shiftEnd']?.toString(),
    );
  }

  final String code;
  final String name;
  final String? departmentCode;
  final String? department;
  final String? shiftCode;
  final String? shiftName;
  final String? shiftStart;
  final String? shiftEnd;

  ManagedEmployeeEntity toEntity() => ManagedEmployeeEntity(
        code: code,
        name: name,
        departmentCode: departmentCode,
        department: department,
        shiftCode: shiftCode,
        shiftName: shiftName,
        shiftStart: shiftStart,
        shiftEnd: shiftEnd,
      );
}
