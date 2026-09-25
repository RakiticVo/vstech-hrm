import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_schedule_entity.dart';

class ColleagueSwapOption {
  const new({
    required this.name,
    required this.shiftDesc,
    this.conflictReason,
  });

  final String name;
  final String shiftDesc;
  final String? conflictReason;

  bool get isValid => conflictReason == null;
}

/// Modal bottom sheet allowing an employee to propose a shift swap with validation.
class ShiftSwapModal extends StatefulWidget {
  const new({
    required this.shift,
    super.key,
  });

  final ShiftScheduleEntity shift;

  static Future<void> show(BuildContext context, ShiftScheduleEntity shift) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ShiftSwapModal(shift: shift),
    );
  }

  @override
  State<ShiftSwapModal> createState() => _ShiftSwapModalState();
}

class _ShiftSwapModalState extends State<ShiftSwapModal> {
  final _reasonController = TextEditingController(text: 'Đổi ca để đi khám sức khỏe định kỳ');
  late ColleagueSwapOption _selectedColleague;

  late final List<ColleagueSwapOption> _colleagues = [
    const ColleagueSwapOption(
      name: 'Phạm Thu Hương (NV0091)',
      shiftDesc: 'Ca Chiều (13:00–21:00) · Hợp lệ',
    ),
    const ColleagueSwapOption(
      name: 'Nguyễn Văn Hùng (NV0104)',
      shiftDesc: 'Chi nhánh Hà Nội',
      conflictReason: 'Đồng nghiệp khác chi nhánh (Chi nhánh Hà Nội)',
    ),
    const ColleagueSwapOption(
      name: 'Đặng Thanh Thảo (NV0062)',
      shiftDesc: 'Đang nghỉ phép 18/09',
      conflictReason: 'Đồng nghiệp đang nghỉ phép vào ngày này',
    ),
    const ColleagueSwapOption(
      name: 'Võ Minh Trí (NV0079)',
      shiftDesc: 'Ca Đêm (21:00–05:00)',
      conflictReason: 'Khoảng cách giữa hai ca < 12 giờ (Điều 109 BLLĐ 2019)',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Default to the invalid colleague first so demoer can immediately demonstrate conflict
    _selectedColleague = _colleagues[3];
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submitSwapRequest() {
    final l10n = context.l10n;
    if (!_selectedColleague.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_selectedColleague.conflictReason ?? l10n.shiftSwapConflictAlert),
          backgroundColor: context.colors.error,
        ),
      );
      return;
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Symbols.check_circle, color: Colors.white, size: 20),
            8.gapW,
            Expanded(
              child: Text(
                l10n.swapRequestSent(_selectedColleague.name),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: context.colors.tealPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final shift = widget.shift;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            14.gapH,
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: colors.tealPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(Symbols.swap_horiz, color: colors.tealPrimary),
                ),
                12.gapW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.swapShiftProposalTitle, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: colors.textPrimary)),
                      Text('${shift.dayOfWeek}, ${shift.date.day}/${shift.date.month} · ${shift.shiftName}', style: TextStyle(fontSize: 12.5, color: colors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            16.gapH,

            Text(l10n.selectColleagueLabel, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textPrimary)),
            6.gapH,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border.all(color: !_selectedColleague.isValid ? colors.error : colors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ColleagueSwapOption>(
                  value: _selectedColleague,
                  isExpanded: true,
                  icon: const Icon(Symbols.keyboard_arrow_down),
                  items: _colleagues.map((opt) {
                    return DropdownMenuItem(
                      value: opt,
                      child: Text(
                        '${opt.name} (${opt.shiftDesc})',
                        style: TextStyle(fontSize: 13, color: opt.isValid ? colors.textPrimary : colors.error, fontWeight: opt.isValid ? FontWeight.w600 : FontWeight.w700),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedColleague = val);
                  },
                ),
              ),
            ),
            8.gapH,

            // Conflict warning banner
            if (!_selectedColleague.isValid) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.error.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Symbols.warning, color: colors.error, size: 18),
                    8.gapW,
                    Expanded(
                      child: Text(
                        _selectedColleague.conflictReason ?? l10n.shiftSwapConflictAlert,
                        style: TextStyle(fontSize: 11.5, color: colors.error, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              10.gapH,
            ],

            Text(l10n.swapReasonLabel, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textPrimary)),
            6.gapH,
            TextField(
              controller: _reasonController,
              maxLines: 2,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            18.gapH,

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submitSwapRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedColleague.isValid ? colors.tealPrimary : colors.border,
                  foregroundColor: _selectedColleague.isValid ? Colors.white : colors.textSecondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(l10n.submitSwapRequestButton, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
