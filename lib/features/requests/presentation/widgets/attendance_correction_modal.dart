import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/requests/domain/entities/request_params.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/correction_modal_components.dart';

/// Modal bottom sheet to pick date, issue/reason, corrected time, and explanation.
class AttendanceCorrectionModal extends StatefulWidget {
  const new({
    required this.initialDate,
    required this.onConfirm,
    this.availableReasons = const [],
    this.initialReasonCode,
    super.key,
  });

  final DateTime initialDate;
  final List<CorrectionReasonEntity> availableReasons;
  final String? initialReasonCode;
  final void Function(
    CorrectionReasonEntity reason,
    DateTime date,
    double worktime,
    String note,
    String? imageUrl,
  ) onConfirm;

  static Future<void> show(
    BuildContext context, {
    required DateTime initialDate,
    required void Function(
      CorrectionReasonEntity reason,
      DateTime date,
      double worktime,
      String note,
      String? imageUrl,
    ) onConfirm,
    List<CorrectionReasonEntity> availableReasons = const [],
    String? initialReasonCode,
  }) {
    final colors = context.colors;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => AttendanceCorrectionModal(
        initialDate: initialDate,
        availableReasons: availableReasons,
        initialReasonCode: initialReasonCode,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<AttendanceCorrectionModal> createState() => _AttendanceCorrectionModalState();
}

class _AttendanceCorrectionModalState extends State<AttendanceCorrectionModal> {
  late DateTime _selectedDate;
  late TextEditingController _reasonController;
  late List<CorrectionReasonEntity> _reasons;
  late CorrectionReasonEntity _selectedReason;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _reasonController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = context.l10n;
    _reasons = widget.availableReasons.isNotEmpty
        ? widget.availableReasons
        : [
            CorrectionReasonEntity(code: 'MISSING_CHECKOUT', name: l10n.issueMissingCheckout),
            CorrectionReasonEntity(code: 'MISSING_CHECKIN', name: l10n.issueMissingCheckin),
            CorrectionReasonEntity(code: 'SCANNER_ERROR', name: l10n.issueScannerError),
            CorrectionReasonEntity(code: 'WRONG_SHIFT', name: l10n.issueWrongShift),
          ];
    _selectedReason = _reasons.firstWhere(
      (r) => r.code == widget.initialReasonCode,
      orElse: () => _reasons.first,
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month);
    final initial = _selectedDate.isBefore(firstDayOfMonth) || _selectedDate.isAfter(now)
        ? now
        : _selectedDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDayOfMonth,
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _onConfirmTap() {
    Navigator.pop(context);
    widget.onConfirm(
      _selectedReason,
      _selectedDate,
      0,
      _reasonController.text.trim(),
      null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(18, 20, 18, bottomInset + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.createCorrectionTitle, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                IconButton(icon: const AppIcon(AppIcons.close, size: 20), onPressed: () => Navigator.pop(context)),
              ],
            ),
            12.gapH,
            CorrectionPickerTile(
              label: l10n.correctionDateLabel,
              value: _formatDate(_selectedDate),
              iconName: AppIcons.calendar,
              onTap: _pickDate,
              colors: colors,
            ),
            14.gapH,
            Text(l10n.correctionIssueLabel, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
            8.gapH,
            CorrectionReasonChips(
              reasons: _reasons,
              selectedReason: _selectedReason,
              onSelected: (r) => setState(() => _selectedReason = r),
              colors: colors,
            ),
            14.gapH,
            Text(l10n.explanationDetailLabel, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
            6.gapH,
            TextField(
              controller: _reasonController,
              maxLines: 2,
              style: TextStyle(fontSize: 13, color: colors.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.surface,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
              ),
            ),
            18.gapH,
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: const Color(0xFF1C1408),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: _onConfirmTap,
                child: Text(l10n.confirmSendCorrection, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
