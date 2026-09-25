import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/services/app_permission_handler.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/leave_modal_components.dart';

/// Modal bottom sheet to pick leave type, half-day/full-day, handover, and attachment.
class LeaveRequestModal extends StatefulWidget {
  const new({
    required this.initialType,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onConfirm,
    super.key,
  });

  final String initialType;
  final String initialStartDate;
  final String initialEndDate;
  final void Function(String type, String startDate, String endDate, String totalDays, String reason) onConfirm;

  static Future<void> show(
    BuildContext context, {
    required String initialType,
    required String initialStartDate,
    required String initialEndDate,
    required void Function(String type, String startDate, String endDate, String totalDays, String reason) onConfirm,
  }) {
    final colors = context.colors;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => LeaveRequestModal(
        initialType: initialType,
        initialStartDate: initialStartDate,
        initialEndDate: initialEndDate,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<LeaveRequestModal> createState() => _LeaveRequestModalState();
}

class _LeaveRequestModalState extends State<LeaveRequestModal> {
  late String _selectedType;
  late String _startDate;
  late String _endDate;
  String? _attachedFileName;
  late TextEditingController _reasonController;
  late TextEditingController _handoverController;
  int _halfDayMode = 0; // 0: full day, 1: morning half, 2: afternoon half

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _reasonController = TextEditingController(text: 'Việc gia đình, đã bàn giao công việc cho bạn cùng ca.');
    _handoverController = TextEditingController(text: 'Phạm Thu Hương (NV0091)');
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _handoverController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2026, 9, 21),
      firstDate: DateTime(2026, 8),
      lastDate: DateTime(2026, 12),
    );
    if (picked != null) {
      final s = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      setState(() {
        if (isStart) {
          _startDate = s;
        } else {
          _endDate = s;
        }
      });
    }
  }

  Future<void> _pickAttachment() async {
    final granted = await AppPermissionHandler.requestPhotos(context);
    if (!mounted || !granted) return;
    setState(() => _attachedFileName = 'giay_chung_nhan_y_te.pdf');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.attachmentSelected('giay_chung_nhan_y_te.pdf', '1.2 MB'))),
    );
  }

  void _onConfirmTap(bool isDraft) {
    Navigator.pop(context);
    if (isDraft) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.leaveDraftSaved)));
      return;
    }
    final duration = _halfDayMode == 0 ? '3 ngày' : '0.5 ngày';
    widget.onConfirm(_selectedType, _startDate, _endDate, duration, _reasonController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final leaveTypes = [l10n.leaveTypeAnnual, l10n.leaveTypeSick, l10n.leaveTypeCompOff, l10n.leaveTypeUnpaid];

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
                IconButton(icon: const Icon(Symbols.close, size: 20), onPressed: () => Navigator.pop(context)),
              ],
            ),
            10.gapH,

            // Half-day mode toggle
            Row(
              children: [
                LeaveModeChip(
                  text: 'Cả ngày',
                  mode: 0,
                  currentMode: _halfDayMode,
                  onSelected: (m) => setState(() => _halfDayMode = m),
                  colors: colors,
                ),
                8.gapW,
                LeaveModeChip(
                  text: l10n.leaveHalfDayMorning,
                  mode: 1,
                  currentMode: _halfDayMode,
                  onSelected: (m) => setState(() => _halfDayMode = m),
                  colors: colors,
                ),
                8.gapW,
                LeaveModeChip(
                  text: l10n.leaveHalfDayAfternoon,
                  mode: 2,
                  currentMode: _halfDayMode,
                  onSelected: (m) => setState(() => _halfDayMode = m),
                  colors: colors,
                ),
              ],
            ),
            12.gapH,

            // Leave types
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: leaveTypes.map((t) {
                final isSel = _selectedType == t;
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => setState(() => _selectedType = t),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSel ? colors.primaryIndigo.withValues(alpha: 0.1) : colors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSel ? colors.primaryIndigo : colors.border, width: isSel ? 1.5 : 1),
                    ),
                    child: Text(t, style: TextStyle(fontSize: 12, fontWeight: isSel ? FontWeight.w800 : FontWeight.w600, color: isSel ? colors.primaryIndigo : colors.textPrimary)),
                  ),
                );
              }).toList(),
            ),
            12.gapH,

            Row(
              children: [
                Expanded(
                  child: LeaveDateTile(
                    label: l10n.fromDateLabel,
                    value: _startDate,
                    onTap: () => _pickDate(true),
                    colors: colors,
                  ),
                ),
                10.gapW,
                Expanded(
                  child: LeaveDateTile(
                    label: l10n.toDateLabel,
                    value: _endDate,
                    onTap: () => _pickDate(false),
                    colors: colors,
                  ),
                ),
              ],
            ),
            10.gapH,

            // Handover Colleague
            Text(l10n.leaveHandoverPerson, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.textSecondary)),
            4.gapH,
            TextField(
              controller: _handoverController,
              style: TextStyle(fontSize: 13, color: colors.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
              ),
            ),
            10.gapH,

            // Reason
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
            10.gapH,

            // Attachment button
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickAttachment,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: colors.border)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_attachedFileName != null ? Symbols.check_circle : Symbols.attach_file, size: 16, color: _attachedFileName != null ? colors.pineGreen : colors.textSecondary),
                    6.gapW,
                    Text(_attachedFileName ?? l10n.addAttachmentOptional, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                  ],
                ),
              ),
            ),
            16.gapH,

            // Draft & Submit buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: colors.border),
                    ),
                    onPressed: () => _onConfirmTap(true),
                    child: Text(l10n.leaveSaveDraftBtn, style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w700)),
                  ),
                ),
                10.gapW,
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      foregroundColor: const Color(0xFF1C1408),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _onConfirmTap(false),
                    child: Text(l10n.confirmSendLeaveRequest, style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
