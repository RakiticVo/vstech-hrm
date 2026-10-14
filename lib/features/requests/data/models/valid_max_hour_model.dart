import 'package:vstech_hrm/features/requests/domain/entities/valid_max_hour_entity.dart';

/// DTO Data Model for ValidMaxHourDoc in OpenAPI 3.0.1 (GET /api/OvertimeRequests/valid-max-hour).
class ValidMaxHourModel {
  const new({
    required this.maxHour,
    required this.isLock,
    this.message,
  });

  factory fromJson(Map<String, dynamic> json) {
    return ValidMaxHourModel(
      maxHour: (json['maxHour'] as num?)?.toDouble() ?? 18.0,
      isLock: json['isLock'] == true,
      message: json['message']?.toString(),
    );
  }

  final double maxHour;
  final bool isLock;
  final String? message;

  ValidMaxHourEntity toEntity() => ValidMaxHourEntity(
        maxHour: maxHour,
        isLock: isLock,
        message: message,
      );
}
