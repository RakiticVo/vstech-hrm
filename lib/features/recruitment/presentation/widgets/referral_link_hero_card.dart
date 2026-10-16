import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Hero card for sharing referral link and QR code.
class ReferralLinkHeroCard extends StatelessWidget {
  const ReferralLinkHeroCard({
    this.referralUrl = 'https://hrm.vstech.vn/r/nv04821',
    super.key,
  });

  final String referralUrl;

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: referralUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.linkCopiedSnackbar)),
    );
  }

  void _shareQr(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mã QR giới thiệu ứng viên'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.colors.border),
              ),
              child: Center(
                child: AppIcon(
                  AppIcons.qrCode,
                  size: 120,
                  color: context.colors.primaryIndigo,
                ),
              ),
            ),
            12.gapH,
            const Text(
              'Ứng viên quét mã để mở form nộp CV gắn mã giới thiệu của bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      color: colors.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.primaryIndigo,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.myReferralLinkTitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFF8EC),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.accentAmber,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Thưởng 3M/người',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1C1408),
                    ),
                  ),
                ),
              ],
            ),
            10.gapH,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const AppIcon(AppIcons.link, size: 18, color: Color(0xFFFFF8EC)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      referralUrl,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFFFFF8EC),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            12.gapH,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFFF8EC),
                      side: const BorderSide(color: Color(0xFFFFF8EC)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _copyLink(context),
                    icon: const AppIcon(AppIcons.copy, size: 16, color: Color(0xFFFFF8EC)),
                    label: Text(
                      l10n.copyLinkBtn,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                10.gapW,
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFFF8EC),
                      side: const BorderSide(color: Color(0xFFFFF8EC)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _shareQr(context),
                    icon: const AppIcon(AppIcons.qrCode, size: 16, color: Color(0xFFFFF8EC)),
                    label: Text(
                      l10n.shareQrBtn,
                      style: const TextStyle(fontSize: 12),
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
}
