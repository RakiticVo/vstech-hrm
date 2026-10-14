import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/constants/environment.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/app_card.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';
import 'package:vstech_hrm/core/widgets/tile_section_divider.dart';
import 'package:vstech_hrm/features/approvals/presentation/helpers/approvals_action_handler.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_today_entity.dart';
import 'package:vstech_hrm/features/attendance/domain/usecases/get_today_attendance_usecase.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_announcements.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_balance_card.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_manager_approval_strip.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_quick_actions.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_salary_card.dart';
import 'package:vstech_hrm/features/home/presentation/widgets/home_summary_grid.dart';

import 'package:vstech_hrm/features/schedule/domain/usecases/get_my_shift_schedule_usecase.dart';

/// Main Home Screen for Employee (NV) and Manager (QL).
/// Follows Clean Architecture, AppLayout, and L10n standards.
class HomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pendingCount = 0;
  AttendanceTodayEntity? _todayAttendance;

  @override
  void initState() {
    super.initState();
    unawaited(_loadHomeData());
  }

  Future<void> _loadHomeData() async {
    final authState = context.read<AuthCubit>().state;
    final canApprove = authState is Authenticated && authState.role.canApprove;
    if (canApprove) {
      final items = await ApprovalsActionHandler.loadAllPendingApprovals();
      if (!mounted) return;
      setState(() => _pendingCount = items.where((i) => i.isPending).length);
    }
    final att = await sl<GetTodayAttendanceUseCase>()();
    if (!mounted) return;
    att.fold((_) {}, (attendance) {
      setState(() => _todayAttendance = attendance);
    });

    if (sl.isRegistered<GetMyShiftScheduleUseCase>()) {
      final now = DateTime.now();
      final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final myShiftRes = await sl<GetMyShiftScheduleUseCase>()(from: todayStr, to: todayStr);
      if (!mounted) return;
      myShiftRes.fold((_) {}, (shifts) {
        final todayShift = shifts.firstOrNull;
        if (todayShift != null && mounted) {
          final hasShift = todayShift.hasShift;
          final sName = hasShift
              ? (todayShift.shiftName?.isNotEmpty == true ? todayShift.shiftName! : 'Ca ${todayShift.shiftCode}')
              : context.l10n.noShiftAssigned;
          final sStart = hasShift ? (todayShift.startHour?.isNotEmpty == true ? todayShift.startHour! : '08:00') : '';
          final sEnd = hasShift ? (todayShift.endHour?.isNotEmpty == true ? todayShift.endHour! : '17:00') : '';
          setState(() {
            _todayAttendance = (_todayAttendance ?? AttendanceTodayEntity(
              hasCheckedIn: false,
              hasCheckedOut: false,
              shiftName: sName,
              shiftStart: sStart,
              shiftEnd: sEnd,
              classification: AttendanceClassification.onTime,
              todayDate: todayStr,
            )).copyWith(
              shiftName: sName,
              shiftStart: sStart,
              shiftEnd: sEnd,
            );
          });
        }
      });
    }
  }

  Future<void> _onPunch() async {
    final hasCheckedIn = _todayAttendance?.hasCheckedIn == true;
    final hasCheckedOut = _todayAttendance?.hasCheckedOut == true;
    final type = (hasCheckedIn && !hasCheckedOut)
        ? AttendanceType.checkOut
        : AttendanceType.checkIn;
    await context.push<bool>(
      AppRoutes.checkInCamera,
      extra: type,
    );
    if (mounted) {
      await _loadHomeData();
    }
  }

  String _formatCurrentDate() {
    final now = DateTime.now();
    const weekdays = ['', 'Hai', 'Ba', 'Tư', 'Năm', 'Sáu', 'Bảy', 'Chủ Nhật'];
    final weekdayName = weekdays[now.weekday];
    return 'Thứ $weekdayName, ${now.day} Tháng ${now.month}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final authState = context.watch<AuthCubit>().state;
    final user = authState is Authenticated ? authState.user : null;
    final isManager = authState is Authenticated && authState.role.isManager;

    final userName = user?.name ?? 'Nguyễn Minh Tuấn';
    final userInitials = userName.isNotEmpty ? userName.substring(0, 1) : 'MT';
    final department = user?.department ?? 'VSTech';

    return Scaffold(
      backgroundColor: colors.background,
      body: RefreshIndicator(
        onRefresh: _loadHomeData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              TileHeaderBanner(
                title: '${l10n.greetingMorning}, $userName 👋',
                subtitle: _formatCurrentDate(),
                secondSubtitle: department,
                avatarFallbackText: userInitials,
                trailing: IconButton(
                  icon: const AppIcon(AppIcons.bell, color: Color(0xFFFFF8EC), size: 22),
                  tooltip: l10n.notificationsTitle,
                  onPressed: () => context.push(AppRoutes.notifications),
                ),
                bottomPadding: context.custom(normal: 68, compact: 56),
              ),
              Transform.translate(
                offset: const Offset(0, -46),
                child: Padding(
                  padding: context.paddingCustom(horizontal: 16),
                  child: Column(
                    children: [
                      // Balance card (Worked hours & punch CTA)
                      HomeBalanceCard(
                        todayAttendance: _todayAttendance,
                        onPunchPressed: _onPunch,
                      ),

                      // Manager pending approval strip (P0 MSS requirement)
                      if (isManager) ...[
                        14.gapH,
                        HomeManagerApprovalStrip(pendingCount: _pendingCount),
                      ],

                      // 5 Circular Quick Actions
                      20.gapH,
                      _buildSectionTitle(l10n.homeQuickActionsSection, colors),
                      12.gapH,
                      const HomeQuickActions(),

                      // Saigon Tile Section Divider
                      18.gapH,
                      const TileSectionDivider(),

                      // 2x2 Summary Grid (Ngày công, Phép còn, Tăng ca, Muộn/Sớm)
                      18.gapH,
                      _buildSectionTitle(
                        l10n.homeMonthlyStatsSection,
                        colors,
                        trailing: 'T${DateTime.now().month}/${DateTime.now().year}',
                      ),
                      12.gapH,
                      const HomeSummaryGrid(),

                      // Salary Card with eye toggle
                      20.gapH,
                      const HomeSalaryCard(),

                      // Latest Announcements
                      20.gapH,
                      const HomeAnnouncements(),

                      // Demo Role Switcher (hidden when running live API)
                      if (EnvConfig.useMockData) ...[
                        20.gapH,
                        _buildDemoRoleSwitcher(context, colors, isManager),
                      ],
                      24.gapH,
                    ],
                  ),
                ),
              ),
            ],
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
          AppIcon(AppIcons.profile, size: 20, color: colors.textSecondary),
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
              style: AppTextStyles.labelMedium(color: colors.tealPrimary)
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppColorsExtension colors, {String? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
            letterSpacing: 0.1,
          ),
        ),
        if (trailing != null)
          Text(
            trailing,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
      ],
    );
  }
}
