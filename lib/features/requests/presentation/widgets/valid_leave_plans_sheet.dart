import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/requests/domain/entities/valid_leave_plan_entity.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_valid_leave_plans_usecase.dart';

/// Bottom sheet displaying live available leave balances from GET /api/LeavePlans/valid-leave-plan2.
class ValidLeavePlansSheet extends StatefulWidget {
  const new({this.initialDate, super.key});

  final DateTime? initialDate;

  static Future<ValidLeavePlanEntity?> show(
    BuildContext context, {
    DateTime? initialDate,
  }) =>
      showModalBottomSheet<ValidLeavePlanEntity>(
        context: context,
        isScrollControlled: true,
        backgroundColor: context.colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        builder: (_) => ValidLeavePlansSheet(initialDate: initialDate),
      );

  @override
  State<ValidLeavePlansSheet> createState() => _ValidLeavePlansSheetState();
}

class _ValidLeavePlansSheetState extends State<ValidLeavePlansSheet> {
  late DateTime _selectedDate;
  bool _isLoading = false;
  List<ValidLeavePlanEntity> _plans = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    unawaited(_loadPlans());
  }

  Future<void> _loadPlans() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    if (!sl.isRegistered<GetValidLeavePlansUseCase>()) {
      setState(() => _isLoading = false);
      return;
    }
    final ymd = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    final result = await sl<GetValidLeavePlansUseCase>()(execDate: ymd);
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _isLoading = false;
        _errorMessage = failure.message;
      }),
      (plans) => setState(() {
        _isLoading = false;
        _plans = plans;
      }),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      await _loadPlans();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dateStr = DateFormat('dd/MM/yyyy').format(_selectedDate);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            14.gapH,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phép khả dụng',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                      3.gapH,
                      Text(
                        'Số ngày phép còn lại tại thời điểm tính',
                        style: TextStyle(fontSize: 12, color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            14.gapH,
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: colors.cardSecondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 16, color: colors.pineGreen),
                    10.gapW,
                    Text(
                      'Ngày kiểm tra: ',
                      style: TextStyle(fontSize: 13, color: colors.textSecondary),
                    ),
                    Text(
                      dateStr,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.edit_calendar_rounded, size: 16, color: colors.pineGreen),
                  ],
                ),
              ),
            ),
            16.gapH,
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(fontSize: 13, color: colors.error),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : _plans.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Text(
                                  'Không tìm thấy loại phép khả dụng nào cho ngày $dateStr',
                                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: _plans.length,
                              separatorBuilder: (_, _) => 10.gapH,
                              itemBuilder: (ctx, index) {
                                final plan = _plans[index];
                                final hasValidity = plan.validFrom != null && plan.validTo != null;
                                return Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: colors.surface,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: colors.border),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: colors.pineGreen.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(Icons.beach_access_rounded, size: 20, color: colors.pineGreen),
                                      ),
                                      12.gapW,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              plan.leaveName,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                color: colors.textPrimary,
                                              ),
                                            ),
                                            if (hasValidity) ...[
                                              3.gapH,
                                              Text(
                                                'Hiệu lực: ${plan.validFrom} → ${plan.validTo}',
                                                style: TextStyle(fontSize: 11, color: colors.textSecondary),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: colors.pineGreen.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${plan.amount} ngày',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: colors.pineGreen,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
