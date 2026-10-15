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
import 'package:vstech_hrm/features/requests/domain/entities/correction_item_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/create_correction_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_correction_reasons_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_correction_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/attendance_correction_modal.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/correction_summary_card.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_card.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_status_filter_chips.dart';

/// Screen 13: Dedicated Timesheet Correction Management Screen (`correction` in mockup & flow).
class CorrectionManageScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<CorrectionManageScreen> createState() => _CorrectionManageScreenState();
}

class _CorrectionManageScreenState extends State<CorrectionManageScreen> {
  late String _selectedMonth;
  String _selectedStatus = 'all';
  bool _isLoading = false;
  bool _isSubmitting = false;
  List<CorrectionItemEntity> _rawCorrections = [];
  List<RequestData> _correctionRequests = [];
  List<CorrectionReasonEntity> _correctionReasons = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = 'Tháng ${now.month}, ${now.year}';
    unawaited(_loadData());
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    if (sl.isRegistered<GetCorrectionReasonsUseCase>()) {
      final res = await sl<GetCorrectionReasonsUseCase>()();
      res.fold((_) {}, (r) => _correctionReasons = r);
    }
    if (!sl.isRegistered<GetCorrectionRequestsUseCase>()) {
      setState(() => _isLoading = false);
      return;
    }
    final range = AppMonthPickerDialog.getMonthDateRange(_selectedMonth);
    final result = await sl<GetCorrectionRequestsUseCase>()(month: range?.from);
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _isLoading = false),
      (entities) {
        setState(() {
          _isLoading = false;
          _rawCorrections = entities;
          _correctionRequests = entities.map(_mapToRequestData).toList();
        });
      },
    );
  }

  RequestData _mapToRequestData(CorrectionItemEntity e) {
    final statusCode = e.isApproved ? 2 : (e.isReject ? 3 : 1);
    final statusText = e.isApproved
        ? 'Đã duyệt'
        : (e.isReject ? 'Từ chối' : 'Chờ duyệt');
    final reasonName = e.reasonTypeName?.trim().isNotEmpty == true
        ? e.reasonTypeName!.trim()
        : 'Giải trình';
    return RequestData(
      mark: 'S',
      type: 'Sửa công · $reasonName',
      dates: e.workDate ?? '',
      status: statusText,
      statusCode: statusCode,
      stage: statusText,
      completedSteps: statusCode,
      requestTypeKey: 'correction',
      code: 'TC-${e.id}',
      requesterName: e.employeeName,
      reason: e.note ?? e.reasonTypeName,
      worktime: e.confirmedWorktime ?? e.worktime,
      confirmerName: e.confirmerName,
    );
  }

  AuthState? _auth() => sl.isRegistered<AuthCubit>() ? sl<AuthCubit>().state : null;

  Future<void> _showCreateModal() async {
    await AttendanceCorrectionModal.show(
      context,
      initialDate: DateTime.now(),
      availableReasons: _correctionReasons,
      onConfirm: _submitCorrection,
    );
  }

  Future<void> _submitCorrection(
    CorrectionReasonEntity reason,
    DateTime date,
    double worktime,
    String note,
    String? imageUrl,
  ) async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    final auth = _auth();
    final empCode = auth is Authenticated ? auth.user.employeeCode : 'NV001';

    final params = CreateCorrectionParams(
      employeeCode: empCode,
      workDate: date.toIso8601String(),
      worktime: 0,
      reasonTypeCode: reason.code,
      note: note,
      imageUrl: imageUrl,
    );

    final result = await sl<CreateCorrectionRequestUseCase>()(params);
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final l10n = context.l10n;
    await result.fold(
      (failure) async => context.showErrorToast(failure.message),
      (_) async {
        await _loadData();
        if (!mounted) return;
        final dStr = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
        await AppSuccessDialog.show(
          context,
          title: l10n.correctionSubmittedTitle,
          message: l10n.correctionSubmittedMsg(reason.name, dStr, '0h'),
        );
      },
    );
  }

  Future<void> _openDetail(RequestData req) async {
    final status = req.statusCode == 2 ? 'approved' : (req.statusCode == 3 ? 'rejected' : 'pending');
    final res = await context.push(AppRoutes.requestDetail, extra: {
      'code': req.code ?? 'TC',
      'title': req.type,
      'category': 'correction',
      'requesterName': req.requesterName ?? 'Nhân viên',
      'initialStatus': status,
      'isApprover': false,
      'fields': [
        ('Mã đơn', req.code ?? 'TC'),
        ('Thời gian', req.dates),
        if (req.worktime != null && req.worktime! > 0) ('Giờ công', '${req.worktime} giờ'),
        ('Trạng thái', req.status),
        if (req.confirmerName != null && req.confirmerName!.isNotEmpty) ('Người xác nhận', req.confirmerName!),
        if (req.reason != null && req.reason!.isNotEmpty) ('Lý do / Giải trình', req.reason!),
      ],
    });
    if (res == true || res == 'cancelled') await _loadData();
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

    final filtered = _correctionRequests.where((req) {
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
          l10n.correctionManageTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.textPrimary),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: CorrectionSummaryCard(corrections: _rawCorrections),
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
                        ? ListView(
                            children: [
                              60.gapH,
                              Center(
                                child: Text(
                                  l10n.noCorrectionInMonth(_selectedMonth),
                                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                                ),
                              ),
                            ],
                          )
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
              text: l10n.createCorrectionBtn,
              iconName: AppIcons.plus,
              isLoading: _isSubmitting,
              onPressed: _isSubmitting ? null : () => unawaited(_showCreateModal()),
            ),
          ),
        ],
      ),
    );
  }
}
