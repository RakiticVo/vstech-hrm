import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Screen F1: On Duty Request (Công tác ngắn / Đi việc ngoài trong ca).
class OnDutyRequestScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<OnDutyRequestScreen> createState() => _OnDutyRequestScreenState();
}

class _OnDutyRequestScreenState extends State<OnDutyRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _fromTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _toTime = const TimeOfDay(hour: 11, minute: 30);
  final _locationController = TextEditingController(text: 'Sở Kế hoạch & Đầu tư TP.HCM');
  final _descriptionController = TextEditingController(text: 'Nộp bổ sung hồ sơ điều chỉnh giấy phép kinh doanh');
  bool _hasAttachment = false;

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.onDutySubmitSuccess)),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          l10n.onDutyTitle,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              // Shift constraint hint
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.primaryIndigo.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.primaryIndigo.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Symbols.schedule, color: colors.primaryIndigo, size: 20),
                    10.gapW,
                    Expanded(
                      child: Text(
                        l10n.onDutyShiftConstraintWarning,
                        style: TextStyle(fontSize: 12, color: colors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              16.gapH,

              // Date Picker Field
              Text(l10n.dateLabel, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textPrimary)),
              6.gapH,
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 7)),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textPrimary),
                      ),
                      Icon(Symbols.calendar_today, size: 18, color: colors.textSecondary),
                    ],
                  ),
                ),
              ),
              14.gapH,

              // Time Range (From - To)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.onDutyFromTime, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                        6.gapH,
                        _buildTimePicker(
                          time: _fromTime,
                          onPick: (t) => setState(() => _fromTime = t),
                          colors: colors,
                        ),
                      ],
                    ),
                  ),
                  12.gapW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.onDutyToTime, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                        6.gapH,
                        _buildTimePicker(
                          time: _toTime,
                          onPick: (t) => setState(() => _toTime = t),
                          colors: colors,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              14.gapH,

              // Location
              Text(l10n.onDutyLocation, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textPrimary)),
              6.gapH,
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Symbols.location_on, color: colors.textSecondary),
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                ),
                validator: (v) => v == null || v.isEmpty ? l10n.fillRequiredField : null,
              ),
              14.gapH,

              // Work Description
              Text(l10n.onDutyDescription, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textPrimary)),
              6.gapH,
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                ),
                validator: (v) => v == null || v.isEmpty ? l10n.fillRequiredField : null,
              ),
              14.gapH,

              // Attachment
              InkWell(
                onTap: () => setState(() => _hasAttachment = !_hasAttachment),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _hasAttachment ? colors.pineGreen : colors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(_hasAttachment ? Symbols.check_circle : Symbols.attach_file, color: _hasAttachment ? colors.pineGreen : colors.textSecondary),
                      10.gapW,
                      Expanded(
                        child: Text(
                          _hasAttachment ? 'giay_gioi_thieu_UBND.pdf' : l10n.leaveAttachment,
                          style: TextStyle(
                            fontSize: 13,
                            color: _hasAttachment ? colors.pineGreen : colors.textSecondary,
                            fontWeight: _hasAttachment ? FontWeight.w700 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              24.gapH,

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primaryIndigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _submit,
                child: Text(l10n.submitButton, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker({
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onPick,
    required AppColorsExtension colors,
  }) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: time);
        if (picked != null) onPick(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textPrimary),
            ),
            Icon(Symbols.schedule, size: 18, color: colors.textSecondary),
          ],
        ),
      ),
    );
  }
}
