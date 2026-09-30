import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Screen 03: Forgot Password Guidance Screen.
/// Provides enterprise contact instructions for IT Helpdesk password resets.
class ForgotPasswordScreen extends StatelessWidget {
  const new({super.key});

  void _onCallIt(BuildContext context) {
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l10n.callItDepartmentBtn}: ${l10n.itHotlineNumber}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Top Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: colors.cardBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.border),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow.withValues(alpha: isDark ? 0.3 : 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AppIcon(
                        AppIcons.chevronLeft,
                        size: 22,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              8.gapH,

              // Top Illustration from assets/images/background/forgot-password.svg
              SvgPicture.asset(
                'assets/images/background/forgot-password.svg',
                width: 260,
                height: 178,
              ),
              16.gapH,

              // Heading Title
              Text(
                l10n.forgotPasswordTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.4,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              10.gapH,

              // Explanation Subtitle
              Text(
                l10n.forgotPasswordSubtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
              20.gapH,

              // Contact Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.cardBackground,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: colors.border),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow.withValues(alpha: isDark ? 0.3 : 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildContactRow(
                      iconName: AppIcons.phone,
                      label: l10n.itHotlineLabel,
                      value: l10n.itHotlineNumber,
                      colors: colors,
                      isDark: isDark,
                    ),
                    Divider(height: 24, color: colors.border.withValues(alpha: 0.6)),
                    _buildContactRow(
                      iconName: AppIcons.mail,
                      label: l10n.itEmailLabel,
                      value: l10n.itEmailValue,
                      colors: colors,
                      isDark: isDark,
                    ),
                    Divider(height: 24, color: colors.border.withValues(alpha: 0.6)),
                    _buildContactRow(
                      iconName: AppIcons.clock,
                      label: l10n.itSupportHoursLabel,
                      value: l10n.itSupportHoursValue,
                      colors: colors,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              16.gapH,

              // Disclaimer Text
              Text(
                l10n.itSecurityDisclaimer,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              24.gapH,

              // Primary Call IT Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentAmber,
                    foregroundColor: const Color(0xFF1C1408),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => _onCallIt(context),
                  icon: const AppIcon(AppIcons.phone, size: 20, color: Color(0xFF1C1408)),
                  label: Text(
                    l10n.callItDepartmentBtn,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              12.gapH,

              // Secondary Back to Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: colors.cardBackground,
                    side: BorderSide(color: colors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    l10n.backToLoginBtn,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
              16.gapH,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow({
    required String iconName,
    required String label,
    required String value,
    required AppColorsExtension colors,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.tealPrimary.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: AppIcon(iconName, color: colors.tealPrimary, size: 22),
          ),
        ),
        14.gapW,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              ),
              3.gapH,
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
