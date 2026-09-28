import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Form input field wrapper for ProfileEditScreen.
class ProfileEditField extends StatelessWidget {
  const ProfileEditField({
    required this.label,
    required this.controller,
    required this.icon,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(fontSize: 12, color: colors.textSecondary),
          icon: Icon(icon, size: 20, color: colors.textTertiary),
          isDense: true,
        ),
        validator: (v) =>
            v == null || v.trim().isEmpty ? 'Không được để trống' : null,
      ),
    );
  }
}

/// Section header for ProfileEditScreen.
class ProfileEditSectionHeader extends StatelessWidget {
  const ProfileEditSectionHeader({
    required this.title,
    required this.icon,
    this.isProtected = false,
    super.key,
  });

  final String title;
  final IconData icon;
  final bool isProtected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isProtected ? colors.accentAmber : colors.primaryIndigo,
        ),
        8.gapW,
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
        ),
        if (isProtected)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: colors.accentAmber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'HR Review',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1C1408),
              ),
            ),
          ),
      ],
    );
  }
}
