import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

class LoginHeaderWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        12.gapH,
        Container(
          width: context.custom(normal: 48, compact: 40).toDouble(),
          height: context.custom(normal: 48, compact: 40).toDouble(),
          decoration: BoxDecoration(
            color: colors.primaryIndigo,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: AppIcon(
              AppIcons.user,
              color: Color(0xFFFFF8EC),
              size: 24,
            ),
          ),
        ),
        20.gapH,
        Text(
          '${l10n.greetingDefault}!',
          style: TextStyle(
            fontSize: context.custom(normal: 26, compact: 22).toDouble(),
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: colors.textPrimary,
          ),
        ),
        6.gapH,
        Text(
          l10n.loginInstruction,
          style: TextStyle(
            fontSize: context.custom(normal: 13.5, compact: 12),
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

Widget buildAuthFieldLabel(String text, AppColorsExtension colors) {
  return Text(
    text,
    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.textSecondary),
  );
}

InputDecoration buildAuthInputDecoration({
  required Widget prefixIcon,
  required AppColorsExtension colors,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: colors.cardSecondary,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.primaryIndigo, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );
}
