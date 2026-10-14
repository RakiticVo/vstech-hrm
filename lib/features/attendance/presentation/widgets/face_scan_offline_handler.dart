import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/services/offline_attendance_service.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';

/// Helper to execute offline vector cosine matching and queue enrollment.
class FaceScanOfflineHandler {
  const new _();

  static Future<AttendanceRecordEntity?> processOfflinePunch({
    required BuildContext context,
    required AttendanceType type,
    required String employeeCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final baseline = await OfflineAttendanceService.getOrEnrollVector(employeeCode);
    final scan = OfflineAttendanceService.simulateScanVector(baseline);
    final score = OfflineAttendanceService.calculateSimilarity(baseline, scan);

    if (score >= OfflineAttendanceService.matchThreshold) {
      final record = OfflineAttendanceRecord(
        id: 'off_${DateTime.now().millisecondsSinceEpoch}',
        employeeCode: employeeCode,
        type: type,
        timestamp: DateTime.now(),
        latitude: 10.7769,
        longitude: 106.7009,
        similarityScore: score,
      );
      await OfflineAttendanceService.enqueueOfflinePunch(record);

      final pct = (score * 100).toStringAsFixed(1);
      if (context.mounted) {
        final l10n = context.l10n;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.offlineMatchSuccess(pct)),
            backgroundColor: const Color(0xFF0F766E),
          ),
        );
      }

      return AttendanceRecordEntity(
        id: record.id,
        timestamp: record.timestamp,
        type: type,
        classification: AttendanceClassification.onTime,
        locationName: 'Chấm công ngoại tuyến',
        lat: record.latitude,
        lng: record.longitude,
        note: 'Offline match $pct%',
      );
    } else {
      if (context.mounted) {
        final l10n = context.l10n;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.offlineMatchFailed),
            backgroundColor: const Color(0xFFE11D48),
          ),
        );
      }
      return null;
    }
  }
}
