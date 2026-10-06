import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_type_entity.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_overtime_types_usecase.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_modal_components.dart';

typedef OvertimeConfirmCallback = void Function(
  OvertimeTypeEntity type,
  DateTime date,
  DateTime start,
  DateTime end,
  double length,
  String reason,
);

/// Modal bottom sheet to pick date, hours, reason, and overtime type.
class OvertimeRequestModal extends StatefulWidget {
  const new({
    required this.initialDate,
    required this.onConfirm,
    this.availableTypes = const [],
    this.initialTypeCode,
    super.key,
  });

  final DateTime initialDate;
  final List<OvertimeTypeEntity> availableTypes;
  final String? initialTypeCode;
  final OvertimeConfirmCallback onConfirm;

  static Future<void> show(
    BuildContext context, {
    required DateTime initialDate,
    required OvertimeConfirmCallback onConfirm,
    List<OvertimeTypeEntity> availableTypes = const [],
    String? initialTypeCode,
  }) {
    final colors = context.colors;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => OvertimeRequestModal(
        initialDate: initialDate,
        availableTypes: availableTypes,
        initialTypeCode: initialTypeCode,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<OvertimeRequestModal> createState() => _OvertimeRequestModalState();
}

class _OvertimeRequestModalState extends State<OvertimeRequestModal> {
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late TextEditingController _reasonController;
  List<OvertimeTypeEntity> _types = [];
  OvertimeTypeEntity? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _startTime = const TimeOfDay(hour: 18, minute: 0);
    _endTime = const TimeOfDay(hour: 21, minute: 0);
    _reasonController = TextEditingController();

    if (widget.availableTypes.isNotEmpty) {
      _types = widget.availableTypes;
      _selectedType = _types.firstWhere(
        (t) => t.code == widget.initialTypeCode,
        orElse: () => _types.first,
      );
    } else {
      unawaited(_fetchTypes());
    }
  }

  Future<void> _fetchTypes() async {
    if (!sl.isRegistered<GetOvertimeTypesUseCase>()) return;
    final res = await sl<GetOvertimeTypesUseCase>()();
    if (!mounted) return;
    res.fold((_) {}, (types) {
      if (types.isNotEmpty) {
        setState(() {
          _types = types;
          _selectedType = types.firstWhere(
            (t) => t.code == widget.initialTypeCode,
            orElse: () => types.first,
          );
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_types.isEmpty) {
      final l10n = context.l10n;
      _types = [
        OvertimeTypeEntity(code: 'OT_WEEKDAY', name: l10n.otRateWeekday),
        OvertimeTypeEntity(code: 'OT_WEEKEND', name: l10n.otRateWeekend, scale: 2),
        OvertimeTypeEntity(code: 'OT_HOLIDAY', name: l10n.otRateHoliday, scale: 3),
      ];
      _selectedType ??= _types.first;
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  double _computedLength() {
    final startMin = _startTime.hour * 60 + _startTime.minute;
    final endMin = _endTime.hour * 60 + _endTime.minute;
    var diff = endMin - startMin;
    if (diff <= 0) diff += 24 * 60;
    return double.parse((diff / 60.0).toStringAsFixed(1));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _onConfirmTap() {
    Navigator.pop(context);
    final selected = _selectedType ?? (_types.isNotEmpty ? _types.first : null);
    if (selected == null) return;
    final length = _computedLength();
    final startDt = DateTime(
      _selectedDate.year, _selectedDate.month, _selectedDate.day, _startTime.hour, _startTime.minute,
    );
    final endDt = DateTime(
      _selectedDate.year, _selectedDate.month, _selectedDate.day, _endTime.hour, _endTime.minute,
    );
    widget.onConfirm(selected, _selectedDate, startDt, endDt, length, _reasonController.text.trim());
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final length = _computedLength();
    final currentType = _selectedType ?? (_types.isNotEmpty ? _types.first : const OvertimeTypeEntity(code: 'OT', name: 'Tăng ca'));

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(18, 20, 18, bottomInset + 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.overtimeModalTitle, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                IconButton(icon: const AppIcon(AppIcons.close, size: 20), onPressed: () => Navigator.pop(context)),
              ],
            ),
            12.gapH,
            Text(l10n.overtimeDateLabel, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary)),
            6.gapH,
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(color: colors.cardSecondary, borderRadius: BorderRadius.circular(12), border: Border.all(color: colors.border)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDate(_selectedDate), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                    AppIcon(AppIcons.calendar, size: 18, color: colors.primaryIndigo),
                  ],
                ),
              ),
            ),
            12.gapH,
            Text(l10n.overtimeTimeRangeLabel, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary)),
            6.gapH,
            Row(
              children: [
                Expanded(child: OvertimeTimePickerTile(label: l10n.startTimeLabel, value: _formatTime(_startTime), onTap: () => _pickTime(true), colors: colors)),
                10.gapW,
                Expanded(child: OvertimeTimePickerTile(label: l10n.endTimeLabel, value: _formatTime(_endTime), onTap: () => _pickTime(false), colors: colors)),
              ],
            ),
            10.gapH,
            Text('Loại tăng ca', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary)),
            6.gapH,
            OvertimeTypeSelector(
              types: _types,
              selectedType: currentType,
              onSelected: (t) => setState(() => _selectedType = t),
              colors: colors,
            ),
            10.gapH,
            OvertimeDurationBadge(length: length, colors: colors),
            12.gapH,

            // Reason field
            Text(l10n.overtimeReasonLabel, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary)),
            6.gapH,
            TextField(
              controller: _reasonController,
              maxLines: 2,
              style: TextStyle(fontSize: 13, color: colors.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.cardSecondary,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
              ),
            ),
            18.gapH,

            // Confirm Button
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
                child: Text(l10n.confirmSendOvertime, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
