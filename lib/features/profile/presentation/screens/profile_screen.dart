import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/logout_confirm_dialog.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';
import 'package:vstech_hrm/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/profile_info_card.dart';

/// Screen 19: Comprehensive Employee Profile matching Screen 19 reference image.
class ProfileScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    unawaited(_loadProfile());
  }

  Future<void> _loadProfile() async {
    try {
      final data = await sl<AuthRemoteDataSource>().getFullProfile();
      if (!mounted) return;
      setState(() => _profileData = data);
    } on Object {
      // Handled cleanly with empty fallbacks
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authState = context.watch<AuthCubit>().state;

    final user = authState is Authenticated ? authState.user : null;
    final isManager = authState is Authenticated && authState.role.isManager;

    final emp = (_profileData?['employee'] as Map<String, dynamic>?) ??
        (_profileData?['data'] as Map<String, dynamic>?) ??
        _profileData ??
        <String, dynamic>{};

    final userName = emp['name']?.toString() ??
        emp['fullName']?.toString() ??
        user?.name ??
        'Nhân viên';
    final userCode = emp['code']?.toString() ??
        emp['employeeCode']?.toString() ??
        user?.employeeCode ??
        '—';
    final department = emp['departmentName']?.toString() ??
        (emp['department'] is Map ? (emp['department'] as Map)['name']?.toString() : null) ??
        user?.department ??
        'VSTech';
    final userEmail = emp['mail']?.toString() ??
        emp['email']?.toString() ??
        user?.email ??
        '—';

    final phone = emp['phoneNumber']?.toString() ??
        emp['phone']?.toString() ??
        '—';
    final dob = emp['birthDay']?.toString() ??
        emp['birthday']?.toString() ??
        emp['dob']?.toString() ??
        '—';
    final address = emp['address']?.toString() ?? '—';
    final jobTitle = emp['positionName']?.toString() ??
        (emp['position'] is Map ? (emp['position'] as Map)['name']?.toString() : null) ??
        emp['jobTitle']?.toString() ??
        (isManager ? 'Quản lý bộ phận' : 'Chuyên viên');
    final directManager = emp['managerName']?.toString() ?? '—';
    final joinDate = emp['hireDate']?.toString() ??
        emp['joinDate']?.toString() ??
        '—';
    final bankName = emp['bankName']?.toString() ?? '—';
    final bankAccount = emp['bankNumber']?.toString() ??
        emp['bankAccountNumber']?.toString() ??
        '—';

    final personalRows = [
      (context.l10n.fullNameLabel, userName),
      (context.l10n.dateOfBirthLabel, dob),
      (context.l10n.phoneLabel, phone),
      (context.l10n.emailLabel, userEmail.isNotEmpty ? userEmail : '—'),
      (context.l10n.addressLabel, address),
    ];

    final workRows = [
      (context.l10n.departmentLabel, department),
      (context.l10n.jobTitleLabel, jobTitle),
      (context.l10n.directManagerLabel, directManager),
      (context.l10n.joinDateLabel, joinDate),
      (context.l10n.employmentStatusLabel, context.l10n.officialStatus),
    ];

    final bankRows = [
      (context.l10n.bankNameLabel, bankName),
      (context.l10n.accountNumberLabel, bankAccount),
    ];

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          TileHeaderBanner(
            title: context.l10n.profileTitle,
            subtitle: userCode != '—' ? '#$userCode · $department' : department,
            trailing: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => context.push(AppRoutes.settings),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EC).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const AppIcon(
                  AppIcons.settings,
                  size: 20,
                  color: Color(0xFFFFF8EC),
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadProfile,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: [
            ProfileHeaderCard(
              name: userName,
              employeeCode: userCode,
              position: jobTitle,
              department: department,
              isManager: isManager,
            ),
            18.gapH,

            ProfileInfoCard(
              title: context.l10n.personalInfoSection,
              rows: personalRows,
            ),
            16.gapH,

            ProfileInfoCard(
              title: context.l10n.workInfoSection,
              rows: workRows,
            ),
            16.gapH,

            ProfileInfoCard(
              title: context.l10n.bankAccountSection,
              rows: bankRows,
            ),
            18.gapH,

            Text(
              context.l10n.systemAndSupportSection,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: colors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            8.gapH,

            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: [
                  _buildIconLinkTile(AppIcons.scanFace, context.l10n.faceAuthTitle, () => context.push(AppRoutes.faceEnrollment), colors),
                  Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                  _buildIconLinkTile(AppIcons.settings, context.l10n.settingsLink, () => context.push(AppRoutes.settings), colors),
                  Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                  _buildIconLinkTile(AppIcons.info, context.l10n.faqTitle, () => context.push(AppRoutes.faq), colors),
                  Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                  _buildIconLinkTile(AppIcons.shieldCheck, context.l10n.privacyPolicyTitle, () => context.push(AppRoutes.privacyPolicy), colors),
                ],
              ),
            ),
            20.gapH,

            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.error,
                side: BorderSide(color: colors.error.withValues(alpha: 0.5)),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => LogoutConfirmDialog.show(context),
              icon: AppIcon(AppIcons.logout, size: 18, color: colors.error),
              label: Text(
                context.l10n.logoutButton,
                style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
              ),
            ),
            16.gapH,

            Center(
              child: Text(
                context.l10n.appVersionFooter,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: colors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),
);
}

  Widget _buildIconLinkTile(String iconName, String title, VoidCallback onTap, AppColorsExtension colors) {
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
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: colors.pineGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: AppIcon(
                    iconName,
                    size: 18,
                    color: colors.pineGreen,
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
              AppIcon(AppIcons.chevronRight, size: 18, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
