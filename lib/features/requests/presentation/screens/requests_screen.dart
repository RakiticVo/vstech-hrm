import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/month_picker_button.dart';
import 'package:vstech_hrm/core/widgets/month_picker_dialog.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';
import 'package:vstech_hrm/features/requests/presentation/helpers/requests_badge_handler.dart';
import 'package:vstech_hrm/features/requests/presentation/helpers/requests_loader.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/new_request_bottom_sheet.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_card.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/requests_category_tiles.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/requests_summary_header.dart';

/// Screen listing leave, overtime, correction, shift swap and off-site requests.
class RequestsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  int _selectedTab = 0;
  late String _selectedMonth;
  bool _isLoading = false;
  List<RequestData> _requests = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = 'Tháng ${now.month}, ${now.year}';
    unawaited(_loadRequests());
  }

  Future<void> _loadRequests() async {
    setState(() => _isLoading = true);
    final items = await RequestsLoader.loadRequests(
      selectedMonth: _selectedMonth,
    );
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _requests = items;
    });
    RequestsBadgeHandler.updateCount(
      items.where((r) => r.statusCode == 1).length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final tabs = [
      l10n.tabAll,
      l10n.tabPending,
      l10n.tabApproved,
      l10n.tabRejected,
    ];

    final filtered = _requests.where((r) {
      final matchesTab = _selectedTab == 0 || r.statusCode == _selectedTab;
      final matchesMonth = AppMonthPickerDialog.matchesMonth(
        r.dates,
        _selectedMonth,
        context,
      );
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(13),
                  onTap: () => unawaited(NewRequestBottomSheet.show(context)),
                  child: Center(
                    child: AppIcon(
                      AppIcons.plus,
                      size: 20,
                      color: colors.tealPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          RequestsSummaryHeader(
            pendingCount: _requests.where((r) => r.statusCode == 1).length,
            approvedCount: _requests.where((r) => r.statusCode == 2).length,
            rejectedCount: _requests.where((r) => r.statusCode == 3).length,
            onTabSelected: (tab) => setState(() => _selectedTab = tab),
          ),
          RequestsCategoryTiles(
            leavePendingCount: _requests
                .where((r) => r.requestTypeKey == 'leave' && r.statusCode == 1)
                .length,
            otPendingCount: _requests
                .where((r) => r.requestTypeKey == 'ot' && r.statusCode == 1)
                .length,
            correctionPendingCount: _requests
                .where(
                  (r) => r.requestTypeKey == 'correction' && r.statusCode == 1,
                )
                .length,
          ),

          // Month selector row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.monthlyRequestsTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.textSecondary,
                  ),
                ),
                MonthPickerButton(
                  selectedMonth: _selectedMonth,
                  onMonthChanged: (m) {
                    setState(() => _selectedMonth = m);
                    unawaited(_loadRequests());
                  },
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
                        color: isSelected
                            ? colors.primaryIndigo
                            : colors.surface,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: isSelected
                              ? colors.primaryIndigo
                              : colors.border,
                        ),
                      ),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? const Color(0xFFFFF8EC)
                              : colors.textSecondary,
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
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: colors.textSecondary,
                                  ),
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
                                onTap: () =>
                                    unawaited(_openDetail(item, index)),
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

  Future<void> _openDetail(RequestData item, int index) async {
    final fields = <(String, String)>[
      ('Mã yêu cầu', item.code ?? 'RQ-2026-09${20 + index}'),
      ('Loại yêu cầu', item.type),
      ('Thời gian', item.dates),
      ('Trạng thái', item.status),
      if (item.confirmerName != null && item.confirmerName!.isNotEmpty)
        ('Người xác nhận', item.confirmerName!),
      if (item.reason != null && item.reason!.isNotEmpty)
        ('Lý do', item.reason!),
      if (item.worktime != null) ('Số giờ', '${item.worktime}h'),
    ];

    final res = await context.push(
      AppRoutes.requestDetail,
      extra: {
        'code': item.code ?? 'RQ-2026-09${20 + index}',
        'title': item.type,
        'category': item.requestTypeKey,
        'requesterName': item.requesterName ?? 'Nhân viên',
        'initialStatus': item.statusCode == 2
            ? 'approved'
            : (item.statusCode == 3 ? 'rejected' : 'pending'),
        'isApprover': false,
        'fields': fields,
      },
    );
    if (res == true || res == 'cancelled') await _loadRequests();
  }
}
