import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

class ApprovalItem {
  const new({
    required this.initials,
    required this.name,
    required this.type,
    required this.dates,
    required this.reason,
  });

  final String initials;
  final String name;
  final String type;
  final String dates;
  final String reason;
}

class ApprovalCard extends StatelessWidget {
  const new({
    required this.item,
    required this.onApprove,
    required this.onReject,
    super.key,
  });

  final ApprovalItem item;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: colors.cardSecondary,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: Text(
                    item.initials,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: colors.primaryIndigo,
                    ),
                  ),
                ),
              ),
              11.gapW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    2.gapH,
                    Text(
                      '${item.type} · ${item.dates}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: colors.accentAmber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.l10n.statusPending,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: colors.accentAmber,
                  ),
                ),
              ),
            ],
          ),
          11.gapH,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: colors.cardSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item.reason,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                height: 1.5,
                color: colors.textSecondary,
              ),
            ),
          ),
          12.gapH,
          Row(
            children: [
              Expanded(
                flex: 10,
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: onReject,
                    child: Text(
                      context.l10n.actionReject,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: colors.error,
                      ),
                    ),
                  ),
                ),
              ),
              9.gapW,
              Expanded(
                flex: 14,
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.pineGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: onApprove,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Symbols.check, size: 18, weight: 700),
                        6.gapW,
                        Text(
                          context.l10n.actionApprove,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
