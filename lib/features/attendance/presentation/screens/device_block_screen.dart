import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Screen B3: Anti-fraud Block Screen for Rooted Devices or Mock GPS.
class DeviceBlockScreen extends StatelessWidget {
  const new({
    this.securityType = 'mock',
    super.key,
  });

  final String securityType;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final isRoot = securityType == 'root';

    final title = isRoot ? l10n.deviceBlockRootTitle : l10n.deviceBlockMockGpsTitle;
    final message = isRoot ? l10n.deviceBlockRootMsg : l10n.deviceBlockMockGpsMsg;
    final iconName = isRoot ? AppIcons.warning : AppIcons.locationOff;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          l10n.deviceSecurityTitle,
          style: TextStyle(color: colors.textPrimary, fontSize: 17, fontWeight: FontWeight.w800),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: AppIcon(AppIcons.close, color: colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(child: AppIcon(iconName, color: colors.error, size: 48)),
              ),
              24.gapH,
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              12.gapH,
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.55,
                  color: colors.textSecondary,
                ),
              ),
              24.gapH,

              // Security Audit Log Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.cardSecondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  children: [
                    _buildLogItem('Thời điểm', DateTime.now().toString().substring(0, 19), colors),
                    4.gapH,
                    _buildLogItem('Mã lỗi', isRoot ? 'SEC-ROOT-VIOLATION' : 'SEC-MOCK-GPS-VIOLATION', colors),
                    4.gapH,
                    _buildLogItem('Trạng thái', 'CHẶN CHẤM CÔNG', colors, valColor: colors.error),
                  ],
                ),
              ),
              32.gapH,

              // Action Buttons
              if (!isRoot)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primaryIndigo,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.deviceGpsRecheckedValid)),
                    );
                    Navigator.pop(context);
                  },
                  icon: const AppIcon(AppIcons.sync, size: 20, color: Colors.white),
                  label: Text(l10n.deviceRecheckBtn, style: const TextStyle(fontWeight: FontWeight.w800)),
                )
              else
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primaryIndigo,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.deviceContactHrSent)),
                    );
                    Navigator.pop(context);
                  },
                  icon: const AppIcon(AppIcons.headset, size: 20, color: Colors.white),
                  label: Text(l10n.deviceContactHrBtn, style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogItem(String label, String value, AppColorsExtension colors, {Color? valColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 11.5, color: colors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: valColor ?? colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
