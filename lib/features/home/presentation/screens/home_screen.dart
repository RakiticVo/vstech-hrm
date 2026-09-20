import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/amber_cta_button.dart';
import 'package:vstech_hrm/core/widgets/app_card.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';

/// Main Home Screen for Employee (NV) and Manager (QL).
class HomeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authState = context.watch<AuthCubit>().state;
    final user = authState is Authenticated ? authState.user : null;
    final isManager = authState is Authenticated && authState.role.isManager;

    final userName = user?.name ?? 'Nhân viên';
    final userInitials = userName.isNotEmpty ? userName.substring(0, 1) : 'VS';

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TileHeaderBanner(
              title: 'Xin chào, $userName',
              subtitle: 'Thứ Ba, 20 Tháng 9 • Trụ sở chính (TP.HCM)',
              avatarFallbackText: userInitials,
              hasUnreadNotification: true,
              onNotificationTap: () {},
              height: 150,
            ),
            Transform.translate(
              offset: const Offset(0, -18),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Manager pending approval strip (P0 MSS requirement)
                    if (isManager) ...[
                      _buildManagerApprovalStrip(context, colors),
                      const SizedBox(height: 12),
                    ],

                    // Attendance / Shift Card (Thẻ số dư & ca làm)
                    _buildAttendanceCard(context, colors),
                    const SizedBox(height: 16),

                    // Quick Actions
                    _buildQuickActions(context, colors),
                    const SizedBox(height: 16),

                    // Demo Switch Role Info Card
                    _buildDemoRoleSwitcher(context, colors, isManager),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagerApprovalStrip(BuildContext context, AppColorsExtension colors) {
    return AppCard(
      backgroundColor: colors.accentAmber.withValues(alpha: 0.12),
      borderColor: colors.accentAmber.withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: () => context.go(AppRoutes.approvals),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.accentAmber,
              shape: BoxShape.circle,
            ),
            child: const Icon(Symbols.assignment_late, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '3 yêu cầu đang chờ bạn phê duyệt',
                  style: AppTextStyles.labelMedium(color: colors.textPrimary).copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '2 đơn nghỉ phép • 1 đề xuất tăng ca',
                  style: AppTextStyles.bodySmall(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          Icon(Symbols.chevron_right, color: colors.accentAmber, size: 20),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context, AppColorsExtension colors) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CA LÀM VIỆC HÔM NAY',
                    style: AppTextStyles.labelMicro(color: colors.textTertiary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ca Hành chính (08:30 - 17:30)',
                    style: AppTextStyles.titleMedium(color: colors.textPrimary).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.pineGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Đúng giờ',
                  style: AppTextStyles.labelMicro(color: colors.pineGreen).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTimeMetric(
                  'Giờ vào',
                  '08:24',
                  Symbols.login,
                  colors,
                ),
              ),
              Container(width: 1, height: 36, color: colors.border),
              Expanded(
                child: _buildTimeMetric(
                  'Giờ ra (dự kiến)',
                  '17:30',
                  Symbols.logout,
                  colors,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AmberCtaButton(
            text: 'Chấm công Quét mặt',
            icon: Symbols.face,
            onPressed: () => context.push(
              AppRoutes.checkInCamera,
              extra: AttendanceType.checkIn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeMetric(
    String label,
    String time,
    IconData icon,
    AppColorsExtension colors,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.textTertiary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelMicro(color: colors.textTertiary)),
              Text(
                time,
                style: AppTextStyles.titleMedium(color: colors.textPrimary).copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, AppColorsExtension colors) {
    return Row(
      children: [
        Expanded(
          child: AppCard(
            onTap: () => context.go(AppRoutes.requests),
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Icon(Symbols.event_available, color: colors.primaryIndigo, size: 28),
                const SizedBox(height: 8),
                Text(
                  'Xin nghỉ phép',
                  style: AppTextStyles.labelMedium(color: colors.textPrimary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppCard(
            onTap: () => context.go(AppRoutes.payroll),
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Icon(Symbols.account_balance_wallet, color: colors.accentAmber, size: 28),
                const SizedBox(height: 8),
                Text(
                  'Bảng lương',
                  style: AppTextStyles.labelMedium(color: colors.textPrimary),
                ),
              ],
            ),
          ),
        ),
      ],
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
              style: AppTextStyles.labelMedium(color: colors.primaryIndigo).copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
