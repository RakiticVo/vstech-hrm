import 'dart:convert';
import 'package:vstech_hrm/features/qr_auth/data/models/qr_login_request_model.dart';
import 'package:vstech_hrm/features/qr_auth/domain/entities/qr_login_request_entity.dart';

abstract class QrAuthDataSource {
  Future<QrLoginRequestModel> parseQrPayload(String rawPayload);
  Future<bool> approveLogin(String sessionId, {required String authMethod});
  Future<bool> rejectLogin(String sessionId);
}

class QrAuthMockDataSource implements QrAuthDataSource {
  final Set<String> _usedSessions = {'qr_used_demo_01'};

  @override
  Future<QrLoginRequestModel> parseQrPayload(String rawPayload) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final trimmed = rawPayload.trim();

    if (trimmed.isEmpty || (!trimmed.startsWith('vstech://') && !trimmed.startsWith('{') && !trimmed.startsWith('QR_'))) {
      throw const FormatException('Mã QR không thuộc hệ thống VSTech hoặc sai định dạng.');
    }

    // 1. Check for explicit error flags
    if (trimmed.contains('invalid') || trimmed == 'QR_INVALID_TEST') {
      throw const FormatException('Mã QR không hợp lệ.');
    }

    final now = DateTime.now();

    if (trimmed.contains('expired') || trimmed == 'QR_EXPIRED_TEST') {
      return QrLoginRequestModel(
        sessionId: 'sess_exp_${now.millisecondsSinceEpoch}',
        browser: 'Google Chrome 122.0 (Windows 11)',
        device: 'Máy tính trạm Xưởng 1 (PC-ENG-04)',
        ipAddress: '14.161.45.102',
        location: 'Nhà máy VSTech Tân Bình, TP.HCM',
        requestTime: now.subtract(const Duration(minutes: 12)),
        expiresAt: now.subtract(const Duration(minutes: 7)),
        status: QrSessionStatus.expired,
      );
    }

    if (trimmed.contains('used') || trimmed == 'QR_USED_TEST' || _usedSessions.contains(trimmed)) {
      return QrLoginRequestModel(
        sessionId: 'sess_used_8921',
        browser: 'Firefox 123.0 (macOS Sonoma)',
        device: 'Máy bàn Quản lý Phân xưởng (PC-MGR-02)',
        ipAddress: '14.161.45.108',
        location: 'Nhà máy VSTech Tân Bình, TP.HCM',
        requestTime: now.subtract(const Duration(minutes: 5)),
        expiresAt: now.add(const Duration(minutes: 2)),
        status: QrSessionStatus.used,
      );
    }

    if (trimmed.contains('cancelled') || trimmed == 'QR_CANCELLED_TEST') {
      return QrLoginRequestModel(
        sessionId: 'sess_can_4421',
        browser: 'Microsoft Edge 121.0 (Windows 10)',
        device: 'Kiosk chấm công Cổng 2 (KIOSK-GATE-02)',
        ipAddress: '14.161.45.15',
        location: 'Cổng số 2 - Nhà máy VSTech',
        requestTime: now.subtract(const Duration(minutes: 2)),
        expiresAt: now.add(const Duration(minutes: 3)),
        status: QrSessionStatus.cancelled,
      );
    }

    // 2. Parse JSON payload if applicable
    if (trimmed.startsWith('{')) {
      try {
        final map = jsonDecode(trimmed) as Map<String, dynamic>;
        return QrLoginRequestModel.fromJson(map);
      } on Object {
        // Fallback to valid model
      }
    }

    // 3. Normal fresh valid login session
    return QrLoginRequestModel(
      sessionId: 'sess_live_${now.millisecondsSinceEpoch}',
      browser: 'Google Chrome 122.0 (Windows 11)',
      device: 'Máy trạm Kỹ thuật Xưởng A (PC-TECH-01)',
      ipAddress: '14.161.45.102',
      location: 'Nhà máy VSTech Tân Bình, TP.HCM',
      requestTime: now,
      expiresAt: now.add(const Duration(minutes: 5)),
      status: QrSessionStatus.pending,
    );
  }

  @override
  Future<bool> approveLogin(String sessionId, {required String authMethod}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _usedSessions.add(sessionId);
    return true;
  }

  @override
  Future<bool> rejectLogin(String sessionId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _usedSessions.add(sessionId);
    return true;
  }
}
