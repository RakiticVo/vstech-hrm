import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';

/// Screen 18 / F13: Referral application form (`refer` in mockup & flow).
class ReferralFormScreen extends StatefulWidget {
  const ReferralFormScreen({
    this.prefilledPosition = 'Quản lý cửa hàng',
    super.key,
  });

  final String prefilledPosition;

  @override
  State<ReferralFormScreen> createState() => _ReferralFormScreenState();
}

class _ReferralFormScreenState extends State<ReferralFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  late String _selectedPosition;
  String _selectedBranch = 'Chi nhánh 01 (Quận 1, TP.HCM)';
  String? _cvFileName;
  String? _errorMessage;

  final _positions = [
    'Quản lý cửa hàng',
    'Chuyên viên Đào tạo',
    'Giám sát kho vận',
    'Nhân viên Thu ngân cấp cao',
    'Chuyên viên Tuyển dụng',
  ];

  final _branches = [
    'Chi nhánh 01 (Quận 1, TP.HCM)',
    'Chi nhánh 02 (Bình Thạnh, TP.HCM)',
    'Chi nhánh 03 (Thủ Đức, TP.HCM)',
    'Kho tổng Dĩ An (Bình Dương)',
    'Văn phòng Hà Nội (Hoàn Kiếm)',
  ];

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.prefilledPosition;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    // Duplicate rule check: 6 months policy
    if (phone.endsWith('9999')) {
      setState(() {
        _errorMessage = context.l10n.candidateDuplicateError;
      });
      return;
    }

    context.push(
      AppRoutes.referralSuccess,
      extra: {
        'candidateName': _nameController.text.trim(),
        'position': _selectedPosition,
        'branch': _selectedBranch,
        'trackingCode': 'REF-2026-0812',
      },
    );
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
          icon: AppIcon(AppIcons.arrowLeft, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.referralFormTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            // Error banner if duplicate
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.error),
                ),
                child: Row(
                  children: [
                    AppIcon(AppIcons.alertTriangle, color: colors.error, size: 22),
                    10.gapW,
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.error),
                      ),
                    ),
                  ],
                ),
              ),
              16.gapH,
            ],

            // Candidate Name
            Text(
              l10n.candidateNameLabel,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
            ),
            6.gapH,
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration(colors, hint: 'Nguyễn Văn A', iconName: AppIcons.user),
              validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập tên ứng viên' : null,
            ),
            14.gapH,

            // Candidate Phone
            Text(
              l10n.candidatePhoneLabel,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
            ),
            6.gapH,
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration(colors, hint: '0901234567', iconName: AppIcons.phone),
              validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập số điện thoại' : null,
            ),
            14.gapH,

            // Candidate Email
            Text(
              l10n.candidateEmailLabel,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
            ),
            6.gapH,
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration(colors, hint: 'ungvien@example.com', iconName: AppIcons.mail),
              validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập email' : null,
            ),
            14.gapH,

            // Position Dropdown
            Text(
              l10n.candidatePositionLabel,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
            ),
            6.gapH,
            DropdownButtonFormField<String>(
              value: _selectedPosition,
              decoration: _inputDecoration(colors, hint: '', iconName: AppIcons.briefcase),
              items: _positions.map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 13.5)))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedPosition = val);
              },
            ),
            14.gapH,

            // Desired Branch Dropdown
            Text(
              l10n.candidateBranchLabel,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
            ),
            6.gapH,
            DropdownButtonFormField<String>(
              value: _selectedBranch,
              decoration: _inputDecoration(colors, hint: '', iconName: AppIcons.mapPin),
              items: _branches.map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontSize: 13.5)))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedBranch = val);
              },
            ),
            14.gapH,

            // CV Upload box
            Text(
              l10n.candidateCvLabel,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textSecondary),
            ),
            6.gapH,
            InkWell(
              onTap: () {
                setState(() {
                  _cvFileName = _cvFileName == null ? 'cv_ung_vien_2026.pdf (1.5 MB)' : null;
                });
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _cvFileName != null ? colors.pineGreen : colors.border),
                ),
                child: Row(
                  children: [
                    AppIcon(
                      _cvFileName != null ? AppIcons.checkCircle2 : AppIcons.upload,
                      color: _cvFileName != null ? colors.pineGreen : colors.primaryIndigo,
                      size: 24,
                    ),
                    12.gapW,
                    Expanded(
                      child: Text(
                        _cvFileName != null
                            ? l10n.candidateCvSelected(_cvFileName!)
                            : 'Nhấn để chọn tệp CV ứng viên',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: _cvFileName != null ? FontWeight.w700 : FontWeight.w500,
                          color: _cvFileName != null ? colors.pineGreen : colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            24.gapH,

            // Submit Button
            PrimaryButton(
              text: l10n.submitReferralBtn,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(AppColorsExtension colors, {required String hint, required String iconName}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: colors.surface,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: AppIcon(iconName, size: 20, color: colors.textSecondary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
    );
  }
}
