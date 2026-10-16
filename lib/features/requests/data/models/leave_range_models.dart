import 'package:equatable/equatable.dart';

/// DTO for POST /api/LeaveRequests/range and /api/LeaveRequests/validate.
class LeaveRangeRequestModel extends Equatable {
  const new({
    required this.from,
    required this.to,
    this.leavePlanCode,
    this.leaveAmountType = 1.0,
    this.halfShiftType,
    this.note,
    this.validFrom,
    this.validTo,
  });

  final String from;
  final String to;
  final String? leavePlanCode;
  final double leaveAmountType;
  final String? halfShiftType;
  final String? note;
  final String? validFrom;
  final String? validTo;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'from': from,
        'to': to,
        if (leavePlanCode != null) 'leavePlanCode': leavePlanCode,
        'leaveAmountType': leaveAmountType,
        if (halfShiftType != null) 'halfShiftType': halfShiftType,
        if (note != null) 'note': note,
        if (validFrom != null) 'validFrom': validFrom,
        if (validTo != null) 'validTo': validTo,
      };

  @override
  List<Object?> get props => [
        from,
        to,
        leavePlanCode,
        leaveAmountType,
        halfShiftType,
        note,
        validFrom,
        validTo,
      ];
}

/// DTO representing each day's status in LeaveRangeResult.
class LeaveRangeDayModel extends Equatable {
  const new({
    this.date,
    this.status,
    this.amount = 0.0,
    this.message,
  });

  factory fromJson(Map<String, dynamic> json) {
    return LeaveRangeDayModel(
      date: json['date']?.toString(),
      status: json['status']?.toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      message: json['message']?.toString(),
    );
  }

  final String? date;
  final String? status;
  final double amount;
  final String? message;

  bool get isOk => status?.toUpperCase() == 'OK';
  bool get isOff => status?.toUpperCase() == 'OFF';
  bool get isError => status?.toUpperCase() == 'ERROR';

  Map<String, dynamic> toJson() => <String, dynamic>{
        'date': date,
        'status': status,
        'amount': amount,
        'message': message,
      };

  @override
  List<Object?> get props => [date, status, amount, message];
}

/// DTO for the response of POST /api/LeaveRequests/validate.
class LeaveRangeResultModel extends Equatable {
  const new({
    required this.canCreate,
    this.totalAmount = 0.0,
    this.countedDays = 0,
    this.available,
    this.message,
    this.days = const [],
  });

  factory fromJson(Map<String, dynamic> json) {
    final rawDays = json['days'];
    final parsedDays = rawDays is List
        ? rawDays
            .whereType<Map<String, dynamic>>()
            .map(LeaveRangeDayModel.fromJson)
            .toList()
        : <LeaveRangeDayModel>[];

    return LeaveRangeResultModel(
      canCreate: json['canCreate'] as bool? ?? false,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      countedDays: (json['countedDays'] as num?)?.toInt() ?? 0,
      available: (json['available'] as num?)?.toDouble(),
      message: json['message']?.toString(),
      days: parsedDays,
    );
  }

  final bool canCreate;
  final double totalAmount;
  final int countedDays;
  final double? available;
  final String? message;
  final List<LeaveRangeDayModel> days;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'canCreate': canCreate,
        'totalAmount': totalAmount,
        'countedDays': countedDays,
        'available': available,
        'message': message,
        'days': days.map((d) => d.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        canCreate,
        totalAmount,
        countedDays,
        available,
        message,
        days,
      ];
}
