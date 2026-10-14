import 'package:equatable/equatable.dart';

/// Pure domain entity for overtime request item.
class OvertimeItemEntity extends Equatable {
  const new({
    required this.code,
    required this.statusText,
    required this.status,
    required this.isLock,
    this.employeeName,
    this.employeeCode,
    this.date,
    this.timeRange,
    this.length,
    this.overtimeTypeCode,
    this.overtimeTypeName,
    this.overtimeReason,
    this.note,
    this.createdByCode,
    this.createdByName,
    this.shiftName,
    this.confirmedBy,
  });

  final String code;
  final String statusText;
  final int status;
  final bool isLock;
  final String? employeeName;
  final String? employeeCode;
  final String? date;
  final String? timeRange;
  final double? length;
  final String? overtimeTypeCode;
  final String? overtimeTypeName;
  final String? overtimeReason;
  final String? note;
  final String? createdByCode;
  final String? createdByName;
  final String? shiftName;
  final String? confirmedBy;

  bool get canDelete => status != 1 && !isLock;
  bool get isPending => status == 0;
  bool get isApproved => status == 1;
  bool get isRejected => status == 2;
  bool get isCreatedByOther => createdByCode != null && createdByCode != employeeCode;

  @override
  List<Object?> get props => [
        code,
        statusText,
        status,
        isLock,
        employeeName,
        employeeCode,
        date,
        timeRange,
        length,
        overtimeTypeCode,
        overtimeTypeName,
        overtimeReason,
        note,
        createdByCode,
        createdByName,
        shiftName,
        confirmedBy,
      ];
}
