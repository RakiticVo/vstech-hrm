import 'package:equatable/equatable.dart';

/// Pure domain entity representing a Leave Plan (loại nghỉ phép).
class LeavePlanEntity extends Equatable {
  const new({
    required this.code,
    required this.name,
    this.symbol,
    this.amount,
    this.validFrom,
    this.validTo,
  });

  final String code;
  final String name;
  final String? symbol;
  final double? amount;
  final String? validFrom;
  final String? validTo;

  @override
  List<Object?> get props => [code, name, symbol, amount, validFrom, validTo];
}
