import 'package:equatable/equatable.dart';

/// Pure domain entity for leave request item.
class LeaveItemEntity extends Equatable {
  const new({
    required this.code,
    required this.leavePlan,
    required this.statusText,
    required this.status,
    this.from,
    this.to,
    this.validFrom,
    this.validTo,
    this.note,
    this.confirmBy,
    this.halfShiftType,
  });

  final String code;
  final String leavePlan;
  final String statusText;
  final int status;
  final String? from;
  final String? to;
  final String? validFrom;
  final String? validTo;
  final String? note;
  final String? confirmBy;
  final String? halfShiftType;

  bool get isPending => status == 0;
  bool get isApproved => status == 1;
  bool get isRejected => status == 2;

  @override
  List<Object?> get props => [
        code,
        leavePlan,
        statusText,
        status,
        from,
        to,
        validFrom,
        validTo,
        note,
        confirmBy,
        halfShiftType,
      ];
}
