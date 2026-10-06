import 'package:equatable/equatable.dart';

/// DTO mapping to LeaveRequestResponse from OpenAPI 3.0.1 (docs/api/api-1.json).
class LeaveRequestResponseItem extends Equatable {
  const new({
    required this.code,
    this.leavePlanCode,
    this.leavePlan = 'Nghỉ phép',
    this.leaveAmountType,
    this.leaveAmountTypeText,
    this.employeeCode,
    this.employeeName,
    this.departmentName,
    this.sentDate,
    this.from,
    this.to,
    this.validFrom,
    this.validTo,
    this.confirmBy,
    this.confirmDate,
    this.status = 0,
    this.statusText = 'Chờ duyệt',
    this.halfShiftType,
    this.note,
  });

  factory fromJson(Map<String, dynamic> json) {
    return LeaveRequestResponseItem(
      code: json['code']?.toString() ?? '',
      leavePlanCode: json['leavePlanCode']?.toString(),
      leavePlan: json['leavePlan']?.toString() ?? 'Nghỉ phép',
      leaveAmountType: (json['leaveAmountType'] as num?)?.toDouble(),
      leaveAmountTypeText: json['leaveAmountTypeText']?.toString(),
      employeeCode: json['employeeCode']?.toString(),
      employeeName: json['employeeName']?.toString(),
      departmentName: json['departmentName']?.toString(),
      sentDate: json['sentDate']?.toString(),
      from: json['from']?.toString(),
      to: json['to']?.toString(),
      validFrom: json['validFrom']?.toString() ?? json['from']?.toString(),
      validTo: json['validTo']?.toString() ?? json['to']?.toString(),
      confirmBy: json['confirmBy']?.toString(),
      confirmDate: json['confirmDate']?.toString(),
      status: json['status'] is int ? json['status'] as int : 0,
      statusText: json['statusText']?.toString() ?? 'Chờ duyệt',
      halfShiftType: json['halfShiftType']?.toString(),
      note: json['note']?.toString(),
    );
  }

  final String code;
  final String? leavePlanCode;
  final String leavePlan;
  final double? leaveAmountType;
  final String? leaveAmountTypeText;
  final String? employeeCode;
  final String? employeeName;
  final String? departmentName;
  final String? sentDate;
  final String? from;
  final String? to;
  final String? validFrom;
  final String? validTo;
  final String? confirmBy;
  final String? confirmDate;
  final int status;
  final String statusText;
  final String? halfShiftType;
  final String? note;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'leavePlanCode': leavePlanCode,
        'leavePlan': leavePlan,
        'leaveAmountType': leaveAmountType,
        'leaveAmountTypeText': leaveAmountTypeText,
        'employeeCode': employeeCode,
        'employeeName': employeeName,
        'departmentName': departmentName,
        'sentDate': sentDate,
        'from': from,
        'to': to,
        'validFrom': validFrom,
        'validTo': validTo,
        'confirmBy': confirmBy,
        'confirmDate': confirmDate,
        'status': status,
        'statusText': statusText,
        'halfShiftType': halfShiftType,
        'note': note,
      };

  @override
  List<Object?> get props => [
        code,
        leavePlanCode,
        leavePlan,
        leaveAmountType,
        employeeCode,
        from,
        to,
        validFrom,
        validTo,
        status,
        statusText,
        halfShiftType,
      ];
}

/// DTO mapping to LeaveRequestCreate from OpenAPI 3.0.1 (docs/api/api-1.json).
class LeaveRequestCreateCommand extends Equatable {
  const new({
    required this.from,
    required this.to,
    this.employeeCode,
    this.departmentCode,
    this.shiftCode,
    this.leavePlanCode,
    this.leaveAmountType,
    this.halfShiftType,
    this.note,
    this.validFrom,
    this.validTo,
    this.isMultiple = false,
  });

  final String from;
  final String to;
  final String? employeeCode;
  final String? departmentCode;
  final String? shiftCode;
  final String? leavePlanCode;
  final String? leaveAmountType;
  final String? halfShiftType;
  final String? note;
  final String? validFrom;
  final String? validTo;
  final bool isMultiple;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'from': from,
      'to': to,
      'halfShiftType': halfShiftType,
      'isMultiple': isMultiple,
      'leaveAmountType': leaveAmountType ?? '1',
      'leavePlanCode': leavePlanCode,
      'note': note ?? '',
      'validFrom': validFrom,
      'validTo': validTo,
    };
    if (employeeCode != null && employeeCode!.isNotEmpty) {
      map['employeeCode'] = employeeCode;
    }
    if (departmentCode != null) map['departmentCode'] = departmentCode;
    if (shiftCode != null) map['shiftCode'] = shiftCode;
    return map;
  }

  @override
  List<Object?> get props => [
        from,
        to,
        employeeCode,
        validFrom,
        validTo,
        departmentCode,
        leavePlanCode,
        shiftCode,
        leaveAmountType,
        halfShiftType,
        note,
        isMultiple,
      ];
}

/// DTO mapping to LeavePlan from OpenAPI 3.0.1 (docs/api/api-1.json).
class LeavePlanModel extends Equatable {
  const LeavePlanModel({
    required this.code,
    required this.name,
    this.symbol,
    this.amount,
    this.validFrom,
    this.validTo,
  });

  factory LeavePlanModel.fromJson(Map<String, dynamic> json) {
    return LeavePlanModel(
      code: json['code']?.toString() ?? json['leavePlanCode']?.toString() ?? '',
      name: json['name']?.toString() ?? json['leavePlanName']?.toString() ?? json['description']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? json['staticSymbol']?.toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? (json['leaveAmountType'] as num?)?.toDouble(),
      validFrom: json['validFrom']?.toString(),
      validTo: json['validTo']?.toString() ?? json['expiredDate']?.toString(),
    );
  }

  final String code;
  final String name;
  final String? symbol;
  final double? amount;
  final String? validFrom;
  final String? validTo;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'name': name,
        'symbol': symbol,
        'amount': amount,
        'validFrom': validFrom,
        'validTo': validTo,
      };

  @override
  List<Object?> get props => [code, name, symbol, amount, validFrom, validTo];
}

