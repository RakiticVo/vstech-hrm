import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
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

  final _tabs = const ['Tất cả', 'Chờ duyệt', 'Đã duyệt', 'Từ chối'];

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
              Text('Tạo yêu cầu mới', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colors.textPrimary)),
              const SizedBox(height: 14),
              _buildOptionTile(ctx, Symbols.beach_access, 'Xin nghỉ phép', AppRoutes.leaveCreate, colors),
              _buildOptionTile(ctx, Symbols.schedule, 'Đăng ký tăng ca', AppRoutes.overtimeCreate, colors),
              _buildOptionTile(ctx, Symbols.edit_note, 'Sửa công', AppRoutes.attendanceCorrection, colors),
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
    final authState = context.watch<AuthCubit>().state;
    final isManager = authState is Authenticated && authState.role.isManager;

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
            title: 'Trung tâm yêu cầu',
            subtitle: 'Nghỉ phép · Tăng ca · Sửa công',
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
                Text('Yêu cầu theo tháng', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
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
                itemCount: _tabs.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
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
                        _tabs[index],
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
                      'Không có yêu cầu nào trong $_selectedMonth',
                      style: TextStyle(fontSize: 13, color: colors.textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 11),
                    itemBuilder: (ctx, index) => RequestCard(item: filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleIndicator(bool isManager, AppColorsExtension colors) {
    if (!isManager) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: colors.cardSecondary,
        child: Row(
          children: [
            Icon(Symbols.info, size: 16, color: colors.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Xem vai trò Quản lý:', style: TextStyle(fontSize: 12, color: colors.textSecondary, fontWeight: FontWeight.w600)),
            ),
            GestureDetector(
              onTap: () async {
                await context.read<AuthCubit>().loginAsDemo(UserRole.manager);
                if (mounted) context.go(AppRoutes.approvals);
              },
              child: Text('Đổi sang QL (mục Duyệt)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: colors.accentAmber)),
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
          const SizedBox(width: 8),
          Expanded(
            child: Text('Bạn có 9 yêu cầu chờ phê duyệt', style: TextStyle(fontSize: 12, color: colors.textPrimary, fontWeight: FontWeight.w700)),
          ),
          GestureDetector(
            onTap: () => context.go(AppRoutes.approvals),
            child: Text('Mở mục Duyệt >', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: colors.primaryIndigo)),
          ),
        ],
      ),
    );
  }
}
