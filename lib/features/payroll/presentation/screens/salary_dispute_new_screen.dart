import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';

/// Screen 15 / F5: Create a new salary line discrepancy dispute (`dispute-new`).
class SalaryDisputeNewScreen extends StatefulWidget {
  const SalaryDisputeNewScreen({
    this.prefilledItem = 'Lương tăng ca 150%',
    this.prefilledCurrentAmount = 1800000,
    this.periodMonth = '09/2026',
    super.key,
  });

  final String prefilledItem;
  final int prefilledCurrentAmount;
  final String periodMonth;

  @override
  State<SalaryDisputeNewScreen> createState() => _SalaryDisputeNewScreenState();
}

class _SalaryDisputeNewScreenState extends State<SalaryDisputeNewScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedItem;
  late final TextEditingController _currentAmountController;
  final _expectedAmountController = TextEditingController();
  final _reasonController = TextEditingController();

  int? _difference;
  bool _hasAttachment = false;

  final _availableItems = [
    'Lương tăng ca 150%',
    'Phụ cấp ăn trưa & đi lại',
    'Thưởng KPI Quý',
    'Bảo hiểm xã hội',
    'Thuế thu nhập cá nhân',
    'Trừ vi phạm chấm công',
  ];

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.prefilledItem;
    _currentAmountController = TextEditingController(
      text: _formatCurrency(widget.prefilledCurrentAmount),
    );
    _expectedAmountController.addListener(_calculateDifference);
  }

  @override
  void dispose() {
    _currentAmountController.dispose();
    _expectedAmountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _calculateDifference() {
    final text = _expectedAmountController.text.replaceAll(RegExp(r'[^\d]'), '');
    final expected = int.tryParse(text);
    if (expected != null) {
      setState(() {
        _difference = expected - widget.prefilledCurrentAmount;
      });
    } else {
      setState(() {
        _difference = null;
      });
    }
  }

  String _formatCurrency(int amount) {
    final s = amount.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return '${amount < 0 ? '-' : ''}${buffer.toString()} ₫';
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    context.push(
      AppRoutes.requestSent,
      extra: {
        'code': 'KN-2026-0418',
        'title': 'Khiếu nại: $_selectedItem ($periodText)',
        'assignedTo': 'Phạm Thu Trang (HR Admin)',
      },
    );
  }

  String get periodText => widget.periodMonth;

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
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.disputeNewTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            // Period display
            _buildReadOnlyField(
              context,
              label: l10n.disputeMonthLabel,
              value: 'Tháng $periodText',
              icon: Symbols.calendar_month,
            ),
            14.gapH,

            // Disputed item selector
            Text(
              l10n.disputeItemLabel,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
            ),
            6.gapH,
            DropdownButtonFormField<String>(
              value: _selectedItem,
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
              ),
              items: _availableItems
                  .map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 13.5))))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedItem = val);
              },
            ),
            14.gapH,

            // Current payslip amount (read only)
            _buildReadOnlyField(
              context,
              label: l10n.disputeCurrentAmountLabel,
              value: _formatCurrency(widget.prefilledCurrentAmount),
              icon: Symbols.receipt_long,
            ),
            14.gapH,

            // Expected amount field
            Text(
              l10n.disputeExpectedAmountLabel,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
            ),
            6.gapH,
            TextFormField(
              controller: _expectedAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Nhập số tiền thực tế (VD: 2450000)',
                filled: true,
                fillColor: colors.surface,
                prefixIcon: const Icon(Symbols.attach_money, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? 'Vui lòng nhập số tiền đề xuất' : null,
            ),
            14.gapH,

            // Difference calculation box
            if (_difference != null) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _difference! >= 0
                      ? colors.pineGreen.withValues(alpha: 0.12)
                      : colors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _difference! >= 0 ? colors.pineGreen : colors.error,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.disputeDifferenceLabel,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      '${_difference! >= 0 ? '+' : ''}${_formatCurrency(_difference!)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _difference! >= 0 ? colors.pineGreen : colors.error,
                      ),
                    ),
                  ],
                ),
              ),
              14.gapH,
            ],

            // Reason explanation
            Text(
              l10n.disputeReasonLabel,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
            ),
            6.gapH,
            TextFormField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: l10n.disputeReasonHint,
                filled: true,
                fillColor: colors.surface,
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? 'Vui lòng nhập lý do giải trình' : null,
            ),
            14.gapH,

            // Evidence upload box
            Text(
              l10n.disputeAttachmentLabel,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
            ),
            6.gapH,
            InkWell(
              onTap: () => setState(() => _hasAttachment = !_hasAttachment),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.border, style: BorderStyle.solid),
                ),
                child: Row(
                  children: [
                    Icon(
                      _hasAttachment ? Symbols.check_circle : Symbols.upload_file,
                      color: _hasAttachment ? colors.pineGreen : colors.primaryIndigo,
                      size: 24,
                    ),
                    12.gapW,
                    Expanded(
                      child: Text(
                        _hasAttachment ? 'minh_chung_tang_ca_092026.pdf (1.2 MB)' : 'Tải lên bảng phân ca hoặc ảnh chụp chấm công',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: _hasAttachment ? FontWeight.w700 : FontWeight.w500,
                          color: _hasAttachment ? colors.pineGreen : colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            24.gapH,

            // Submit Button
            PrimaryButton(
              text: l10n.submitDisputeBtn,
              onPressed: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
        ),
        6.gapH,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: colors.textSecondary),
              10.gapW,
              Text(
                value,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
