import 'package:equatable/equatable.dart';

/// Status of a web login request QR session.
enum QrSessionStatus {
  pending,
  approved,
  rejected,
  expired,
  used,
  invalid,
  cancelled;

  static QrSessionStatus fromString(String? val) {
    if (val == null) return QrSessionStatus.invalid;
    return switch (val.toLowerCase().trim()) {
      'pending' => QrSessionStatus.pending,
      'approved' => QrSessionStatus.approved,
      'rejected' => QrSessionStatus.rejected,
      'expired' => QrSessionStatus.expired,
      'used' => QrSessionStatus.used,
      'cancelled' => QrSessionStatus.cancelled,
      _ => QrSessionStatus.invalid,
    };
  }
}

/// Entity representing decoded login request information from a scanned QR code.
class QrLoginRequestEntity extends Equatable {
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

  final String sessionId;
  final String browser;
  final String device;
  final String ipAddress;
  final String location;
  final DateTime requestTime;
  final DateTime expiresAt;
  final QrSessionStatus status;

  bool get isExpired => DateTime.now().isAfter(expiresAt) || status == QrSessionStatus.expired;
  bool get isUsed => status == QrSessionStatus.used;
  bool get isCancelled => status == QrSessionStatus.cancelled;
  bool get isValid => status == QrSessionStatus.pending && !isExpired;

  int get remainingSeconds {
    final diff = expiresAt.difference(DateTime.now()).inSeconds;
    return diff > 0 ? diff : 0;
  }

  QrLoginRequestEntity copyWith({
    QrSessionStatus? status,
  }) {
    return QrLoginRequestEntity(
      sessionId: sessionId,
      browser: browser,
      device: device,
      ipAddress: ipAddress,
      location: location,
      requestTime: requestTime,
      expiresAt: expiresAt,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        sessionId,
        browser,
        device,
        ipAddress,
        location,
        requestTime,
        expiresAt,
        status,
      ];
}
