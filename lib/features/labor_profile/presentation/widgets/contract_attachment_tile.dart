import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/labor_profile/domain/entities/labor_profile_entity.dart';

/// Tile displaying an official contract attachment scan with download/preview triggers.
class ContractAttachmentTile extends StatelessWidget {
  const new({required this.attachment, super.key});

  final LaborContractAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final dateStr = DateFormat('dd/MM/yyyy').format(attachment.uploadedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Symbols.picture_as_pdf, color: colors.error, size: 22),
          ),
          12.gapW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                3.gapH,
                Text(
                  '${attachment.size} • Đăng tải: $dateStr',
                  style: TextStyle(fontSize: 11.5, color: colors.textTertiary),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Symbols.visibility, size: 20, color: colors.primaryIndigo),
            tooltip: l10n.previewAttachmentButton,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đang mở bản xem trước: ${attachment.name}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Symbols.download, size: 20, color: colors.pineGreen),
            tooltip: l10n.downloadAttachmentButton,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đang tải xuống: ${attachment.name}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
