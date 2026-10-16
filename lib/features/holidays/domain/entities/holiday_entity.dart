import 'package:equatable/equatable.dart';

/// Pure domain entity for holiday.
class HolidayEntity extends Equatable {
  const new({
    required this.code,
    required this.name,
    required this.date,
    this.symbol,
    this.isActive = true,
    this.scale = 1.0,
  });

  final String code;
  final String name;
  final String date;
  final String? symbol;
  final bool isActive;
  final double scale;

  @override
  List<Object?> get props => [code, name, date, symbol, isActive, scale];
}
