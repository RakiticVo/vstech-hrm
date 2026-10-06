import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Row widget containing the "Ghi nhớ" (Remember Me) checkbox and "Quên mật khẩu" button.
class RememberMeRow extends StatelessWidget {
  const new({
    required this.rememberMe,
    required this.onChanged,
    required this.onForgotPassword,
    super.key,
  });

  final bool rememberMe;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () => onChanged(!rememberMe),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: rememberMe,
                    activeColor: colors.primaryIndigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onChanged: onChanged,
                  ),
                ),
                8.gapW,
                Text(
                  l10n.rememberMe,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      TextButton(
          onPressed: onForgotPassword,
          child: Text(
            l10n.forgotPasswordShort,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: colors.primaryIndigo,
            ),
          ),
        ),
      ],
    );
  }
}
