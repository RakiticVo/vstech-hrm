import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/core/widgets/status_chip.dart';

/// Screen 6 / OB-OCR: Citizen ID (CCCD) scanning and automated OCR verification.
class OcrVerificationScreen extends StatefulWidget {
  const OcrVerificationScreen({super.key});

  @override
  State<OcrVerificationScreen> createState() => _OcrVerificationScreenState();
}

class _OcrVerificationScreenState extends State<OcrVerificationScreen> {
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
          l10n.ocrVerificationTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.textPrimary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // ID Card Front Mock Frame
          Container(
            height: 190,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.pineGreen, width: 2),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: AppIcon(AppIcons.user, size: 50, color: Colors.white.withValues(alpha: 0.4)),
                          ),
                        ),
                        20.gapW,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 140, height: 10, color: Colors.white.withValues(alpha: 0.3)),
                            8.gapH,
                            Container(width: 180, height: 12, color: colors.accentAmber.withValues(alpha: 0.6)),
                            8.gapH,
                            Container(width: 110, height: 10, color: Colors.white.withValues(alpha: 0.3)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: StatusChip(label: l10n.ocrVerifiedBadge, type: AppStatusType.approved),
                ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  child: Row(
                    children: [
                      AppIcon(AppIcons.scan, size: 16, color: colors.accentAmber),
                      6.gapW,
                      const Text(
                        'Đã trích xuất dữ liệu chip NFC',
                        style: TextStyle(fontSize: 11.5, color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          18.gapH,

          // Extracted Details Card
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
                      'Kết quả trích xuất tự động',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary),
                    ),
                    const AppIcon(AppIcons.checkCircle2, size: 18, color: Color(0xFF0F766E)),
                  ],
                ),
                12.gapH,
                _buildInfoRow('Số CCCD gắn chip', '079094001234', colors, isBold: true),
                _buildInfoRow('Họ và tên', 'NGUYEN MINH TUAN', colors, isBold: true),
                _buildInfoRow('Ngày sinh', '14/03/1994', colors),
                _buildInfoRow('Giới tính', 'Nam', colors),
                _buildInfoRow('Quốc tịch', 'Việt Nam', colors),
                _buildInfoRow('Quê quán', 'Quận 3, TP. Hồ Chí Minh', colors),
                _buildInfoRow('Nơi thường trú', '128 Cách Mạng Tháng 8, P.10, Q.3, TP.HCM', colors),
                _buildInfoRow('Ngày cấp', '12/04/2021', colors),
                _buildInfoRow('Nơi cấp', 'Cục Cảnh sát QLHC về TTXH', colors),
              ],
            ),
          ),
          16.gapH,

          // Cross-check Confirmation Note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.pineGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.pineGreen),
            ),
            child: Row(
              children: [
                AppIcon(AppIcons.checkCircle2, color: colors.pineGreen, size: 22),
                12.gapW,
                Expanded(
                  child: Text(
                    'Dữ liệu CCCD trùng khớp 100% với thông tin hồ sơ tuyển dụng. Hồ sơ đã được đồng bộ sang hệ thống HR.',
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
            text: 'Tiếp tục: Ký hợp đồng điện tử',
            iconName: AppIcons.edit3,
            onPressed: () => context.push(AppRoutes.onboardingSign),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, AppColorsExtension colors, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
