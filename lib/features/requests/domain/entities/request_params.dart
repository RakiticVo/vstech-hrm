import 'package:equatable/equatable.dart';

class CreateLeaveParams extends Equatable {
  const new({
    required this.from,
    required this.to,
    this.employeeCode,
    this.validFrom,
    this.validTo,
    this.departmentCode,
    this.leavePlanCode,
    this.shiftCode,
    this.leaveAmountType,
    this.halfShiftType,
    this.note,
    this.isMultiple = false,
  });

  final String from;
  final String to;
  final String? employeeCode;
  final String? validFrom;
  final String? validTo;
  final String? departmentCode;
  final String? leavePlanCode;
  final String? shiftCode;
  final double? leaveAmountType;
  final String? halfShiftType;
  final String? note;
  final bool isMultiple;

  @override
  List<Object?> get props => [
        from,
        to,
        employeeCode,
        validFrom,
        validTo,
        leavePlanCode,
        halfShiftType,
        note,
        isMultiple,
      ];
}

class CreateOvertimeParams extends Equatable {
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

  @override
  List<Object?> get props => [
        employeeCode,
        date,
        length,
        overtimeTypeCode,
        note,
        adminEmployeeCode,
        accept,
      ];
}

class CreateCorrectionParams extends Equatable {
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

  @override
  List<Object?> get props => [employeeCode, workDate, worktime, reasonTypeCode, note, imageUrl];
}

class CorrectionReasonEntity extends Equatable {
  const new({
    required this.code,
    required this.name,
    this.mustHaveNote = false,
    this.mustHaveImage = false,
  });

  final String code;
  final String name;
  final bool mustHaveNote;
  final bool mustHaveImage;

  @override
  List<Object?> get props => [code, name, mustHaveNote, mustHaveImage];
}
