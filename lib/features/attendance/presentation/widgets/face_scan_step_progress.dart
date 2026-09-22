import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Instruction text and animated step progress indicator for face scan flow.
class FaceScanStepProgress extends StatelessWidget {
  const new({
    required this.isSubmitting,
    required this.isSuccess,
    super.key,
  });

  final bool isSubmitting;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    String title;
    String subtitle;

    if (isSuccess) {
      title = l10n.faceScanSuccessTitle;
      subtitle = l10n.faceScanSuccessSubtitle;
    } else if (isSubmitting) {
      title = l10n.faceScanningTitle;
      subtitle = l10n.faceScanningSubtitle;
    } else {
      title = l10n.faceAlignPromptTitle;
      subtitle = l10n.faceAlignPromptSubtitle;
    }

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        6.gapH,
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.85),
          ),
          textAlign: TextAlign.center,
        ),
        12.gapH,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final isActive = index == 0 ||
                (index == 1 && (isSubmitting || isSuccess)) ||
                (index == 2 && isSuccess);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? colors.accentAmber
                    : Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
