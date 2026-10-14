import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Card showing basic device identifiers and OS status.
class DeviceHardwareCard extends StatelessWidget {
  const DeviceHardwareCard({
    required this.deviceName,
    required this.deviceUuid,
    required this.osVersion,
    required this.registeredDate,
    required this.statusRecordedLabel,
    required this.deviceRegisteredDateLabel,
    super.key,
  });

  final String deviceName;
  final String deviceUuid;
  final String osVersion;
  final String registeredDate;
  final String statusRecordedLabel;
  final String deviceRegisteredDateLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.primaryIndigo.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: AppIcon(AppIcons.smartphone, color: colors.primaryIndigo, size: 22),
              ),
              12.gapW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deviceName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    2.gapH,
                    Text(
                      'ID: $deviceUuid',
                      style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.pineGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusRecordedLabel,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: colors.pineGreen),
                ),
              ),
            ],
          ),
          14.gapH,
          Divider(height: 1, color: colors.border),
          12.gapH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Hệ điều hành', style: TextStyle(fontSize: 12, color: colors.textSecondary)),
              Text(osVersion, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.textPrimary)),
            ],
          ),
          8.gapH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(deviceRegisteredDateLabel, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
              Text(registeredDate, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Single security check tile item (OK / FAIL).
class DeviceSecurityCheckItem extends StatelessWidget {
  const DeviceSecurityCheckItem({
    required this.title,
    required this.isPassed,
    super.key,
  });

  final String title;
  final bool isPassed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isPassed ? colors.border : colors.error),
      ),
      child: Row(
        children: [
          AppIcon(
            isPassed ? AppIcons.checkCircle2 : AppIcons.xCircle,
            color: isPassed ? colors.pineGreen : colors.error,
            size: 20,
          ),
          12.gapW,
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isPassed ? colors.textPrimary : colors.error,
              ),
            ),
          ),
          Text(
            isPassed ? 'OK' : 'CẢNH BÁO',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isPassed ? colors.pineGreen : colors.error,
            ),
          ),
        ],
      ),
    );
  }
}
