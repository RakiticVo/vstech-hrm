import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Top bar header for Overtime Request Modal.
class OvertimeModalHeader extends StatelessWidget {
  const new({
    required this.title,
    required this.colors,
    this.onClose,
    super.key,
  });

  final String title;
  final AppColorsExtension colors;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: colors.textPrimary),
        ),
        IconButton(
          icon: const AppIcon(AppIcons.close, size: 20),
          onPressed: onClose,
        ),
      ],
    );
  }
}
