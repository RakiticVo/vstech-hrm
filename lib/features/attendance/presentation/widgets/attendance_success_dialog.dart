import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_card.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';

/// Modal bottom sheet confirming attendance punch success.
class AttendanceSuccessSheet extends StatelessWidget {
  const new({
    required this.record,
    required this.onClose,
    super.key,
  });

  final AttendanceRecordEntity record;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final isCheckIn = record.type.isCheckIn;
    final typeLabel = isCheckIn ? l10n.checkInRecorded : l10n.checkOutRecorded;

    final timeStr =
        '${record.timestamp.hour.toString().padLeft(2, '0')}:${record.timestamp.minute.toString().padLeft(2, '0')}:${record.timestamp.second.toString().padLeft(2, '0')}';
    final dateStr =
        '${record.timestamp.day.toString().padLeft(2, '0')}/${record.timestamp.month.toString().padLeft(2, '0')}/${record.timestamp.year}';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colors.pineGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.check_circle,
                color: colors.pineGreen,
                size: 40,
                weight: 600,
              ),
            ),
          ),
          14.gapH,
          Center(
            child: Text(
              l10n.punchSuccessTitle,
              style: AppTextStyles.titleMedium(color: colors.textPrimary).copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
          4.gapH,
          Center(
            child: Text(
              typeLabel,
              style: AppTextStyles.bodyMedium(color: colors.textSecondary),
            ),
          ),
          20.gapH,
          AppCard(
            backgroundColor: colors.cardSecondary.withValues(alpha: 0.5),
            borderColor: colors.border,
            child: Column(
              children: [
                _buildReceiptRow(
                  label: l10n.timeLabel,
                  value: '$timeStr • $dateStr',
                  colors: colors,
                  isHighlight: true,
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.classificationLabel, style: AppTextStyles.bodySmall(color: colors.textSecondary)),
                    StatusChip(
                      label: record.classification.displayName,
                      type: AppStatusType.approved,
                    ),
                  ],
                ),
                const Divider(height: 20),
                _buildReceiptRow(
                  label: l10n.locationLabel,
                  value: record.locationName,
                  colors: colors,
                ),
                const Divider(height: 20),
                _buildReceiptRow(
                  label: l10n.methodLabel,
                  value: l10n.methodFaceGps,
                  colors: colors,
                ),
              ],
            ),
          ),
          24.gapH,
          PrimaryButton(
            text: l10n.completeAndHomeCta,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow({
    required String label,
    required String value,
    required AppColorsExtension colors,
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall(color: colors.textSecondary)),
        Text(
          value,
          style: AppTextStyles.bodyMedium(color: colors.textPrimary).copyWith(
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
