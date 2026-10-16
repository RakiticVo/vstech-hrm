import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';

class DelegationScopeToggle extends StatelessWidget {
  const new({
    required this.isAllScope,
    required this.onScopeChanged,
    super.key,
  });

  final bool isAllScope;
  final ValueChanged<bool> onScopeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _ScopeOptionButton(
            label: l10n.delAllScope,
            isSelected: isAllScope,
            onTap: () => onScopeChanged(true),
          ),
        ),
        AppGap.w8,
        Expanded(
          child: _ScopeOptionButton(
            label: l10n.delPartialScope,
            isSelected: !isAllScope,
            onTap: () => onScopeChanged(false),
          ),
        ),
      ],
    );
  }
}

class _ScopeOptionButton extends StatelessWidget {
  const new({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: context.h(42),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : colors.surface,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: isSelected ? colors.primary : colors.borderSubtle,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.bodyBold.copyWith(
              color: isSelected ? colors.onPrimary : colors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
