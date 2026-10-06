import 'package:equatable/equatable.dart';

/// DTO for Holiday item from OpenAPI 3.0.1 (docs/api/api-1.json).
class HolidayModel extends Equatable {
  const new({
    required this.code,
    required this.name,
    required this.date,
    this.symbol,
    this.isActive = true,
    this.scale = 1.0,
  });

  factory fromJson(Map<String, dynamic> json) {
    return HolidayModel(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      symbol: json['symbol']?.toString(),
      isActive: json['isActive'] is bool ? json['isActive'] as bool : true,
      scale: (json['scale'] as num?)?.toDouble() ?? 1.0,
    );
  }

  final String code;
  final String name;
  final String date;
  final String? symbol;
  final bool isActive;
  final double scale;

  @override
  List<Object?> get props => [code, name, date, symbol, isActive, scale];
}
