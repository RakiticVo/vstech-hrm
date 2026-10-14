import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/managed_employee_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/overtime_type_entity.dart';
import 'package:vstech_hrm/features/requests/domain/entities/valid_max_hour_entity.dart';
import 'package:vstech_hrm/features/requests/domain/usecases/get_overtime_types_usecase.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_modal_components.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_modal_form.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_modal_header.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/overtime_validation_helper.dart';
import 'package:vstech_hrm/features/requests/presentation/widgets/subordinate_employee_picker_sheet.dart';

/// Modal bottom sheet to pick date, hours, reason, and overtime type.
class OvertimeRequestModal extends StatefulWidget {
  const new({
    required this.initialDate,
    required this.onConfirm,
    this.availableTypes = const [],
    this.initialTypeCode,
    this.isManager = false,
    this.initialEmployee,
    super.key,
  });

  final DateTime initialDate;
  final List<OvertimeTypeEntity> availableTypes;
  final String? initialTypeCode;
  final OvertimeConfirmCallback onConfirm;
  final bool isManager;
  final ManagedEmployeeEntity? initialEmployee;

  static Future<void> show(
    BuildContext context, {
    required DateTime initialDate,
    required OvertimeConfirmCallback onConfirm,
    List<OvertimeTypeEntity> availableTypes = const [],
    String? initialTypeCode,
    bool isManager = false,
    ManagedEmployeeEntity? initialEmployee,
  }) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: context.colors.surface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
        builder: (_) => OvertimeRequestModal(
          initialDate: initialDate,
          availableTypes: availableTypes,
          initialTypeCode: initialTypeCode,
          isManager: isManager,
          initialEmployee: initialEmployee,
          onConfirm: onConfirm,
        ),
      );

  @override
  State<OvertimeRequestModal> createState() => _OvertimeRequestModalState();
}

class _OvertimeRequestModalState extends State<OvertimeRequestModal> {
  late DateTime _selectedDate;
  TimeOfDay _startTime = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 21, minute: 0);
  final TextEditingController _reasonController = TextEditingController();
  List<OvertimeTypeEntity> _types = [];
  OvertimeTypeEntity? _selectedType;
  ValidMaxHourEntity? _validInfo;
  ManagedEmployeeEntity? _selectedEmployee;
  bool _isSubmitting = false;
  bool _acceptImmediately = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedEmployee = widget.initialEmployee;

    if (widget.availableTypes.isNotEmpty) {
      _types = OvertimeValidationHelper.cleanTypes(widget.availableTypes);
      _selectedType = _types.where((t) => t.code == widget.initialTypeCode).firstOrNull ?? _types.firstOrNull;
    }
    unawaited(widget.availableTypes.isNotEmpty ? _checkValidation() : _fetchTypes());
  }

  Future<void> _fetchTypes() async {
    if (!sl.isRegistered<GetOvertimeTypesUseCase>()) return;
    final res = await sl<GetOvertimeTypesUseCase>()();
    if (!mounted) return;
    res.fold((_) {}, (types) {
      if (types.isNotEmpty) {
        final clean = OvertimeValidationHelper.cleanTypes(types);
        setState(() {
          _types = clean;
          _selectedType = clean.where((t) => t.code == widget.initialTypeCode).firstOrNull ?? clean.firstOrNull;
        });
        unawaited(_checkValidation());
      }
    });
  }

  Future<void> _checkValidation() async {
    final info = await OvertimeValidationHelper.fetchValidMaxHour(
      date: _selectedDate,
      overtimeType: _selectedType?.code ?? 'OT_WEEKDAY',
      adminEmployee: _selectedEmployee?.code,
    );
    if (mounted) setState(() => _validInfo = info);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_types.isEmpty) {
      _types = OvertimeValidationHelper.defaultTypes(context.l10n);
      _selectedType ??= _types.first;
      unawaited(_checkValidation());
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  double _computedLength() => OvertimeValidationHelper.computeLength(_startTime, _endTime);

  Future<void> _pickEmployee() async {
    final picked = await SubordinateEmployeePickerSheet.show(context, selectedEmployee: _selectedEmployee);
    if (!mounted) return;
    setState(() {
      _selectedEmployee = picked;
      _errorMessage = null;
    });
    await _checkValidation();
  }

  Future<void> _pickDate() async {
    final picked = await OvertimeValidationHelper.pickDate(context, _selectedDate);
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _errorMessage = null;
      });
      await _checkValidation();
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await OvertimeValidationHelper.pickTime(context, isStart ? _startTime : _endTime);
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
        _errorMessage = null;
      });
    }
  }

  void _onSelectType(OvertimeTypeEntity t) {
    setState(() {
      _selectedType = t;
      _errorMessage = null;
    });
    unawaited(_checkValidation());
  }

  void _onReasonChanged(String _) {
    if (_errorMessage != null) setState(() => _errorMessage = null);
  }

  Future<void> _onConfirmTap() async {
    if (_isSubmitting) return;

    final selected = _selectedType ?? (_types.isNotEmpty ? _types.first : null);
    final reason = _reasonController.text.trim();
    final length = _computedLength();
    final isProxy = widget.isManager || _selectedEmployee != null;

    final validationErr = OvertimeValidationHelper.validateSubmission(
      selectedType: selected,
      reason: reason,
      length: length,
      validInfo: _validInfo,
      skipMaxHour: true,
    );
    if (validationErr != null) {
      setState(() => _errorMessage = validationErr);
      return;
    }

    setState(() {
      _errorMessage = null;
      _isSubmitting = true;
    });

    final startDt = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _startTime.hour, _startTime.minute);
    final endDt = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _endTime.hour, _endTime.minute);

    try {
      final err = await widget.onConfirm(
        selected!,
        _selectedDate,
        startDt,
        endDt,
        length,
        reason,
        employeeCode: _selectedEmployee?.code,
        employeeName: _selectedEmployee?.name,
        accept: isProxy ? _acceptImmediately : null,
      );
      if (!mounted) return;
      if (err == null) {
        Navigator.pop(context);
        return;
      }
      setState(() => _errorMessage = err);
    } on Exception catch (_) {
      if (mounted) setState(() => _errorMessage = context.l10n.errorOccurred);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final length = _computedLength();
    final currentType = _selectedType ??
        (_types.isNotEmpty ? _types.first : const OvertimeTypeEntity(code: 'OT', name: 'Tăng ca'));

    return PopScope(
      canPop: !_isSubmitting,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(18, 20, 18, bottomInset + 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OvertimeModalHeader(
                  title: l10n.overtimeModalTitle,
                  colors: colors,
                  onClose: _isSubmitting ? null : () => Navigator.pop(context),
                ),
                12.gapH,
                AbsorbPointer(
                  absorbing: _isSubmitting,
                  child: OvertimeModalFormFields(
                    selectedDate: _selectedDate,
                    startTime: _startTime,
                    endTime: _endTime,
                    types: _types,
                    selectedType: currentType,
                    length: length,
                    reasonController: _reasonController,
                    validInfo: _validInfo,
                    selectedEmployee: _selectedEmployee,
                    isManager: widget.isManager,
                    acceptImmediately: _acceptImmediately,
                    onAcceptChanged: (val) => setState(() => _acceptImmediately = val),
                    onPickEmployee: widget.isManager ? _pickEmployee : null,
                    onPickDate: _pickDate,
                    onPickTime: ({required isStart}) => _pickTime(isStart),
                    onSelectType: _onSelectType,
                    onReasonChanged: _onReasonChanged,
                    colors: colors,
                  ),
                ),
                14.gapH,
                if (_errorMessage != null) ...[
                  OvertimeErrorBanner(message: _errorMessage!),
                  12.gapH,
                ],
                OvertimeSubmitButton(
                  title: l10n.confirmSendOvertime,
                  isSubmitting: _isSubmitting,
                  onPressed: _onConfirmTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
