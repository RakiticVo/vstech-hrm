import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/schedule/domain/entities/shift_schedule_entity.dart';

/// Modal bottom sheet allowing an employee to propose a shift swap.
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
  final _reasonController = TextEditingController();
  String _selectedColleague = 'Trần Thị Lan (Ca chiều)';
  final _colleagues = [
    'Trần Thị Lan (Ca chiều)',
    'Nguyễn Văn Hùng (Ca sáng)',
    'Võ Minh Trí (Ca gãy)',
    'Đặng Thanh Thảo (Ca hành chính)',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submitSwapRequest() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Symbols.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Đã gửi yêu cầu đổi ca cho $_selectedColleague!',
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
    final shift = widget.shift;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.tealPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Symbols.swap_horiz, color: colors.tealPrimary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đề xuất đổi ca làm việc',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        '${shift.dayOfWeek}, ${shift.date.day}/${shift.date.month}/${shift.date.year} · ${shift.shiftName}',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Chọn đồng nghiệp muốn đổi ca:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border.all(color: colors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedColleague,
                  isExpanded: true,
                  icon: const Icon(Symbols.keyboard_arrow_down),
                  items: _colleagues.map((colleague) {
                    return DropdownMenuItem(
                      value: colleague,
                      child: Text(
                        colleague,
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedColleague = val);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Lý do đổi ca:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Nhập lý do đổi ca cụ thể...',
                hintStyle: TextStyle(
                  color: colors.textSecondary.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.tealPrimary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submitSwapRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.tealPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Gửi yêu cầu đổi ca',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
