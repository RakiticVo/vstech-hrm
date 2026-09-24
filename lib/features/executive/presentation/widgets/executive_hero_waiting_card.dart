import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

class ExecutiveHeroWaitingCard extends StatelessWidget {
  const new({
    required this.waitingCount,
    required this.oldestHours,
    required this.onTap,
    super.key,
  });

  final int waitingCount;
  final int oldestHours;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.execWaitingBadge,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: colors.textSecondary,
                            ),
                          ),
                          4.gapH,
                          Text(
                            '$waitingCount',
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              fontFeatures: const [FontFeature.tabularFigures()],
                              color: colors.textPrimary,
                              height: 1.1,
                            ),
                          ),
                          4.gapH,
                          Text(
                            l10n.execWaitingSub,
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
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: colors.accentAmber,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colors.accentAmber.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Symbols.checklist,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ],
                ),
                14.gapH,
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: colors.border)),
                  ),
                  child: Row(
                    children: [
                      Icon(Symbols.schedule, size: 16, color: colors.error),
                      6.gapW,
                      Expanded(
                        child: Text(
                          '${l10n.execOldestWaiting.split(':').first}: ${oldestHours}h trước',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: colors.error,
                          ),
                        ),
                      ),
                      Icon(
                        Symbols.chevron_right,
                        size: 18,
                        color: colors.textTertiary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
