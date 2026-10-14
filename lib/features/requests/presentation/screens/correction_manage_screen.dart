import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_correction_requests_usecase.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/request_card.dart';

/// Screen 13: Dedicated Timesheet Correction Management Screen (`correction` in mockup & flow).
class CorrectionManageScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<CorrectionManageScreen> createState() => _CorrectionManageScreenState();
}

class _CorrectionManageScreenState extends State<CorrectionManageScreen> {
  bool _isLoading = false;
  List<RequestData> _correctionRequests = [];

  @override
  void initState() {
    super.initState();
    unawaited(_loadData());
  }

  Future<void> _loadData() async {
    if (!sl.isRegistered<GetCorrectionRequestsUseCase>()) return;
    setState(() => _isLoading = true);
    final result = await sl<GetCorrectionRequestsUseCase>()();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _isLoading = false),
      (entities) {
        setState(() {
          _isLoading = false;
          _correctionRequests = entities.map((e) {
            final statusCode = e.isApproved ? 2 : (e.isReject ? 3 : 1);
            final statusText = e.isApproved
                ? 'Đã duyệt'
                : (e.isReject ? 'Từ chối' : 'Chờ duyệt');
            return RequestData(
              mark: 'S',
              type: 'Sửa công · ${e.reasonTypeName ?? 'Giải trình'}',
              dates: '${e.workDate ?? ''} (${e.worktime ?? 0}h)',
              status: statusText,
              statusCode: statusCode,
              stage: statusText,
              completedSteps: statusCode,
              requestTypeKey: 'correction',
              code: 'TC-${e.id}',
              requesterName: e.employeeName,
              reason: e.note ?? e.reasonTypeName,
              worktime: e.worktime,
              confirmerName: e.confirmerName,
            );
          }).toList();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Quota Usage Card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.correctionQuotaTitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: colors.textSecondary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colors.accentAmber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l10n.correctionQuotaUsage('1', '3'),
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: colors.accentAmber,
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.gapH,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 1 / 3,
                      minHeight: 8,
                      backgroundColor: colors.borderSubtle,
                      valueColor: AlwaysStoppedAnimation(colors.accentAmber),
                    ),
                  ),
                  6.gapH,
                  Text(
                    'Tối đa 3 lần/tháng theo quy định Điều 107 BLLĐ · gửi trước ngày 20',
                    style: TextStyle(fontSize: 11, color: colors.textTertiary),
                  ),
                ],
              ),
            ),
          ),

          // Missing Punch Warning Alert Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colors.error.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: AppIcon(AppIcons.alertTriangle, size: 20, color: colors.error),
                    ),
                  ),
                  12.gapW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thứ Ba, 15/09 · Thiếu giờ ra',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                        2.gapH,
                        Text(
                          'Giờ vào: 07:56 · Giờ ra: Chưa ghi nhận',
                          style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.error,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      await context.push(AppRoutes.attendanceCorrection);
                      if (mounted) unawaited(_loadData());
                    },
                    child: Text(
                      l10n.fixPunchBtn,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ),
          12.gapH,

          // List of Correction Requests
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadData,
                    child: _correctionRequests.isEmpty
                        ? ListView(
                            children: [
                              60.gapH,
                              Center(
                                child: Text(
                                  'Chưa có yêu cầu sửa công nào',
                                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            itemCount: _correctionRequests.length,
                            separatorBuilder: (_, _) => 10.gapH,
                            itemBuilder: (ctx, index) {
                              final req = _correctionRequests[index];
                              return InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () => context.push(
                                  AppRoutes.requestDetail,
                                  extra: {
                                    'code': req.code ?? 'TC',
                                    'title': req.type,
                                    'category': 'correction',
                                    'requesterName': req.requesterName ?? 'Nhân viên',
                                    'initialStatus': req.statusCode == 2
                                        ? 'approved'
                                        : (req.statusCode == 3 ? 'rejected' : 'pending'),
                                    'isApprover': false,
                                    'fields': [
                                      ('Mã đơn', req.code ?? 'TC'),
                                      ('Thời gian', req.dates),
                                      if (req.worktime != null) ('Giờ công', '${req.worktime} giờ'),
                                      ('Trạng thái', req.status),
                                      if (req.confirmerName != null && req.confirmerName!.isNotEmpty) ('Người xác nhận', req.confirmerName!),
                                      if (req.reason != null && req.reason!.isNotEmpty) ('Lý do / Giải trình', req.reason!),
                                    ],
                                  },
                                ),
                                child: RequestCard(item: req),
                              );
                            },
                          ),
                  ),
          ),

          // Bottom Action Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: PrimaryButton(
              text: 'Tạo yêu cầu sửa công',
              iconName: AppIcons.correction,
              onPressed: () async {
                await context.push(AppRoutes.attendanceCorrection);
                if (mounted) unawaited(_loadData());
              },
            ),
          ),
        ],
      ),
    );
  }
}
