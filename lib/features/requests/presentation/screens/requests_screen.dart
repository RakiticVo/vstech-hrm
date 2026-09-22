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
import 'package:vstech_hrm/core/widgets/month_picker_button.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_card.dart';

/// Screen listing leave, overtime, and correction requests with month and status filters.
class RequestsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  int _selectedTab = 0;
  String _selectedMonth = 'Tháng 9, 2026';

  final _requests = const [
    RequestData(
      mark: 'P',
      type: 'Nghỉ phép năm · 3 ngày',
      dates: '21–23/09/2026',
      status: 'Chờ duyệt',
      statusCode: 1,
      stage: 'Chờ quản lý',
      completedSteps: 1,
    ),
    RequestData(
      mark: 'T',
      type: 'Tăng ca · 3 giờ',
      dates: '12/09/2026',
      status: 'Đã duyệt',
      statusCode: 2,
      stage: 'Hoàn tất',
      completedSteps: 4,
    ),
    RequestData(
      mark: 'C',
      type: 'Công tác · Hà Nội',
      dates: '21–23/09/2026',
      status: 'Chờ duyệt',
      statusCode: 1,
      stage: 'Chờ giám đốc',
      completedSteps: 3,
    ),
    RequestData(
      mark: 'S',
      type: 'Sửa công · thiếu giờ ra',
      dates: '15/09/2026',
      status: 'Cần bổ sung',
      statusCode: 1,
      stage: 'Chờ HR',
      completedSteps: 2,
    ),
    RequestData(
      mark: 'P',
      type: 'Nghỉ không lương · 1 ngày',
      dates: '28/08/2026',
      status: 'Từ chối',
      statusCode: 3,
      stage: 'Từ chối',
      completedSteps: 1,
    ),
  ];

  void _showNewRequestSheet(BuildContext context, AppColorsExtension colors) {
    final l10n = context.l10n;
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: colors.surface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
        builder: (ctx) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.createNewRequestTitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colors.textPrimary)),
              14.gapH,
              _buildOptionTile(ctx, Symbols.beach_access, l10n.requestTypeLeave, AppRoutes.leaveCreate, colors),
              _buildOptionTile(ctx, Symbols.schedule, l10n.requestTypeOvertime, AppRoutes.overtimeCreate, colors),
              _buildOptionTile(ctx, Symbols.edit_note, l10n.requestTypeCorrection, AppRoutes.attendanceCorrection, colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext ctx, IconData icon, String title, String route, AppColorsExtension colors) {
    return ListTile(
      leading: Icon(icon, color: colors.primaryIndigo),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      onTap: () {
        Navigator.pop(ctx);
        unawaited(context.push(route));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final authState = context.watch<AuthCubit>().state;
    final isManager = authState is Authenticated && authState.role.isManager;

    final tabs = [l10n.tabAll, l10n.tabPending, l10n.tabApproved, l10n.tabRejected];

    final filtered = _requests.where((r) {
      final matchesTab = _selectedTab == 0 || r.statusCode == _selectedTab;
      final matchesMonth = _selectedMonth == 'Tất cả' ||
          (_selectedMonth.contains('9') && r.dates.contains('09/')) ||
          (_selectedMonth.contains('8') && r.dates.contains('08/')) ||
          (_selectedMonth.contains('7') && r.dates.contains('07/')) ||
          (_selectedMonth.contains('6') && r.dates.contains('06/'));
      return matchesTab && matchesMonth;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          TileHeaderBanner(
            title: l10n.requestsCenterTitle,
            subtitle: l10n.requestsCenterSubtitle,
            trailing: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: colors.accentAmber, borderRadius: BorderRadius.circular(13)),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(13),
                  onTap: () => _showNewRequestSheet(context, colors),
                  child: const Center(child: Icon(Symbols.add, color: Color(0xFF1C1408), size: 22, weight: 700)),
                ),
              ),
            ),
          ),
          _buildRoleIndicator(isManager, colors),

          // Month selector row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.monthlyRequestsTitle, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
                MonthPickerButton(
                  selectedMonth: _selectedMonth,
                  onMonthChanged: (m) => setState(() => _selectedMonth = m),
                  isCompact: true,
                ),
              ],
            ),
          ),

          // Filter tabs
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                separatorBuilder: (_, _) => 8.gapW,
                itemBuilder: (ctx, index) {
                  final isSelected = _selectedTab == index;
                  return InkWell(
                    borderRadius: BorderRadius.circular(11),
                    onTap: () => setState(() => _selectedTab = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? colors.primaryIndigo : colors.surface,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(color: isSelected ? colors.primaryIndigo : colors.border),
                      ),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? const Color(0xFFFFF8EC) : colors.textSecondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Requests list
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      l10n.noRequestsInMonth(_selectedMonth),
                      style: TextStyle(fontSize: 13, color: colors.textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => 11.gapH,
                    itemBuilder: (ctx, index) => RequestCard(item: filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleIndicator(bool isManager, AppColorsExtension colors) {
    final l10n = context.l10n;

    if (!isManager) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: colors.cardSecondary,
        child: Row(
          children: [
            Icon(Symbols.info, size: 16, color: colors.textSecondary),
            8.gapW,
            Expanded(
              child: Text(l10n.roleIndicatorEmployee, style: TextStyle(fontSize: 12, color: colors.textSecondary, fontWeight: FontWeight.w600)),
            ),
            GestureDetector(
              onTap: () async {
                await context.read<AuthCubit>().loginAsDemo(UserRole.manager);
                if (mounted) context.go(AppRoutes.approvals);
              },
              child: Text(l10n.roleIndicatorSwitchToManager, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: colors.accentAmber)),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: colors.accentAmber.withValues(alpha: 0.15),
      child: Row(
        children: [
          Icon(Symbols.fact_check, size: 16, color: colors.accentAmber),
          8.gapW,
          Expanded(
            child: Text(l10n.managerPendingApprovalsBanner(9), style: TextStyle(fontSize: 12, color: colors.textPrimary, fontWeight: FontWeight.w700)),
          ),
          GestureDetector(
            onTap: () => context.go(AppRoutes.approvals),
            child: Text(l10n.openApprovalsLink, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: colors.primaryIndigo)),
          ),
        ],
      ),
    );
  }
}
