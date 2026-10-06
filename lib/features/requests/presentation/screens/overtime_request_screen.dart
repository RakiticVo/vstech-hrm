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
import 'package:vstech_hrm/features/requests/domain/entities/overtime_type_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/create_overtime_request_usecase.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_overtime_types_usecase.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_request_modal.dart';

/// Screen 11: Register Overtime hours with estimate calculator and interactive input modal.
class OvertimeRequestScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<OvertimeRequestScreen> createState() => _OvertimeRequestScreenState();
}

class _OvertimeRequestScreenState extends State<OvertimeRequestScreen> {
  List<OvertimeTypeEntity> _types = [];
  OvertimeTypeEntity? _selectedType;
  DateTime _date = DateTime.now();
  String _time = '18:00 — 21:00';
  double _length = 3;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadTypes());
  }

  Future<void> _loadTypes() async {
    final res = await sl<GetOvertimeTypesUseCase>()();
    if (!mounted) return;
    res.fold((_) {}, (types) {
      if (types.isNotEmpty) {
        setState(() {
          _types = types;
          _selectedType = types.first;
        });
      }
    });
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  void _openInputModal() {
    unawaited(
      OvertimeRequestModal.show(
        context,
        initialDate: _date,
        availableTypes: _types,
        initialTypeCode: _selectedType?.code,
        onConfirm: (type, date, start, end, length, reason) async {
          setState(() {
            _selectedType = type;
            _date = date;
            _length = length;
            final startStr = '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
            final endStr = '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
            _time = '$startStr — $endStr';
          });
          await _submitOvertime(type, date, start, end, length, reason);
        },
      ),
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

    setState(() => _isSubmitting = true);
    final params = CreateOvertimeParams(
      employeeCode: empCode,
      date: date.toIso8601String(),
      startOvertime: start.toIso8601String(),
      endOvertime: end.toIso8601String(),
      length: length,
      overtimeTypeCode: type.code,
      note: reason,
    );

    final result = await sl<CreateOvertimeRequestUseCase>()(params);
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final l10n = context.l10n;
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message), backgroundColor: Colors.red),
        );
      },
      (_) {
        unawaited(
          AppSuccessDialog.show(
            context,
            title: l10n.overtimeSubmittedTitle,
            message: l10n.overtimeSubmittedMsg(_formatDate(date), _time),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final scale = _selectedType?.scale ?? 1.5;

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
          l10n.requestTypeOvertime,
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
              onPressed: _isSubmitting ? null : _openInputModal,
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
              Expanded(child: _buildStatCard(l10n.thisMonthStat, '12h', colors.textPrimary, colors)),
              10.gapW,
              Expanded(child: _buildStatCard(l10n.paidStat, '1.8M', colors.primaryIndigo, colors)),
            ],
          ),
          16.gapH,

          // Tăng ca mới
          Text(l10n.newOvertimeRequestSection, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
          10.gapH,
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: _openInputModal,
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.border),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildFormRow('Ngày', _formatDate(_date), colors),
                  Divider(height: 20, color: colors.border.withValues(alpha: 0.6)),
                  _buildFormRow('Giờ', _time, colors),
                  Divider(height: 20, color: colors.border.withValues(alpha: 0.6)),
                  _buildFormRow(l10n.totalLabel, '${_length.toStringAsFixed(1)}h · x${scale.toStringAsFixed(1)}', colors, isHighlight: true),
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
          6.gapH,
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
