import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/app_success_dialog.dart';
import 'package:vstech_hrm/core/widgets/app_toast.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/create_correction_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_correction_reasons_usecase.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/attendance_correction_modal.dart';

/// Screen 12: Attendance Correction with quick creation modal and warning alert.
class AttendanceCorrectionScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<AttendanceCorrectionScreen> createState() => _AttendanceCorrectionScreenState();
}

class _AttendanceCorrectionScreenState extends State<AttendanceCorrectionScreen> {
  List<CorrectionReasonEntity> _reasons = [];
  CorrectionReasonEntity? _selectedReason;
  DateTime _date = DateTime.now().subtract(const Duration(days: 1));
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadReasons());
  }

  Future<void> _loadReasons() async {
    final res = await sl<GetCorrectionReasonsUseCase>()();
    if (!mounted) return;
    res.fold((_) {}, (reasons) {
      if (reasons.isNotEmpty) {
        setState(() {
          _reasons = reasons;
          _selectedReason = reasons.first;
        });
      }
    });
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';

  void _openModal() {
    unawaited(
      AttendanceCorrectionModal.show(
        context,
        initialDate: _date,
        availableReasons: _reasons,
        initialReasonCode: _selectedReason?.code,
        onConfirm: (reason, date, worktime, note, imageUrl) async {
          setState(() {
            _selectedReason = reason;
            _date = date;
          });
          await _submitCorrection(reason, date, worktime, note, imageUrl);
        },
      ),
    );
  }

  Future<void> _submitCorrection(
    CorrectionReasonEntity reason,
    DateTime date,
    double worktime,
    String note,
    String? imageUrl,
  ) async {
    final authState = context.read<AuthCubit>().state;
    final empCode = authState is Authenticated ? authState.user.employeeCode : 'NV001';

    setState(() => _isSubmitting = true);
    final params = CreateCorrectionParams(
      employeeCode: empCode,
      workDate: date.toIso8601String(),
      worktime: worktime,
      reasonTypeCode: reason.code,
      note: note,
      imageUrl: imageUrl,
      latitude: 10.7769,
      longitude: 106.7009,
      address: 'Trụ sở chính VSTech',
    );

    final result = await sl<CreateCorrectionRequestUseCase>()(params);
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final l10n = context.l10n;
    result.fold(
      (failure) => context.showErrorToast(failure.message),
      (_) {
        unawaited(
          AppSuccessDialog.show(
            context,
            title: l10n.correctionSubmittedTitle,
            message: l10n.correctionSubmittedMsg(reason.name, _formatDate(date), '${worktime.toStringAsFixed(1)}h'),
          ),
        );
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
          icon: const AppIcon(AppIcons.back, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.requestTypeCorrection,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.textPrimary),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: const Color(0xFF1C1408),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _isSubmitting ? null : _openModal,
              child: _isSubmitting
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                  : Text(l10n.submitRequestButton, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          // 2 Stats Cards
          Row(
            children: [
              Expanded(child: _buildStatCard(l10n.thisMonthStat, '2 đơn', colors.textPrimary, colors)),
              10.gapW,
              Expanded(child: _buildStatCard(l10n.needsActionStat, '1 ngày', const Color(0xFFE11D48), colors)),
            ],
          ),
          14.gapH,

          // Red Warning alert banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4E6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFDA4AF)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppIcon(AppIcons.warning, size: 18, color: Color(0xFFE11D48)),
                8.gapW,
                Expanded(
                  child: Text(
                    l10n.correctionWarningBanner,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFE11D48), height: 1.35),
                  ),
                ),
              ],
            ),
          ),
          18.gapH,

          // Yêu cầu sửa công mới preview card
          Text(l10n.newCorrectionRequestSection, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
          10.gapH,
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: _openModal,
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.border),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildFormRow(l10n.correctionDateLabel, _formatDate(_date), colors),
                  Divider(height: 20, color: colors.border.withValues(alpha: 0.6)),
                  _buildFormRow(l10n.correctionIssueTitle, _selectedReason?.name ?? 'Quên chấm công', colors),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color valueColor, AppColorsExtension colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildFormRow(String label, String value, AppColorsExtension colors, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: colors.textSecondary))),
        8.gapW,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: isHighlight ? colors.primaryIndigo : colors.textPrimary)),
            4.gapW,
            AppIcon(AppIcons.correction, size: 14, color: colors.textTertiary),
          ],
        ),
      ],
    );
  }
}
