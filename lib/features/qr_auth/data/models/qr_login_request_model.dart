import 'package:vstech_hrm/features/qr_auth/domain/entities/qr_login_request_entity.dart';

class QrLoginRequestModel {
  const new({
    required this.sessionId,
    required this.browser,
    required this.device,
    required this.ipAddress,
    required this.location,
    required this.requestTime,
    required this.expiresAt,
    required this.status,
  });

  factory fromJson(Map<String, dynamic> json) {
    return QrLoginRequestModel(
      sessionId: json['sessionId'] as String,
      browser: json['browser'] as String? ?? 'Chrome 122.0',
      device: json['device'] as String? ?? 'Máy trạm nội bộ',
      ipAddress: json['ipAddress'] as String? ?? '14.161.45.102',
      location: json['location'] as String? ?? 'Nhà máy VSTech Tân Bình, TP.HCM',
      requestTime: DateTime.parse(json['requestTime'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      status: QrSessionStatus.fromString(json['status'] as String?),
    );
  }

  final String sessionId;
  final String browser;
  final String device;
  final String ipAddress;
  final String location;
  final DateTime requestTime;
  final DateTime expiresAt;
  final QrSessionStatus status;

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'browser': browser,
        'device': device,
        'ipAddress': ipAddress,
        'location': location,
        'requestTime': requestTime.toIso8601String(),
        'expiresAt': expiresAt.toIso8601String(),
        'status': status.name,
      };

  QrLoginRequestEntity toEntity() => QrLoginRequestEntity(
        sessionId: sessionId,
        browser: browser,
        device: device,
        ipAddress: ipAddress,
        location: location,
        requestTime: requestTime,
        expiresAt: expiresAt,
        status: status,
      );
}
