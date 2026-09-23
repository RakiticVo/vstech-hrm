import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/services/offline_attendance_service.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Card displaying an offline punch record with GPS distance and 5-state lifecycle chip.
class OfflineQueueRecordCard extends StatelessWidget {
  const new({
    required this.item,
    required this.onRetry,
    super.key,
  });

  final OfflineAttendanceRecord item;
  final VoidCallback onRetry;

  (String, Color, Color) _statusStyle(SyncStatus status) {
    return switch (status) {
      SyncStatus.recorded => ('Đã ghi nhận', const Color(0xFF2563EB), const Color(0xFFDBEAFE)),
      SyncStatus.pending => ('Chờ đồng bộ', const Color(0xFFD97706), const Color(0xFFFEF3C7)),
      SyncStatus.syncing => ('Đang đồng bộ', const Color(0xFF4F46E5), const Color(0xFFEEF2FF)),
      SyncStatus.synced => ('Đã đồng bộ', const Color(0xFF16A34A), const Color(0xFFDCFCE7)),
      SyncStatus.failed => ('Thất bại', const Color(0xFFDC2626), const Color(0xFFFEE2E2)),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final dateStr = DateFormat('dd/MM/yyyy • HH:mm:ss').format(item.timestamp);
    final (statusLabel, statusColor, statusBg) = _statusStyle(item.syncStatus);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.syncStatus == SyncStatus.failed
              ? colors.error.withValues(alpha: 0.5)
              : colors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item.type.isCheckIn
                      ? colors.pineGreen.withValues(alpha: 0.12)
                      : colors.amberGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.type.isCheckIn ? 'VÀO CA (IN)' : 'TAN CA (OUT)',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: item.type.isCheckIn ? colors.pineGreen : colors.amberGold,
                  ),
                ),
              ),
              8.gapW,
              Text(
                dateStr,
                style: TextStyle(fontSize: 12, color: colors.textSecondary),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          10.gapH,
          Row(
            children: [
              Icon(
                item.isWithinGeofence ? Symbols.pin_drop : Symbols.location_off,
                size: 16,
                color: item.isWithinGeofence ? colors.pineGreen : colors.error,
              ),
              6.gapW,
              Text(
                l10n.geofenceDistanceLabel(item.distanceMeters),
                style: TextStyle(fontSize: 12, color: colors.textSecondary),
              ),
              const Spacer(),
              Text(
                item.isWithinGeofence ? l10n.geofenceWithinRange : l10n.geofenceOutOfRange,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: item.isWithinGeofence ? colors.pineGreen : colors.error,
                ),
              ),
            ],
          ),
          if (item.errorMessage != null) ...[
            6.gapH,
            Text(
              'Lý do: ${item.errorMessage!}',
              style: TextStyle(fontSize: 11.5, color: colors.error),
            ),
          ],
          if (item.syncStatus == SyncStatus.failed) ...[
            8.gapH,
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: colors.primaryIndigo,
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: onRetry,
                icon: const Icon(Symbols.refresh, size: 16),
                label: Text(l10n.syncRetryButton),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
