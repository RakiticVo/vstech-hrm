import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// 3-column top summary card in Requests Center synchronized with actual requests count.
class RequestsSummaryHeader extends StatelessWidget {
  const new({
    this.pendingCount = 0,
    this.approvedCount = 0,
    this.rejectedCount = 0,
    this.onTabSelected,
    super.key,
  });

  final int pendingCount;
  final int approvedCount;
  final int rejectedCount;
  final ValueChanged<int>? onTabSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final items = [
      (l10n.tabPending, '$pendingCount', colors.accentAmber, 1),
      (l10n.tabApproved, '$approvedCount', colors.pineGreen, 2),
      (l10n.tabRejected, '$rejectedCount', colors.error, 3),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Row(
        children: items.map((x) {
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: onTabSelected != null ? () => onTabSelected!(x.$4) : null,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: x.$3,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          x.$2,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: x.$3,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      x.$1,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
