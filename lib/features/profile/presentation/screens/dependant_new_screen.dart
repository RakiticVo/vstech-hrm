import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';

/// Screen for registering a new tax-relief dependant (`dependant-new`).
class DependantNewScreen extends StatefulWidget {
  const DependantNewScreen({super.key});

  @override
  State<DependantNewScreen> createState() => _DependantNewScreenState();
}

class _DependantNewScreenState extends State<DependantNewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _startMonthController = TextEditingController(text: '10/2026');

  String _selectedRelationship = 'Con ruột (< 18 tuổi)';
  bool _agreedToDisclaimer = false;
  String? _attachedDocName;
  String? _validationError;

  final _relationships = [
    'Con ruột (< 18 tuổi)',
    'Con ruột (khuyết tật/học đại học)',
    'Vợ / Chồng ngoài độ tuổi lao động',
    'Bố / Mẹ ruột ngoài tuổi lao động',
    'Bố / Mẹ vợ hoặc chồng',
    'Người nuôi dưỡng hợp pháp',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _idNumberController.dispose();
    _startMonthController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _validationError = null);
    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToDisclaimer) {
      setState(() {
        _validationError = 'Vui lòng xác nhận cam kết trước khi gửi hồ sơ';
      });
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.dependantCreatedSuccess),
        backgroundColor: context.colors.pineGreen,
      ),
    );
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

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
          icon: const AppIcon(AppIcons.back, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.dependantNewTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            text: l10n.submitDependantBtn,
            iconName: AppIcons.check,
            onPressed: _submit,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            // Error banner if any
            if (_validationError != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.error),
                ),
                child: Row(
                  children: [
                    AppIcon(AppIcons.warning, color: colors.error, size: 20),
                    10.gapW,
                    Expanded(
                      child: Text(
                        _validationError!,
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.error),
                      ),
                    ),
                  ],
                ),
              ),
              14.gapH,
            ],

            // Dependant Full Name
            _buildLabel(l10n.dependantFullNameLabel, colors),
            6.gapH,
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration(colors, hint: 'Nguyễn Minh Quân', iconName: AppIcons.profile),
              validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập họ tên' : null,
            ),
            14.gapH,

            // Relationship Dropdown
            _buildLabel(l10n.dependantRelationshipLabel, colors),
            6.gapH,
            DropdownButtonFormField<String>(
              value: _selectedRelationship,
              decoration: _inputDecoration(colors, hint: '', iconName: AppIcons.dependants),
              items: _relationships
                  .map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 13.5))))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedRelationship = val);
              },
            ),
            14.gapH,

            // Date of Birth
            _buildLabel(l10n.dependantDobLabel, colors),
            6.gapH,
            TextFormField(
              controller: _dobController,
              decoration: _inputDecoration(colors, hint: '15/10/2022', iconName: AppIcons.calendar),
              validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập ngày sinh' : null,
            ),
            14.gapH,

            // Tax ID / CCCD / Birth Certificate No
            _buildLabel(l10n.dependantTaxIdLabel, colors),
            6.gapH,
            TextFormField(
              controller: _idNumberController,
              decoration: _inputDecoration(colors, hint: 'GKS: 88/2022/TPHCM hoặc CCCD', iconName: AppIcons.idCard),
              validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập số định danh / khai sinh' : null,
            ),
            14.gapH,

            // Effective Start Month
            _buildLabel(l10n.dependantStartMonthLabel, colors),
            6.gapH,
            TextFormField(
              controller: _startMonthController,
              decoration: _inputDecoration(colors, hint: '10/2026', iconName: AppIcons.calendar),
            ),
            16.gapH,

            // Proof Upload Box
            _buildLabel(l10n.dependantProofUploadLabel, colors),
            8.gapH,
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                setState(() => _attachedDocName = 'GKS_NguyenMinhQuan.pdf');
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _attachedDocName != null ? colors.pineGreen : colors.border,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  children: [
                    AppIcon(
                      _attachedDocName != null ? AppIcons.check : AppIcons.attach,
                      color: _attachedDocName != null ? colors.pineGreen : colors.primaryIndigo,
                      size: 24,
                    ),
                    12.gapW,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _attachedDocName ?? 'Nhấn để tải lên Giấy khai sinh/CCCD',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _attachedDocName != null ? colors.pineGreen : colors.textPrimary,
                            ),
                          ),
                          Text(
                            _attachedDocName != null ? 'Đã đính kèm minh chứng hợp lệ' : 'Định dạng PDF, JPG, PNG tối đa 10MB',
                            style: TextStyle(fontSize: 11, color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.gapH,

            // Disclaimer Checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _agreedToDisclaimer,
                  activeColor: colors.primaryIndigo,
                  onChanged: (val) => setState(() => _agreedToDisclaimer = val ?? false),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      l10n.dependantDisclaimer,
                      style: TextStyle(fontSize: 12, color: colors.textSecondary, height: 1.35),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, AppColorsExtension colors) {
    return Text(
      text,
      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
    );
  }

  InputDecoration _inputDecoration(AppColorsExtension colors, {required String hint, required String iconName}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13, color: colors.textTertiary),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: AppIcon(iconName, size: 20, color: colors.textTertiary),
      ),
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.primaryIndigo, width: 1.5)),
    );
  }
}
