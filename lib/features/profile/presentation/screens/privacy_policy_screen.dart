import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Dedicated Privacy Policy screen outlining security and data handling rules.
class PrivacyPolicyScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final sections = [
      _PolicySection(
        icon: AppIcons.faceScan,
        title: l10n.privacySec1Title,
        content: l10n.privacySec1Content,
      ),
      _PolicySection(
        icon: AppIcons.location,
        title: l10n.privacySec2Title,
        content: l10n.privacySec2Content,
      ),
      _PolicySection(
        icon: AppIcons.lock,
        title: l10n.privacySec3Title,
        content: l10n.privacySec3Content,
      ),
      _PolicySection(
        icon: AppIcons.shield,
        title: l10n.privacySec4Title,
        content: l10n.privacySec4Content,
      ),
      _PolicySection(
        icon: AppIcons.shieldCheck,
        title: l10n.privacySec5Title,
        content: l10n.privacySec5Content,
      ),
    ];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const AppIcon(AppIcons.back, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.privacyPolicyTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.pineGreen.withValues(alpha: 0.12),
                  colors.pineGreen.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.pineGreen.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.pineGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: AppIcon(AppIcons.shieldCheck, size: 22, color: Colors.white),
                  ),
                ),
                14.gapW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.privacyPolicyTitle,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                      3.gapH,
                      Text(
                        l10n.privacyLastUpdated,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          16.gapH,
          ...sections.map((sec) => _buildSectionCard(sec, colors)),
        ],
      ),
    );
  }

  Widget _buildSectionCard(_PolicySection section, AppColorsExtension colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colors.pineGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: AppIcon(section.icon, size: 16, color: colors.pineGreen),
                ),
              ),
              10.gapW,
              Expanded(
                child: Text(
                  section.title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          10.gapH,
          Text(
            section.content,
            style: TextStyle(
              fontSize: 12.5,
              color: colors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicySection {
  const new({
    required this.icon,
    required this.title,
    required this.content,
  });

  final String icon;
  final String title;
  final String content;
}
