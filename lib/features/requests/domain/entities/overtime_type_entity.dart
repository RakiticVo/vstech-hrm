import 'package:equatable/equatable.dart';

/// Pure domain entity representing an Overtime Type (loại tăng ca).
class OvertimeTypeEntity extends Equatable {
  const OvertimeTypeEntity({
    required this.code,
    required this.name,
    this.scale = 1.5,
  });

  final String code;
  final String name;
  final double scale;

  @override
  List<Object?> get props => [code, name, scale];
}
