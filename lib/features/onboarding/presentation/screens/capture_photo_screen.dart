import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';

/// Screen 5 / OB-Capture: Photo capture for employee ID badge.
class CapturePhotoScreen extends StatefulWidget {
  const CapturePhotoScreen({super.key});

  @override
  State<CapturePhotoScreen> createState() => _CapturePhotoScreenState();
}

class _CapturePhotoScreenState extends State<CapturePhotoScreen> {
  bool _isCaptured = false;

  void _takePhoto() {
    setState(() => _isCaptured = true);
  }

  void _retakePhoto() {
    setState(() => _isCaptured = false);
  }

  void _confirmPhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Đã lưu ảnh thẻ nhân viên 3x4'),
        backgroundColor: context.colors.pineGreen,
      ),
    );
    context.push(AppRoutes.onboardingOcr);
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
          l10n.capturePhotoTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.textPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            // Guidelines card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  AppIcon(AppIcons.info, color: colors.primaryIndigo, size: 22),
                  12.gapW,
                  Expanded(
                    child: Text(
                      l10n.capturePhotoGuide,
                      style: TextStyle(fontSize: 12.5, color: colors.textSecondary, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
            16.gapH,

            // Camera Viewfinder Box
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _isCaptured ? colors.pineGreen : colors.border, width: 2),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!_isCaptured) ...[
                      // Face alignment oval frame
                      Container(
                        width: 200,
                        height: 260,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: AppIcon(
                            AppIcons.user,
                            size: 100,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        child: Text(
                          'Căn chỉnh khuôn mặt vào khung bầu dục',
                          style: TextStyle(fontSize: 12.5, color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ] else ...[
                      // Photo Preview Mode
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundColor: colors.primaryIndigo,
                            child: const Text(
                              'T',
                              style: TextStyle(fontSize: 54, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          ),
                          16.gapH,
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: colors.pineGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppIcon(AppIcons.check, size: 16, color: Colors.white),
                                SizedBox(width: 6),
                                Text(
                                  'Ảnh đạt tiêu chuẩn 3x4',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            16.gapH,

            // Action Buttons
            if (!_isCaptured)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentAmber,
                    foregroundColor: const Color(0xFF1C1408),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _takePhoto,
                  icon: const AppIcon(AppIcons.camera, size: 22, color: Color(0xFF1C1408)),
                  label: Text(l10n.capturePhotoBtn, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.textPrimary,
                        side: BorderSide(color: colors.border),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _retakePhoto,
                      child: const Text('Chụp lại', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  12.gapW,
                  Expanded(
                    child: PrimaryButton(
                      text: l10n.confirmPhotoBtn,
                      onPressed: _confirmPhoto,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
