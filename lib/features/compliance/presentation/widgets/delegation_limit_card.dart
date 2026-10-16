import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';

class DelegationLimitCard extends StatelessWidget {
  const new({
    required this.selectedLimit,
    required this.onSelectLimit,
    super.key,
  });

  final String selectedLimit;
  final ValueChanged<String> onSelectLimit;

  static const List<String> limitOptions = [
    'Không giới hạn',
    '≤ 20.000.000 VNĐ',
    '≤ 50.000.000 VNĐ',
    '≤ 100.000.000 VNĐ',
  ];

  static const List<String> limitLabels = [
    'Vô hạn',
    '≤ 20 Tr',
    '≤ 50 Tr',
    '≤ 100 Tr',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.delLimit,
                style: AppTextStyles.caption.copyWith(
                  color: colors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                selectedLimit,
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: colors.primary,
                ),
              ),
            ],
          ),
          AppGap.h12,
          Row(
            children: List.generate(limitOptions.length, (index) {
              final option = limitOptions[index];
              final label = limitLabels[index];
              final isSelected = selectedLimit == option;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < limitOptions.length - 1 ? context.w(6) : 0,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onSelectLimit(option),
                      borderRadius: BorderRadius.circular(11),
                      child: Container(
                        height: context.h(36),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.primary
                              : colors.surfaceContainer,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                            color: isSelected
                                ? colors.primary
                                : colors.borderSubtle,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          label,
                          style: AppTextStyles.caption.copyWith(
                            color: isSelected
                                ? colors.onPrimary
                                : colors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 11.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          AppGap.h12,
          Text(
            l10n.delLimitHint,
            style: AppTextStyles.caption.copyWith(
              color: colors.textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
