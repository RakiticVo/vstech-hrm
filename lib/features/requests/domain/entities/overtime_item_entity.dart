import 'package:equatable/equatable.dart';

/// Pure domain entity for overtime request item.
class OvertimeItemEntity extends Equatable {
  const new({
    required this.code,
    required this.statusText,
    required this.status,
    required this.isLock,
    this.date,
    this.timeRange,
    this.length,
    this.overtimeReason,
    this.note,
  });

  final String code;
  final String statusText;
  final int status;
  final bool isLock;
  final String? date;
  final String? timeRange;
  final double? length;
  final String? overtimeReason;
  final String? note;

  bool get canDelete => status != 1 && !isLock;
  bool get isPending => status == 0;
  bool get isApproved => status == 1;
  bool get isRejected => status == 2;

  @override
  List<Object?> get props => [
        code,
        statusText,
        status,
        isLock,
        date,
        timeRange,
        length,
        overtimeReason,
        note,
      ];
}
