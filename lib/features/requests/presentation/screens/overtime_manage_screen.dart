import 'dart:async';
import 'package:flutter/material.dart';
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
import 'package:vstech_hrm/core/widgets/app_toast.dart';
import 'package:vstech_hrm/core/widgets/month_picker_button.dart';
import 'package:vstech_hrm/core/widgets/month_picker_dialog.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_item_entity.dart';
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
  late String _selectedMonth;
  String _selectedStatus = 'all';
  bool _isLoading = false;
  bool _isSubmitting = false;
  List<OvertimeItemEntity> _rawOvertimeEntities = [];
  List<RequestData> _overtimeRequests = [];
  List<OvertimeTypeEntity> _overtimeTypes = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = 'Tháng ${now.month}, ${now.year}';
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
    final range = AppMonthPickerDialog.getMonthDateRange(_selectedMonth);
    final result = await sl<GetOvertimeRequestsUseCase>()(month: range?.from);
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _isLoading = false),
      (entities) {
        setState(() {
          _isLoading = false;
          _rawOvertimeEntities = entities;
          _overtimeRequests = entities.map((e) {
            final rawTn = e.overtimeTypeName?.trim();
            final typeName = (rawTn != null && rawTn.isNotEmpty && rawTn != '.')
                ? rawTn
                : (_overtimeTypes.where((t) => t.code == e.overtimeTypeCode).firstOrNull?.name ??
                    ((e.overtimeReason?.trim().isNotEmpty == true && e.overtimeReason != '.') ? e.overtimeReason!.trim() : 'Tăng ca'));
            final len = e.length ?? 0;
            final typeTitle = len > 0 ? '$typeName · ${len % 1 == 0 ? len.toInt() : len} giờ' : typeName;
            final statusCode = e.isApproved ? 2 : (e.isRejected ? 3 : 1);
            final cBy = e.createdByName ?? e.createdByCode;
            return RequestData(
              mark: 'T',
              type: typeTitle,
              dates: '${e.date ?? ''} (${e.timeRange ?? ''})',
              status: e.statusText,
              statusCode: statusCode,
              stage: e.statusText,
              completedSteps: statusCode,
              requestTypeKey: 'ot',
              code: e.code,
              requesterName: e.employeeName,
              reason: e.note ?? e.overtimeReason,
              worktime: e.length,
              createdBy: cBy,
              isProxy: e.isCreatedByOther,
              confirmerName: e.confirmedBy,
            );
          }).toList();
        });
      },
    );
  }

  AuthState? _auth() => sl.isRegistered<AuthCubit>() ? sl<AuthCubit>().state : null;

  Future<void> _showCreateOvertimeModal() async {
    final auth = _auth();
    final isManager = auth is Authenticated &&
        (auth.user.role.isManager || auth.user.role.isAdmin || auth.user.claims.contains('manager.approve') || auth.user.claims.contains('hr:admin'));
    await OvertimeRequestModal.show(context, initialDate: DateTime.now(), availableTypes: _overtimeTypes, isManager: isManager, onConfirm: _submitOvertime);
  }

  Future<String?> _submitOvertime(
    OvertimeTypeEntity type,
    DateTime date,
    DateTime start,
    DateTime end,
    double length,
    String reason, {
    String? employeeCode,
    String? employeeName,
    bool? accept,
  }) async {
    if (_isSubmitting) return 'Đang gửi yêu cầu...';
    setState(() => _isSubmitting = true);

    try {
      final auth = _auth();
      final curEmp = auth is Authenticated ? auth.user.employeeCode : 'NV001';
      final empCode = employeeCode ?? curEmp;
      final isSub = employeeCode != null && employeeCode != curEmp;
      final ymd = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final sTime = '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
      final eTime = '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';

      final params = CreateOvertimeParams(
        employeeCode: empCode,
        adminEmployeeCode: isSub ? empCode : null,
        accept: accept,
        date: ymd,
        length: length,
        overtimeTypeCode: type.code,
        startOvertime: '${ymd}T$sTime:00',
        endOvertime: '${ymd}T$eTime:00',
        note: reason,
      );

      final result = await sl<CreateOvertimeRequestUseCase>()(params);
      if (!mounted) return null;

      if (result.isLeft()) {
        final msg = result.getLeft().toNullable()?.message ?? 'Lỗi gửi yêu cầu tăng ca';
        context.showErrorToast(msg);
        return msg;
      }

      await _loadData();
      if (!mounted) return null;
      final l10n = context.l10n;
      final dStr = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      final msg = isSub
          ? l10n.overtimeSubmittedForSubordinateMsg(dStr, employeeName ?? empCode)
          : l10n.overtimeSubmittedMsg(dStr, '$sTime - $eTime');
      await AppSuccessDialog.show(context, title: l10n.overtimeSubmittedTitle, message: msg);
      return null;
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _openDetail(RequestData req) async {
    final status = req.statusCode == 2 ? 'approved' : (req.statusCode == 3 ? 'rejected' : 'pending');
    final res = await context.push(AppRoutes.requestDetail, extra: {
      'code': req.code ?? req.type, 'title': req.type, 'category': 'ot',
      'requesterName': req.requesterName ?? 'Nhân viên', 'initialStatus': status, 'isApprover': false,
      'fields': [
        ('Mã đơn', req.code ?? req.type),
        if (req.requesterName != null) ('Nhân viên', req.requesterName!),
        if (req.createdBy != null) ('Tạo bởi', req.createdBy!),
        ('Loại OT', req.type), ('Thời gian', req.dates),
        if (req.worktime != null) ('Thời lượng', '${req.worktime} giờ'),
        ('Trạng thái', req.status),
        if (req.confirmerName != null && req.confirmerName!.isNotEmpty) ('Người xác nhận', req.confirmerName!),
        if (req.reason != null && req.reason!.isNotEmpty) ('Lý do', req.reason!),
      ],
    });
    if (res == true || res == 'cancelled') await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final filterOptions = [
      ('all', l10n.leaveStatusFilterAll), ('pending', l10n.leaveStatusFilterPending),
      ('approved', l10n.leaveStatusFilterApproved), ('rejected', l10n.leaveStatusFilterRejected),
    ];

    final filtered = _overtimeRequests.where((req) {
      final matchSt = switch (_selectedStatus) {
        'pending' => req.statusCode == 1,
        'approved' => req.statusCode == 2,
        'rejected' => req.statusCode == 3,
        _ => true,
      };
      return matchSt && AppMonthPickerDialog.matchesMonth(req.dates, _selectedMonth, context);
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: OvertimeSummaryCard.fromEntities(entities: _rawOvertimeEntities),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MonthPickerButton(
                  selectedMonth: _selectedMonth,
                  onMonthChanged: (m) {
                    setState(() => _selectedMonth = m);
                    unawaited(_loadData());
                  },
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
                        ? Center(child: Text(l10n.noOvertimeInMonth(_selectedMonth), style: TextStyle(fontSize: 13, color: colors.textSecondary)))
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) => 10.gapH,
                            itemBuilder: (ctx, index) {
                              final req = filtered[index];
                              return InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () => _openDetail(req),
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
              isLoading: _isSubmitting,
              onPressed: _isSubmitting ? null : () => unawaited(_showCreateOvertimeModal()),
            ),
          ),
        ],
      ),
    );
  }
}
