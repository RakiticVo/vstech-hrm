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
import 'package:vstech_hrm/core/widgets/app_success_dialog.dart';
import 'package:vstech_hrm/core/widgets/month_picker_button.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_type_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/create_overtime_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_overtime_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_overtime_types_usecase.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_request_modal.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_summary_card.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_card.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_status_filter_chips.dart';

/// Screen 12: Dedicated Overtime Management Screen (`overtime` in mockup & flow).
class OvertimeManageScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<OvertimeManageScreen> createState() => _OvertimeManageScreenState();
}

class _OvertimeManageScreenState extends State<OvertimeManageScreen> {
  String _selectedMonth = 'Tháng 9, 2026';
  String _selectedStatus = 'all';
  bool _isLoading = false;
  List<RequestData> _overtimeRequests = [];
  List<OvertimeTypeEntity> _overtimeTypes = [];

  @override
  void initState() {
    super.initState();
    unawaited(_loadData());
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    if (sl.isRegistered<GetOvertimeTypesUseCase>()) {
      final typesRes = await sl<GetOvertimeTypesUseCase>()();
      typesRes.fold((_) {}, (types) => _overtimeTypes = types);
    }
    if (!sl.isRegistered<GetOvertimeRequestsUseCase>()) {
      setState(() => _isLoading = false);
      return;
    }
    final result = await sl<GetOvertimeRequestsUseCase>()();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _isLoading = false),
      (entities) {
        setState(() {
          _isLoading = false;
          _overtimeRequests = entities.map((e) {
            final statusCode = e.status == 0 ? 1 : (e.status == 1 ? 2 : 3);
            return RequestData(
              mark: 'T',
              type: '${e.overtimeReason ?? 'Tăng ca'} · ${e.length ?? 0} giờ',
              dates: '${e.date ?? ''} (${e.timeRange ?? ''})',
              status: e.statusText,
              statusCode: statusCode,
              stage: e.statusText,
              completedSteps: statusCode,
              requestTypeKey: 'ot',
            );
          }).toList();
        });
      },
    );
  }

  Future<void> _showCreateOvertimeModal() async {
    await OvertimeRequestModal.show(
      context,
      initialDate: DateTime.now(),
      availableTypes: _overtimeTypes,
      onConfirm: (type, date, start, end, length, reason) async {
        await _submitOvertime(type, date, start, end, length, reason);
      },
    );
  }

  Future<void> _submitOvertime(
    OvertimeTypeEntity type,
    DateTime date,
    DateTime start,
    DateTime end,
    double length,
    String reason,
  ) async {
    final authState = context.read<AuthCubit>().state;
    final empCode = authState is Authenticated ? authState.user.employeeCode : 'NV001';

    final params = CreateOvertimeParams(
      employeeCode: empCode,
      date: date.toIso8601String(),
      length: length,
      overtimeTypeCode: type.code,
      startOvertime: start.toIso8601String(),
      endOvertime: end.toIso8601String(),
      note: reason,
    );

    final result = await sl<CreateOvertimeRequestUseCase>()(params);
    if (!mounted) return;

    if (result.isLeft()) {
      final failure = result.getLeft().toNullable();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure?.message ?? 'Lỗi gửi yêu cầu tăng ca'), backgroundColor: Colors.red),
      );
      return;
    }

    await _loadData();
    if (!mounted) return;
    final l10n = context.l10n;
    final dateStr = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final timeStr = '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    await AppSuccessDialog.show(
      context,
      title: l10n.overtimeSubmittedTitle,
      message: l10n.overtimeSubmittedMsg(dateStr, timeStr),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final filterOptions = [
      ('all', l10n.leaveStatusFilterAll),
      ('pending', l10n.leaveStatusFilterPending),
      ('approved', l10n.leaveStatusFilterApproved),
      ('rejected', l10n.leaveStatusFilterRejected),
    ];

    final filtered = _overtimeRequests.where((req) {
      if (_selectedStatus == 'pending') return req.statusCode == 1;
      if (_selectedStatus == 'approved') return req.statusCode == 2;
      if (_selectedStatus == 'rejected') return req.statusCode == 3;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const AppIcon(AppIcons.back, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.overtimeManageTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: AppIcon(AppIcons.plus, color: colors.accentAmber, size: 22),
            tooltip: l10n.createOvertimeBtn,
            onPressed: () => unawaited(_showCreateOvertimeModal()),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 10), child: OvertimeSummaryCard()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MonthPickerButton(
                  selectedMonth: _selectedMonth,
                  onMonthChanged: (m) => setState(() => _selectedMonth = m),
                ),
                Text(
                  '${filtered.length} ${l10n.requests.toLowerCase()}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.textSecondary),
                ),
              ],
            ),
          ),
          10.gapH,
          RequestStatusFilterChips(
            selectedStatus: _selectedStatus,
            onStatusChanged: (s) => setState(() => _selectedStatus = s),
            options: filterOptions,
            colors: colors,
          ),
          12.gapH,
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadData,
                    child: filtered.isEmpty
                        ? Center(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Center(
                                  child: Text(
                                    l10n.noOvertimeInMonth(_selectedMonth),
                                    style: TextStyle(fontSize: 13, color: colors.textSecondary),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) => 10.gapH,
                            itemBuilder: (ctx, index) {
                              final req = filtered[index];
                              return InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () => context.push(
                                  AppRoutes.requestDetail,
                                  extra: {
                                    'code': req.type,
                                    'title': req.type,
                                    'category': 'ot',
                                    'requesterName': 'Nhân viên',
                                    'initialStatus': req.statusCode == 2 ? 'approved' : 'pending',
                                    'isApprover': false,
                                  },
                                ),
                                child: RequestCard(item: req),
                              );
                            },
                          ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: PrimaryButton(
              text: l10n.createOvertimeBtn,
              iconName: AppIcons.plus,
              onPressed: () => unawaited(_showCreateOvertimeModal()),
            ),
          ),
        ],
      ),
    );
  }
}
