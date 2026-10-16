import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Interactive 6-digit PIN dots and numeric keypad widget.
class PinCodeKeypad extends StatelessWidget {
  const PinCodeKeypad({
    required this.pinLength,
    required this.currentLength,
    required this.onDigitPressed,
    required this.onDeletePressed,
    this.onBiometricPressed,
    this.isError = false,
    this.isDisabled = false,
    super.key,
  });

  final int pinLength;
  final int currentLength;
  final ValueChanged<String> onDigitPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback? onBiometricPressed;
  final bool isError;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pinLength, (index) {
            final isFilled = index < currentLength;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isError
                    ? colors.error
                    : isFilled
                        ? colors.primaryIndigo
                        : Colors.transparent,
                border: Border.all(
                  color: isError
                      ? colors.error
                      : isFilled
                          ? colors.primaryIndigo
                          : colors.border,
                  width: 2,
                ),
              ),
            );
          }),
        ),
        32.gapH,

        // Numeric Keypad 3x4
        _buildKeypadRow(context, ['1', '2', '3']),
        16.gapH,
        _buildKeypadRow(context, ['4', '5', '6']),
        16.gapH,
        _buildKeypadRow(context, ['7', '8', '9']),
        16.gapH,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSpecialButton(
              context,
              iconWidget: onBiometricPressed != null
                  ? AppIcon(AppIcons.fingerprint, size: 28, color: colors.primaryIndigo)
                  : const SizedBox.shrink(),
              onPressed: onBiometricPressed,
            ),
            20.gapW,
            _buildDigitButton(context, '0'),
            20.gapW,
            _buildSpecialButton(
              context,
              iconWidget: AppIcon(AppIcons.back, size: 24, color: colors.textSecondary),
              onPressed: onDeletePressed,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadRow(BuildContext context, List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDigitButton(context, digits[0]),
        20.gapW,
        _buildDigitButton(context, digits[1]),
        20.gapW,
        _buildDigitButton(context, digits[2]),
      ],
    );
  }

  Widget _buildDigitButton(BuildContext context, String digit) {
    final colors = context.colors;

    return SizedBox(
      width: 72,
      height: 72,
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: colors.border.withValues(alpha: 0.7)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: isDisabled ? null : () => onDigitPressed(digit),
          child: Center(
            child: Text(
              digit,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialButton(
    BuildContext context, {
    required Widget iconWidget,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: isDisabled ? null : onPressed,
          child: Center(
            child: iconWidget,
          ),
        ),
      ),
    );
  }
}
