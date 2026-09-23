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
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_card.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';
import 'package:vstech_hrm/core/widgets/tile_section_divider.dart';
import 'package:vstech_hrm/features/attendance/presentation/widgets/attendance_offline_queue_banner.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_announcements.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_balance_card.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_quick_actions.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_salary_card.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_summary_grid.dart';

/// Main Home Screen for Employee (NV) and Manager (QL).
/// Follows Clean Architecture, AppLayout, and L10n standards.
class HomeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final authState = context.watch<AuthCubit>().state;
    final user = authState is Authenticated ? authState.user : null;
    final isManager = authState is Authenticated && authState.role.isManager;

    final userName = user?.name ?? 'Nguyễn Minh Tuấn';
    final userInitials = userName.isNotEmpty ? userName.substring(0, 1) : 'MT';

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TileHeaderBanner(
              title: '${l10n.greetingMorning}, \n$userName 👋',
              subtitle: 'Thứ Ba, 20 Tháng 9 · Cửa hàng Q.3 (TP.HCM)',
              avatarFallbackText: userInitials,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Symbols.qr_code_scanner, color: Color(0xFFFFF8EC), size: 24),
                    tooltip: l10n.qrScannerTitle,
                    onPressed: () => context.push(AppRoutes.qrScanner),
                  ),
                  IconButton(
                    icon: const Icon(Symbols.notifications, color: Color(0xFFFFF8EC), size: 24),
                    tooltip: l10n.notificationsTitle,
                    onPressed: () => context.push(AppRoutes.notifications),
                  ),
                ],
              ),
              bottomPadding: context.custom(normal: 64, compact: 52),
            ),
            Transform.translate(
              offset: const Offset(0, -46),
              child: Padding(
                padding: context.paddingCustom(horizontal: 16),
                child: Column(
                  children: [
                    // Persistent Offline Queue Warning Banner
                    const AttendanceOfflineQueueBanner(),

                    // Balance card (Worked hours & punch CTA)
                    const HomeBalanceCard(),

                    // Manager pending approval strip (P0 MSS requirement)
                    if (isManager) ...[
                      14.gapH,
                      _buildManagerApprovalStrip(context, colors),
                    ],

                    // 5 Circular Quick Actions
                    20.gapH,
                    const HomeQuickActions(),

                    // Saigon Tile Section Divider
                    20.gapH,
                    const TileSectionDivider(),

                    // 2x2 Summary Grid
                    18.gapH,
                    const HomeSummaryGrid(),

                    // Salary Card with eye toggle
                    20.gapH,
                    const HomeSalaryCard(),

                    // Latest Announcements
                    20.gapH,
                    const HomeAnnouncements(),

                    // Demo Role Switcher
                    20.gapH,
                    _buildDemoRoleSwitcher(context, colors, isManager),
                    24.gapH,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagerApprovalStrip(
    BuildContext context,
    AppColorsExtension colors,
  ) {
    final l10n = context.l10n;
    final stripSize = context.custom(normal: 38, compact: 32).toDouble();

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.accentAmber, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.go(AppRoutes.approvals),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: stripSize,
                  height: stripSize,
                  decoration: BoxDecoration(
                    color: colors.accentAmber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Symbols.assignment_late,
                      color: Color(0xFF1C1408),
                      size: 20,
                    ),
                  ),
                ),
                12.gapW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.managerPendingApprovalTitle,
                        style: TextStyle(
                          fontSize: context.custom(normal: 14, compact: 13),
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        l10n.managerApprovalPending,
                        style: TextStyle(
                          fontSize: context.custom(normal: 12, compact: 11),
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '3',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: colors.accentAmber,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                4.gapW,
                Icon(
                  Symbols.chevron_right,
                  color: colors.accentAmber,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoRoleSwitcher(
    BuildContext context,
    AppColorsExtension colors,
    bool isManager,
  ) {
    final l10n = context.l10n;
    final targetRoleText = isManager ? l10n.demoEmployee : l10n.demoManager;

    return AppCard(
      backgroundColor: colors.cardSecondary.withValues(alpha: 0.6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Icon(Symbols.switch_account, size: 20, color: colors.textSecondary),
          10.gapW,
          Expanded(
            child: Text(
              '${l10n.roleSwitcherTitle}: ${isManager ? l10n.demoManager : l10n.demoEmployee}',
              style: AppTextStyles.bodySmall(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              final nextRole = isManager ? UserRole.employee : UserRole.manager;
              await context.read<AuthCubit>().loginAsDemo(nextRole);
            },
            child: Text(
              l10n.switchToRole(targetRoleText),
              style: AppTextStyles.labelMedium(color: colors.primaryIndigo)
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
