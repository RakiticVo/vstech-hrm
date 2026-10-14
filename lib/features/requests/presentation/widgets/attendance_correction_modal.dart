import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/services/app_permission_handler.dart';
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
  late TimeOfDay _time;
  String? _attachedFileName;
  late TextEditingController _reasonController;
  late TextEditingController _worktimeController;
  late List<CorrectionReasonEntity> _reasons;
  late CorrectionReasonEntity _selectedReason;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _time = const TimeOfDay(hour: 17, minute: 30);
    _reasonController = TextEditingController();
    _worktimeController = TextEditingController(text: '8.0');
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
    _worktimeController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  Future<void> _pickAttachment() async {
    final granted = await AppPermissionHandler.requestPhotos(context);
    if (!mounted || !granted) return;
    setState(() => _attachedFileName = 'bang_chung_cham_cong.jpg');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.proofSelected('bang_chung_cham_cong.jpg', '850 KB')),
        backgroundColor: const Color(0xFF0F766E),
      ),
    );
  }

  void _onConfirmTap() {
    Navigator.pop(context);
    final worktime = double.tryParse(_worktimeController.text.trim()) ?? 8.0;
    widget.onConfirm(
      _selectedReason,
      _selectedDate,
      worktime,
      _reasonController.text.trim(),
      _attachedFileName,
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
            Row(
              children: [
                Expanded(child: CorrectionPickerTile(label: l10n.correctionDateLabel, value: _formatDate(_selectedDate), iconName: AppIcons.calendar, onTap: _pickDate, colors: colors)),
                10.gapW,
                Expanded(child: CorrectionPickerTile(label: l10n.correctionTimeLabel, value: _formatTime(_time), iconName: AppIcons.attendance, onTap: _pickTime, colors: colors)),
              ],
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
            Text('Số giờ công xác nhận (giờ)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary)),
            6.gapH,
            TextField(
              controller: _worktimeController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(fontSize: 13, color: colors.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
              ),
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
            12.gapH,
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickAttachment,
              child: Container(
                height: 40,
                decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: colors.border)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcon(_attachedFileName != null ? AppIcons.check : AppIcons.attach, size: 16, color: _attachedFileName != null ? colors.primaryIndigo : colors.textSecondary),
                    6.gapW,
                    Text(_attachedFileName ?? l10n.addProofOptional, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textSecondary)),
                  ],
                ),
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
