import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/profile_info_card.dart';

/// Screen 19: Comprehensive Employee Profile matching Screen 19 reference image.
class ProfileScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authState = context.watch<AuthCubit>().state;

    final user = authState is Authenticated ? authState.user : null;
    final isManager = authState is Authenticated && authState.role.isManager;

    final userName = user?.name ?? 'Nguyễn Minh Tuấn';
    final userCode = user?.employeeCode ?? 'NV-04821';
    final department = user?.department ?? 'Vận hành';
    final userEmail = user?.email ?? 'minh.tuan@company.vn';

    final personalRows = [
      (context.l10n.fullNameLabel, userName),
      (context.l10n.dateOfBirthLabel, '14/03/1994'),
      (context.l10n.phoneLabel, '+84 908 221 470'),
      (context.l10n.emailLabel, userEmail),
      (context.l10n.addressLabel, 'Q.3, TP. Hồ Chí Minh'),
    ];

    final workRows = [
      (context.l10n.departmentLabel, department),
      (context.l10n.jobTitleLabel, 'Giám sát cửa hàng'),
      (context.l10n.directManagerLabel, 'Lê Thu Hà'),
      (context.l10n.joinDateLabel, '02/05/2021'),
      (context.l10n.employmentStatusLabel, context.l10n.officialStatus),
    ];

    final bankRows = [
      (context.l10n.bankNameLabel, 'Vietcombank'),
      (context.l10n.accountNumberLabel, '•••• 4821'),
    ];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        title: Text(
          context.l10n.profileTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Symbols.settings, size: 22, color: colors.textPrimary),
            onPressed: () => context.push(AppRoutes.settings),
          ),
          4.gapW,
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // Part 1: Bounded Header Card
          ProfileHeaderCard(
            name: userName,
            employeeCode: userCode,
            position: 'Giám sát cửa hàng · Vận hành',
            isManager: isManager,
          ),
          18.gapH,

          // Thông tin cá nhân
          ProfileInfoCard(
            title: context.l10n.personalInfoSection,
            rows: personalRows,
          ),
          16.gapH,

          // Part 2: Thông tin công việc
          ProfileInfoCard(
            title: context.l10n.workInfoSection,
            rows: workRows,
          ),
          16.gapH,

          // Tài khoản ngân hàng
          ProfileInfoCard(
            title: context.l10n.bankAccountSection,
            rows: bankRows,
          ),
          16.gapH,

          // Profile Quick Links (K, H, T, C)
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              children: [
                _buildLetterLinkTile('K', context.l10n.emergencyContactLink, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.emergencyContactInfo)),
                  );
                }, colors),
                Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                _buildLetterLinkTile('H', context.l10n.documentsAndRecordsLink, () => context.push(AppRoutes.laborProfile), colors),
                Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                _buildLetterLinkTile('T', context.l10n.internalRecruitmentLink, () => context.push(AppRoutes.jobRecruitment), colors),
                Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                _buildLetterLinkTile('C', context.l10n.settingsLink, () => context.push(AppRoutes.settings), colors),
              ],
            ),
          ),
          20.gapH,

          // Nút Đăng xuất
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.error,
              side: BorderSide(color: colors.error.withValues(alpha: 0.5)),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => _confirmLogout(context, colors),
            icon: const Icon(Symbols.logout, size: 18),
            label: Text(
              context.l10n.logoutButton,
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterLinkTile(String letter, String title, VoidCallback onTap, AppColorsExtension colors) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: colors.primaryIndigo,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Icon(Symbols.chevron_right, size: 18, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AppColorsExtension colors) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            context.l10n.logoutConfirmTitle,
            style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800, color: colors.textPrimary),
          ),
          content: Text(
            context.l10n.logoutConfirmMsg,
            style: TextStyle(fontSize: 13, color: colors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.l10n.cancelButton, style: TextStyle(fontWeight: FontWeight.w700, color: colors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                unawaited(context.read<AuthCubit>().logout());
              },
              child: Text(context.l10n.logoutButton, style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }
}
