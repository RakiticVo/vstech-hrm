import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';
import 'package:vstech_hrm/features/profile/presentation/widgets/profile_edit_field.dart';

/// Screen for editing profile with 2-tier approval policy:
/// Tier 1: Free edit (contact info) updates immediately.
/// Tier 2: Sensitive edit (Bank, CCCD, Permanent address) requires HR approval.
class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Free edit controllers
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _currentAddressController;
  late final TextEditingController _emergencyNameController;
  late final TextEditingController _emergencyPhoneController;

  // Sensitive controllers
  late final TextEditingController _bankNameController;
  late final TextEditingController _bankAccountController;
  late final TextEditingController _bankHolderController;
  late final TextEditingController _cccdController;
  late final TextEditingController _cccdIssueDateController;
  late final TextEditingController _permanentAddressController;

  bool _isPendingHr = false;
  String? _trackingCode;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: '+84 908 221 470');
    _emailController = TextEditingController(text: 'minh.tuan@company.vn');
    _currentAddressController = TextEditingController(text: '34 Lê Duẩn, Phường Bến Nghé, Quận 1, TP.HCM');
    _emergencyNameController = TextEditingController(text: 'Nguyễn Văn Nam (Bố ruột)');
    _emergencyPhoneController = TextEditingController(text: '0903 112 334');

    _bankNameController = TextEditingController(text: 'Vietcombank - CN Tân Bình');
    _bankAccountController = TextEditingController(text: '0071001234821');
    _bankHolderController = TextEditingController(text: 'NGUYEN MINH TUAN');
    _cccdController = TextEditingController(text: '079094001234');
    _cccdIssueDateController = TextEditingController(text: '12/04/2021');
    _permanentAddressController = TextEditingController(text: '128 Cách Mạng Tháng 8, P.10, Q.3, TP.HCM');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _currentAddressController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _bankNameController.dispose();
    _bankAccountController.dispose();
    _bankHolderController.dispose();
    _cccdController.dispose();
    _cccdIssueDateController.dispose();
    _permanentAddressController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;

    // Check if sensitive fields were modified from base values
    final hasSensitiveEdits = _bankAccountController.text.trim() != '0071001234821' ||
        _cccdController.text.trim() != '079094001234' ||
        _bankNameController.text.trim() != 'Vietcombank - CN Tân Bình' ||
        _permanentAddressController.text.trim() != '128 Cách Mạng Tháng 8, P.10, Q.3, TP.HCM';

    if (hasSensitiveEdits) {
      setState(() {
        _isPendingHr = true;
        _trackingCode = 'PR-REQ-2026-042';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.profilePendingHrAlert('PR-REQ-2026-042')),
          backgroundColor: context.colors.accentAmber,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.profileEditSuccess),
          backgroundColor: context.colors.pineGreen,
        ),
      );
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
          l10n.profileEditTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          if (_isPendingHr)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: StatusChip(
                  label: l10n.statusPendingHr,
                  type: AppStatusType.inProgress,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            text: l10n.saveChangesBtn,
            iconName: AppIcons.check,
            onPressed: _saveChanges,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            // Avatar change header
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: colors.primaryIndigo,
                    child: const Text(
                      'T',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colors.accentAmber,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.surface, width: 2),
                      ),
                      child: const AppIcon(AppIcons.camera, size: 18, color: Color(0xFF1C1408)),
                    ),
                  ),
                ],
              ),
            ),
            18.gapH,

            // Pending Alert Banner if HR approval is queued
            if (_isPendingHr) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.accentAmber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.accentAmber),
                ),
                child: Row(
                  children: [
                    AppIcon(AppIcons.attendance, color: colors.accentAmber, size: 22),
                    12.gapW,
                    Expanded(
                      child: Text(
                        l10n.profilePendingHrAlert(_trackingCode ?? 'PR-REQ-2026-042'),
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              18.gapH,
            ],

            // Section 1: Free Edit (Contact Info)
            ProfileEditSectionHeader(title: l10n.freeEditSection, iconName: AppIcons.documents),
            10.gapH,
            ProfileEditField(label: l10n.phoneEditLabel, controller: _phoneController, iconName: AppIcons.phone),
            12.gapH,
            ProfileEditField(label: l10n.emailEditLabel, controller: _emailController, iconName: AppIcons.mail),
            12.gapH,
            ProfileEditField(label: l10n.addressEditLabel, controller: _currentAddressController, iconName: AppIcons.home),
            12.gapH,
            ProfileEditField(label: l10n.emergencyNameLabel, controller: _emergencyNameController, iconName: AppIcons.profile),
            12.gapH,
            ProfileEditField(label: l10n.emergencyPhoneLabel, controller: _emergencyPhoneController, iconName: AppIcons.phone),
            22.gapH,

            // Section 2: Sensitive Info (Requires HR approval)
            ProfileEditSectionHeader(title: l10n.sensitiveEditSection, iconName: AppIcons.lock, isProtected: true),
            6.gapH,
            Text(
              l10n.sensitiveEditNotice,
              style: TextStyle(fontSize: 12, color: colors.textSecondary, height: 1.35),
            ),
            12.gapH,
            ProfileEditField(label: l10n.bankNameEditLabel, controller: _bankNameController, iconName: AppIcons.coin),
            12.gapH,
            ProfileEditField(label: l10n.bankAccountEditLabel, controller: _bankAccountController, iconName: AppIcons.idCard),
            12.gapH,
            ProfileEditField(label: l10n.bankHolderEditLabel, controller: _bankHolderController, iconName: AppIcons.profile),
            12.gapH,
            ProfileEditField(label: l10n.cccdEditLabel, controller: _cccdController, iconName: AppIcons.idCard),
            12.gapH,
            ProfileEditField(label: l10n.cccdIssueDateLabel, controller: _cccdIssueDateController, iconName: AppIcons.calendar),
            12.gapH,
            ProfileEditField(label: l10n.permanentAddressLabel, controller: _permanentAddressController, iconName: AppIcons.location),
          ],
        ),
      ),
    );
  }
}
