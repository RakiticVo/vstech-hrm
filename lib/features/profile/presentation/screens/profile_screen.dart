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
import 'package:vstech_hrm/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/profile_info_card.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/theme_selection_sheet.dart';

/// Screen 19: Comprehensive Employee Profile matching Screen 19 reference image.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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

    final userName = user?.name ?? (_profileData?['fullName']?.toString() ?? 'Nhân viên');
    final userCode = user?.employeeCode ?? (_profileData?['code']?.toString() ?? '—');
    final department = user?.department ?? (_profileData?['department']?['name']?.toString() ?? 'VSTech');
    final userEmail = user?.email ?? (_profileData?['email']?.toString() ?? '—');

    final phone = _profileData?['phone']?.toString() ?? '—';
    final dob = _profileData?['birthday']?.toString() ?? (_profileData?['dob']?.toString() ?? '—');
    final address = _profileData?['address']?.toString() ?? '—';
    final jobTitle = _profileData?['position']?['name']?.toString() ??
        (_profileData?['jobTitle']?.toString() ?? (isManager ? 'Quản lý bộ phận' : 'Chuyên viên'));
    final directManager = _profileData?['managerName']?.toString() ?? '—';
    final joinDate = _profileData?['hireDate']?.toString() ?? (_profileData?['joinDate']?.toString() ?? '—');
    final bankName = _profileData?['bankName']?.toString() ?? '—';
    final bankAccount = _profileData?['bankAccountNumber']?.toString() ?? '—';

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
            icon: AppIcon(AppIcons.correction, size: 21, color: colors.primaryIndigo),
            tooltip: context.l10n.profileEditTitle,
            onPressed: () => context.push(AppRoutes.profileEdit),
          ),
          IconButton(
            icon: AppIcon(AppIcons.settings, size: 22, color: colors.textPrimary),
            onPressed: () => context.push(AppRoutes.settings),
          ),
          4.gapW,
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            ProfileHeaderCard(
              name: userName,
              employeeCode: userCode,
              position: '$jobTitle · $department',
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
            16.gapH,

            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: [
                  _buildLetterLinkTile('S', context.l10n.profileEditTitle, () => context.push(AppRoutes.profileEdit), colors),
                  Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                  _buildLetterLinkTile('T', context.l10n.documentManagementTitle, () => context.push(AppRoutes.documentManagement), colors),
                  Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                  _buildLetterLinkTile('P', context.l10n.dependantsManageTitle, () => context.push(AppRoutes.dependants), colors),
                  Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                  _buildLetterLinkTile('H', context.l10n.documentsAndRecordsLink, () => context.push(AppRoutes.laborProfile), colors),
                  Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                  _buildLetterLinkTile('R', context.l10n.internalRecruitmentLink, () => context.push(AppRoutes.jobRecruitment), colors),
                  Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                  _buildLetterLinkTile('K', context.l10n.faceAuthTitle, () => context.push(AppRoutes.faceEnrollment), colors),
                  Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                  _buildLetterLinkTile('G', context.l10n.themeSettingTitle, () => ThemeSelectionSheet.show(context), colors),
                  Divider(height: 1, indent: 62, color: colors.border.withValues(alpha: 0.5)),
                  _buildLetterLinkTile('C', context.l10n.settingsLink, () => context.push(AppRoutes.settings), colors),
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
          ],
        ),
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
              AppIcon(AppIcons.chevronRight, size: 18, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
