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
import 'package:vstech_hrm/core/widgets/month_picker_button.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_correction_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_leave_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_overtime_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/new_request_bottom_sheet.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_card.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/requests_category_tiles.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/requests_role_indicator.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/requests_summary_header.dart';

/// Screen listing leave, overtime, correction, shift swap and off-site requests.
class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  int _selectedTab = 0;
  String _selectedMonth = 'Tháng 9, 2026';
  bool _isLoading = false;
  List<RequestData> _requests = [];

  @override
  void initState() {
    super.initState();
    unawaited(_loadRequests());
  }

  Future<void> _loadRequests() async {
    setState(() => _isLoading = true);
    final leaveResult = await sl<GetLeaveRequestsUseCase>()();
    final otResult = await sl<GetOvertimeRequestsUseCase>()();
    final corrResult = await sl<GetCorrectionRequestsUseCase>()(personal: true);

    if (!mounted) return;
    final items = <RequestData>[];

    void addReq(String mark, String type, String dates, bool ok, bool rej, String key) {
      final code = ok ? 2 : (rej ? 3 : 1);
      final text = ok ? 'Đã duyệt' : (rej ? 'Từ chối' : 'Chờ duyệt');
      items.add(RequestData(
        mark: mark,
        type: type,
        dates: dates,
        status: text,
        statusCode: code,
        stage: text,
        completedSteps: code,
        requestTypeKey: key,
      ));
    }

    leaveResult.fold((_) {}, (list) {
      for (final l in list) {
        final start = l.from ?? l.validFrom ?? '';
        final end = l.to ?? l.validTo ?? '';
        addReq('P', '${l.leavePlan} · ${l.code}', '$start - $end', l.isApproved, l.isRejected, 'leave');
      }
    });

    otResult.fold((_) {}, (list) {
      for (final o in list) {
        addReq('T', '${o.overtimeReason ?? 'Tăng ca'} · ${o.length ?? 0}h', '${o.date ?? ''} (${o.timeRange ?? ''})', o.isApproved, o.isRejected, 'ot');
      }
    });

    corrResult.fold((_) {}, (list) {
      for (final c in list) {
        addReq('S', 'Sửa công · ${c.reasonTypeName ?? 'Giải trình'}', '${c.workDate ?? ''} (${c.worktime ?? 0}h)', c.isApproved, c.isReject, 'correction');
      }
    });

    setState(() {
      _isLoading = false;
      _requests = items;
    });
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
                  onTap: () => unawaited(NewRequestBottomSheet.show(context)),
                  child: const Center(
                    child: AppIcon(
                      AppIcons.plus,
                      color: Color(0xFF1C1408),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          RequestsRoleIndicator(isManager: isManager),
          const RequestsSummaryHeader(),
          const RequestsCategoryTiles(),

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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadRequests,
                    child: filtered.isEmpty
                        ? ListView(
                            children: [
                              100.gapH,
                              Center(
                                child: Text(
                                  l10n.noRequestsInMonth(_selectedMonth),
                                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) => 11.gapH,
                            itemBuilder: (ctx, index) {
                              final item = filtered[index];
                              return InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () => unawaited(_openDetail(item, index)),
                                child: RequestCard(item: item),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDetail(RequestData item, int index) {
    return context.push(
      AppRoutes.requestDetail,
      extra: {
        'code': 'RQ-2026-09${20 + index}',
        'title': item.type,
        'category': item.requestTypeKey,
        'requesterName': 'Nguyễn Minh Tuấn (NV-04821)',
        'initialStatus': item.statusCode == 2
            ? 'approved'
            : item.statusCode == 3
                ? 'rejected'
                : 'pending',
        'isApprover': false,
      },
    );
  }
}
