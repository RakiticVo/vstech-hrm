import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Screen F2: Business Trip Request (Công tác dài ngày).
class BusinessTripRequestScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<BusinessTripRequestScreen> createState() => _BusinessTripRequestScreenState();
}

class _BusinessTripRequestScreenState extends State<BusinessTripRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _startDate = DateTime.now().add(const Duration(days: 3));
  DateTime _endDate = DateTime.now().add(const Duration(days: 5));
  final _destinationController = TextEditingController(text: 'Chi nhánh Hà Nội & Hải Phòng');
  final _purposeController = TextEditingController(text: 'Hỗ trợ triển khai dây chuyền SMT mới và đào tạo kỹ thuật viên');
  final _colleaguesController = TextEditingController(text: 'Lê Văn Tùng (NV0142), Nguyễn Thị Mai (NV0089)');
  bool _hasPlan = true;

  @override
  void dispose() {
    _destinationController.dispose();
    _purposeController.dispose();
    _colleaguesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.businessTripSubmitSuccess)),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final daysCount = _endDate.difference(_startDate).inDays + 1;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          l10n.businessTripTitle,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: AppIcon(AppIcons.back, size: 22, color: colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              // Single-step manager approval info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.primaryIndigo.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.primaryIndigo.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    AppIcon(AppIcons.shield, color: colors.primaryIndigo, size: 20),
                    10.gapW,
                    Expanded(
                      child: Text(
                        l10n.businessTripSubtitle,
                        style: TextStyle(fontSize: 12, color: colors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              16.gapH,

              // Destination
              Text(l10n.businessTripDestination, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textPrimary)),
              6.gapH,
              TextFormField(
                controller: _destinationController,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: AppIcon(AppIcons.location, color: colors.textSecondary, size: 20),
                  ),
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                ),
                validator: (v) => v == null || v.isEmpty ? l10n.fillRequiredField : null,
              ),
              14.gapH,

              // Date Range Picker
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.delFromDate, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                        6.gapH,
                        _buildDateTile(
                          date: _startDate,
                          onPick: (d) => setState(() => _startDate = d),
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
                        Text(l10n.delToDate, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                        6.gapH,
                        _buildDateTile(
                          date: _endDate,
                          onPick: (d) => setState(() => _endDate = d),
                          colors: colors,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              8.gapH,
              Text(
                '${l10n.delTotalDays}: $daysCount ngày',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.primaryIndigo),
              ),
              14.gapH,

              // Purpose
              Text(l10n.businessTripPurpose, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textPrimary)),
              6.gapH,
              TextFormField(
                controller: _purposeController,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                ),
                validator: (v) => v == null || v.isEmpty ? l10n.fillRequiredField : null,
              ),
              14.gapH,

              // Accompanying Colleagues
              Text(l10n.businessTripColleagues, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textPrimary)),
              6.gapH,
              TextFormField(
                controller: _colleaguesController,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: AppIcon(AppIcons.mentor, color: colors.textSecondary, size: 20),
                  ),
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                ),
              ),
              14.gapH,

              // Plan attachment
              InkWell(
                onTap: () => setState(() => _hasPlan = !_hasPlan),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _hasPlan ? colors.pineGreen : colors.border),
                  ),
                  child: Row(
                    children: [
                      AppIcon(_hasPlan ? AppIcons.check : AppIcons.attach, color: _hasPlan ? colors.pineGreen : colors.textSecondary),
                      10.gapW,
                      Expanded(
                        child: Text(
                          _hasPlan ? 'ke_hoach_cong_tac_HN_HP_2026.docx' : l10n.businessTripPlan,
                          style: TextStyle(
                            fontSize: 13,
                            color: _hasPlan ? colors.pineGreen : colors.textSecondary,
                            fontWeight: _hasPlan ? FontWeight.w700 : FontWeight.normal,
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

  Widget _buildDateTile({
    required DateTime date,
    required ValueChanged<DateTime> onPick,
    required AppColorsExtension colors,
  }) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now().subtract(const Duration(days: 7)),
          lastDate: DateTime.now().add(const Duration(days: 90)),
        );
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
              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: colors.textPrimary),
            ),
            AppIcon(AppIcons.calendar, size: 18, color: colors.textSecondary),
          ],
        ),
      ),
    );
  }
}
