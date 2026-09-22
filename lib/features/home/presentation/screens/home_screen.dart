import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_card.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';
import 'package:vstech_hrm/core/widgets/tile_section_divider.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_announcements.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_balance_card.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_quick_actions.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_salary_card.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_summary_grid.dart';

/// Main Home Screen for Employee (NV) and Manager (QL).
/// Follows DESIGN.md and Phone.dc.html lines 96–233.
class HomeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
              title: 'Chào buổi sáng, \n$userName 👋',
              subtitle: 'Thứ Ba, 20 Tháng 9 · Cửa hàng Q.3 (TP.HCM)',
              avatarFallbackText: userInitials,
              hasUnreadNotification: true,
              onNotificationTap: () => context.push(AppRoutes.notifications),
              bottomPadding: 64,
            ),
            Transform.translate(
              offset: const Offset(0, -46),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Balance card (Worked hours & punch CTA)
                    const HomeBalanceCard(),

                    // Manager pending approval strip (P0 MSS requirement)
                    if (isManager) ...[
                      const SizedBox(height: 14),
                      _buildManagerApprovalStrip(context, colors),
                    ],

                    // 5 Circular Quick Actions
                    const SizedBox(height: 20),
                    const HomeQuickActions(),

                    // Saigon Tile Section Divider
                    const SizedBox(height: 20),
                    const TileSectionDivider(),

                    // 2x2 Summary Grid
                    const SizedBox(height: 18),
                    const HomeSummaryGrid(),

                    // Salary Card with eye toggle
                    const SizedBox(height: 20),
                    const HomeSalaryCard(),

                    // Latest Announcements
                    const SizedBox(height: 20),
                    const HomeAnnouncements(),

                    // Demo Role Switcher
                    const SizedBox(height: 20),
                    _buildDemoRoleSwitcher(context, colors, isManager),
                    const SizedBox(height: 24),
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
                  width: 38,
                  height: 38,
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chờ bạn phê duyệt',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Phép, tăng ca và sửa công',
                        style: TextStyle(
                          fontSize: 12,
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
                const SizedBox(width: 4),
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
    return AppCard(
      backgroundColor: colors.cardSecondary.withValues(alpha: 0.6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Icon(Symbols.switch_account, size: 20, color: colors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Đang ở vai: ${isManager ? "Quản lý (QL)" : "Nhân viên (NV)"}',
              style: AppTextStyles.bodySmall(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              final nextRole = isManager ? UserRole.employee : UserRole.manager;
              await context.read<AuthCubit>().loginAsDemo(nextRole);
            },
            child: Text(
              'Đổi sang ${isManager ? "NV" : "QL"}',
              style: AppTextStyles.labelMedium(color: colors.primaryIndigo)
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
