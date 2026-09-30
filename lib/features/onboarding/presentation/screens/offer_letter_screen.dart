import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';

/// Screen 2 / OB-Letter: Official job offer review & candidate acceptance.
class OfferLetterScreen extends StatefulWidget {
  const OfferLetterScreen({super.key});

  @override
  State<OfferLetterScreen> createState() => _OfferLetterScreenState();
}

class _OfferLetterScreenState extends State<OfferLetterScreen> {
  bool _isAccepted = true;

  void _acceptOffer() {
    setState(() => _isAccepted = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.offerAcceptedBadge),
        backgroundColor: context.colors.pineGreen,
      ),
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
          l10n.offerLetterTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          if (_isAccepted)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: StatusChip(
                  label: l10n.offerAcceptedBadge,
                  type: AppStatusType.approved,
                ),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Letter Header Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'VSTECH HR DEPARTMENT',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: colors.primaryIndigo),
                    ),
                    Text('24/09/2026', style: TextStyle(fontSize: 12, color: colors.textTertiary)),
                  ],
                ),
                10.gapH,
                Text(
                  'Thư mời nhận việc: Giám sát cửa hàng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: colors.textPrimary),
                ),
                6.gapH,
                Text(
                  'Kính gửi Ông Nguyễn Minh Tuấn,\nCông ty Cổ phần Công nghệ VSTECH trân trọng chúc mừng và gửi đến bạn thư mời nhận việc với các thỏa thuận chi tiết như sau:',
                  style: TextStyle(fontSize: 13, color: colors.textSecondary, height: 1.45),
                ),
              ],
            ),
          ),
          16.gapH,

          // Key Terms & Conditions Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Điều khoản tuyển dụng',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary),
                ),
                12.gapH,
                _buildTermRow('Chức danh chuyên môn', 'Giám sát cửa hàng', colors),
                _buildTermRow('Bộ phận / Khối', 'Vận hành bán lẻ (Retail Ops)', colors),
                _buildTermRow('Địa điểm làm việc', 'Chi nhánh 01 (Quận 1, TP.HCM)', colors),
                _buildTermRow('Ngày bắt đầu đi làm', '01/10/2026', colors),
                _buildTermRow('Thời gian thử việc', '2 tháng (01/10 — 30/11/2026)', colors),
                _buildTermRow('Lương chính thức', '17.000.000 ₫ / tháng', colors),
                _buildTermRow('Lương thử việc (85%)', '14.450.000 ₫ / tháng', colors, isHighlight: true),
                _buildTermRow('Phụ cấp trách nhiệm', '2.500.000 ₫ / tháng', colors),
                _buildTermRow('Thời giờ làm việc', '48 giờ/tuần theo ca phân công', colors),
              ],
            ),
          ),
          16.gapH,

          // Welcome notice
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.pineGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.pineGreen),
            ),
            child: Row(
              children: [
                AppIcon(AppIcons.sparkles, color: colors.pineGreen, size: 24),
                12.gapW,
                Expanded(
                  child: Text(
                    'Chào mừng bạn đến với đại gia đình VSTECH! Vui lòng xác nhận chấp thuận trước ngày 28/09/2026.',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: colors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            text: _isAccepted ? l10n.offerAcceptedBadge : l10n.offerAcceptBtn,
            iconName: _isAccepted ? AppIcons.checkCircle2 : AppIcons.checkCircle,
            onPressed: _isAccepted ? null : _acceptOffer,
          ),
        ),
      ),
    );
  }

  Widget _buildTermRow(String label, String value, AppColorsExtension colors, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12.5, color: colors.textSecondary)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isHighlight ? FontWeight.w900 : FontWeight.w700,
              color: isHighlight ? colors.pineGreen : colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
