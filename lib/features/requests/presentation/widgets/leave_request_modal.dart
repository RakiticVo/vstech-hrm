import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/requests/domain/entities/leave_plan_entity.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_leave_plans_usecase.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/leave_modal_components.dart';

typedef LeaveConfirmCallback = void Function(
  LeavePlanEntity plan,
  DateTime from,
  DateTime to,
  double totalDays,
  String? halfShift,
  String reason,
);

/// Modal bottom sheet to pick leave plan, date range, half-day/full-day, and reason.
class LeaveRequestModal extends StatefulWidget {
  const new({
    required this.initialFrom,
    required this.initialTo,
    required this.onConfirm,
    this.availablePlans = const [],
    this.initialPlanCode,
    super.key,
  });

  final DateTime initialFrom;
  final DateTime initialTo;
  final List<LeavePlanEntity> availablePlans;
  final String? initialPlanCode;
  final LeaveConfirmCallback onConfirm;

  static Future<void> show(
    BuildContext context, {
    required DateTime initialFrom,
    required DateTime initialTo,
    required LeaveConfirmCallback onConfirm,
    List<LeavePlanEntity> availablePlans = const [],
    String? initialPlanCode,
  }) {
    final colors = context.colors;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => LeaveRequestModal(
        initialFrom: initialFrom,
        initialTo: initialTo,
        availablePlans: availablePlans,
        initialPlanCode: initialPlanCode,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<LeaveRequestModal> createState() => _LeaveRequestModalState();
}

class _LeaveRequestModalState extends State<LeaveRequestModal> {
  late DateTime _from;
  late DateTime _to;
  LeavePlanEntity? _selectedPlan;
  List<LeavePlanEntity> _plans = [];
  bool _isLoadingPlans = false;
  late TextEditingController _reasonController;
  int _halfDayMode = 0; // 0: full day, 1: morning half, 2: afternoon half

  @override
  void initState() {
    super.initState();
    _from = widget.initialFrom;
    _to = widget.initialTo;
    _reasonController = TextEditingController();

    if (widget.availablePlans.isNotEmpty) {
      _plans = widget.availablePlans;
      _selectedPlan = _plans.firstWhere(
        (p) => p.code == widget.initialPlanCode,
        orElse: () => _plans.first,
      );
    } else {
      unawaited(_fetchPlans());
    }
  }

  Future<void> _fetchPlans() async {
    if (!sl.isRegistered<GetLeavePlansUseCase>()) return;
    setState(() => _isLoadingPlans = true);
    final res = await sl<GetLeavePlansUseCase>()();
    if (!mounted) return;
    res.fold(
      (_) => setState(() => _isLoadingPlans = false),
      (plans) {
        setState(() {
          _isLoadingPlans = false;
          if (plans.isNotEmpty) {
            _plans = plans;
            _selectedPlan = plans.firstWhere(
              (p) => p.code == widget.initialPlanCode,
              orElse: () => plans.first,
            );
          }
        });
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_plans.isEmpty && !_isLoadingPlans) {
      final l10n = context.l10n;
      final year = DateTime.now().year;
      _plans = [
        LeavePlanEntity(
          code: 'PN2026',
          name: l10n.leaveTypeAnnual,
          validFrom: '$year-01-01',
          validTo: '${year + 1}-03-31',
        ),
        LeavePlanEntity(
          code: 'LP_SICK',
          name: l10n.leaveTypeSick,
          validFrom: '$year-01-01',
          validTo: '$year-12-31',
        ),
        LeavePlanEntity(
          code: 'LP_COMPOFF',
          name: l10n.leaveTypeCompOff,
          validFrom: '$year-01-01',
          validTo: '$year-12-31',
        ),
        LeavePlanEntity(
          code: 'LP_UNPAID',
          name: l10n.leaveTypeUnpaid,
          validFrom: '$year-01-01',
          validTo: '$year-12-31',
        ),
      ];
      _selectedPlan ??= _plans.first;
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _from : _to,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _from = picked;
          if (_to.isBefore(picked)) _to = picked;
        } else {
          _to = picked;
          if (_from.isAfter(picked)) _from = picked;
        }
      });
    }
  }


  void _onConfirmTap() {
    Navigator.pop(context);
    final double amount;
    String? halfShift;
    if (_halfDayMode == 1) {
      amount = 0.5;
      halfShift = 'Morning';
    } else if (_halfDayMode == 2) {
      amount = 0.5;
      halfShift = 'Afternoon';
    } else {
      amount = (_to.difference(_from).inDays.abs() + 1).toDouble();
      halfShift = null;
    }
    final selected = _selectedPlan ?? (_plans.isNotEmpty ? _plans.first : null);
    if (selected == null) return;
    widget.onConfirm(selected, _from, _to, amount, halfShift, _reasonController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(18, 18, 18, bottomInset + 18),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.createLeaveRequestTitle, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                IconButton(icon: const AppIcon(AppIcons.close, size: 20), onPressed: () => Navigator.pop(context)),
              ],
            ),
            10.gapH,
            Row(
              children: [
                LeaveModeChip(text: 'Cả ngày', mode: 0, currentMode: _halfDayMode, onSelected: (m) => setState(() => _halfDayMode = m), colors: colors),
                8.gapW,
                LeaveModeChip(text: l10n.leaveHalfDayMorning, mode: 1, currentMode: _halfDayMode, onSelected: (m) => setState(() => _halfDayMode = m), colors: colors),
                8.gapW,
                LeaveModeChip(text: l10n.leaveHalfDayAfternoon, mode: 2, currentMode: _halfDayMode, onSelected: (m) => setState(() => _halfDayMode = m), colors: colors),
              ],
            ),
            12.gapH,
            LeavePlanSelector(
              plans: _plans,
              selectedPlan: _selectedPlan,
              isLoading: _isLoadingPlans,
              colors: colors,
              onSelected: (p) => setState(() => _selectedPlan = p),
            ),
            12.gapH,
            Row(
              children: [
                Expanded(child: LeaveDateTile(label: l10n.fromDateLabel, value: _formatDate(_from), onTap: () => _pickDate(true), colors: colors)),
                10.gapW,
                Expanded(child: LeaveDateTile(label: l10n.toDateLabel, value: _formatDate(_to), onTap: () => _pickDate(false), colors: colors)),
              ],
            ),
            10.gapH,
            Text(l10n.reasonLabel, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.textSecondary)),
            4.gapH,
            TextField(
              controller: _reasonController,
              maxLines: 2,
              style: TextStyle(fontSize: 13, color: colors.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.surface,
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
              ),
            ),
            18.gapH,
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: const Color(0xFF1C1408),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _onConfirmTap,
                child: Text(l10n.confirmSendLeaveRequest, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
