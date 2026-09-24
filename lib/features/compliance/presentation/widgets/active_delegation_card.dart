import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/features/compliance/domain/entities/delegation_entity.dart';

class ActiveDelegationCard extends StatelessWidget {
  const new({
    required this.delegation,
    required this.onRevoke,
    super.key,
  });

  final DelegationEntity delegation;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final dateFormat = DateFormat('dd/MM/yyyy');
    const okColor = Color(0xFF10B981);

    final rangeText =
        '${dateFormat.format(delegation.fromDate)} - ${dateFormat.format(delegation.toDate)}';

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: okColor.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: okColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(context.w(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: context.w(36),
                height: context.w(36),
                decoration: BoxDecoration(
                  color: okColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: Text(
                  delegation.delegatePerson.initials,
                  style: AppTextStyles.bodyBold.copyWith(
                    color: okColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              AppGap.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delegation.delegatePerson.name,
                      style: AppTextStyles.bodyBold.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                      ),
                    ),
                    AppGap.h2,
                    Text(
                      rangeText,
                      style: AppTextStyles.caption.copyWith(
                        color: colors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              AppGap.w8,
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(8),
                  vertical: context.h(4),
                ),
                decoration: BoxDecoration(
                  color: okColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  l10n.delRunning,
                  style: AppTextStyles.caption.copyWith(
                    color: okColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          AppGap.h10,
          Text(
            delegation.scopeDescription,
            style: AppTextStyles.caption.copyWith(
              color: colors.textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          AppGap.h12,
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onRevoke,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: context.h(40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFEF4444),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cancel_outlined,
                      color: Color(0xFFEF4444),
                      size: 15,
                    ),
                    AppGap.w8,
                    Text(
                      l10n.delRevoke,
                      style: AppTextStyles.bodyBold.copyWith(
                        color: const Color(0xFFEF4444),
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
