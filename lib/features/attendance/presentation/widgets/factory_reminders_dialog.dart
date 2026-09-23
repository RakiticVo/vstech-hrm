import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/services/offline_attendance_service.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Modal dialog for configuring local shift & lunch-break reminders for factory workers.
class FactoryRemindersDialog extends StatefulWidget {
  const new({
    required this.currentConfig,
    required this.onSave,
    super.key,
  });

  final FactoryRemindersConfig currentConfig;
  final ValueChanged<FactoryRemindersConfig> onSave;

  @override
  State<FactoryRemindersDialog> createState() => _FactoryRemindersDialogState();
}

class _FactoryRemindersDialogState extends State<FactoryRemindersDialog> {
  late bool _morning;
  late bool _lunch;
  late bool _afternoon;
  late bool _shiftEnd;

  @override
  void initState() {
    super.initState();
    _morning = widget.currentConfig.morningShiftEnabled;
    _lunch = widget.currentConfig.lunchBreakEnabled;
    _afternoon = widget.currentConfig.afternoonShiftEnabled;
    _shiftEnd = widget.currentConfig.shiftEndEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.primaryIndigo.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Symbols.alarm, color: colors.primaryIndigo, size: 22),
          ),
          10.gapW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.factoryRemindersTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                2.gapH,
                Text(
                  'Cài đặt chuông báo ca kíp nhà máy',
                  style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(Symbols.info, size: 16, color: Color(0xFFD97706)),
                  8.gapW,
                  Expanded(
                    child: Text(
                      l10n.factoryRemindersSubtitle,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF92400E)),
                    ),
                  ),
                ],
              ),
            ),
            12.gapH,
            _buildSwitchTile(
              l10n.reminderMorningShift,
              widget.currentConfig.morningShiftTime,
              _morning,
              (v) => setState(() => _morning = v),
              colors,
            ),
            _buildSwitchTile(
              l10n.reminderLunchBreak,
              widget.currentConfig.lunchBreakTime,
              _lunch,
              (v) => setState(() => _lunch = v),
              colors,
            ),
            _buildSwitchTile(
              l10n.reminderAfternoonShift,
              widget.currentConfig.afternoonShiftTime,
              _afternoon,
              (v) => setState(() => _afternoon = v),
              colors,
            ),
            _buildSwitchTile(
              l10n.reminderShiftEnd,
              widget.currentConfig.shiftEndTime,
              _shiftEnd,
              (v) => setState(() => _shiftEnd = v),
              colors,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.cancelButton,
            style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primaryIndigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            final updated = FactoryRemindersConfig(
              morningShiftEnabled: _morning,
              morningShiftTime: widget.currentConfig.morningShiftTime,
              lunchBreakEnabled: _lunch,
              lunchBreakTime: widget.currentConfig.lunchBreakTime,
              afternoonShiftEnabled: _afternoon,
              afternoonShiftTime: widget.currentConfig.afternoonShiftTime,
              shiftEndEnabled: _shiftEnd,
              shiftEndTime: widget.currentConfig.shiftEndTime,
            );
            widget.onSave(updated);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.reminderSavedSuccess),
                behavior: SnackBarBehavior.floating,
                backgroundColor: colors.pineGreen,
              ),
            );
          },
          child: Text(l10n.saveSettingsButton, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String time,
    bool value,
    ValueChanged<bool> onChanged,
    AppColorsExtension colors,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        subtitle: Text(
          'Giờ báo: $time hàng ngày',
          style: TextStyle(fontSize: 11.5, color: colors.textTertiary),
        ),
        activeThumbColor: colors.primaryIndigo,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
