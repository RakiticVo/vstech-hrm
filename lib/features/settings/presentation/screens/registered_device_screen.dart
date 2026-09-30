import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Screen B3: Registered Device & Anti-Fraud Security Status.
class RegisteredDeviceScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<RegisteredDeviceScreen> createState() => _RegisteredDeviceScreenState();
}

class _RegisteredDeviceScreenState extends State<RegisteredDeviceScreen> {
  bool _mockGpsSimulated = false;
  bool _rootSimulated = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          l10n.registeredDeviceTitle,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: AppIcon(AppIcons.arrowLeft, color: colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            // Device Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colors.primaryIndigo.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: AppIcon(AppIcons.smartphone, color: colors.primaryIndigo, size: 22),
                      ),
                      12.gapW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'iPhone 15 Pro Max',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                              ),
                            ),
                            2.gapH,
                            Text(
                              'UUID: VST-88A9-4CF1-90B2-HCM',
                              style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.pineGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l10n.statusRecorded,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: colors.pineGreen),
                        ),
                      ),
                    ],
                  ),
                  14.gapH,
                  Divider(height: 1, color: colors.border),
                  12.gapH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.deviceRegisteredDate, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                      Text('15/01/2026 08:30', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                    ],
                  ),
                ],
              ),
            ),
            16.gapH,

            // 4 Security Check Indicators
            Text(
              l10n.registeredDeviceSub,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textSecondary),
            ),
            10.gapH,
            _buildCheckItem(l10n.deviceCheckRegistered, true, colors),
            8.gapH,
            _buildCheckItem(l10n.deviceCheckNotRooted, !_rootSimulated, colors),
            8.gapH,
            _buildCheckItem(l10n.deviceCheckNoMockGps, !_mockGpsSimulated, colors),
            8.gapH,
            _buildCheckItem(l10n.deviceCheckIntegrity, true, colors),
            20.gapH,

            // Demo Sandbox Simulation Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.accentAmber.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.accentAmber.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppIcon(AppIcons.sparkles, color: colors.accentAmber, size: 20),
                      8.gapW,
                      Text(
                        l10n.deviceDemoTogglesTitle,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary),
                      ),
                    ],
                  ),
                  12.gapH,
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.deviceSimulateMockGps, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    value: _mockGpsSimulated,
                    activeThumbColor: colors.error,
                    onChanged: (v) => setState(() => _mockGpsSimulated = v),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.deviceSimulateRoot, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    value: _rootSimulated,
                    activeThumbColor: colors.error,
                    onChanged: (v) => setState(() => _rootSimulated = v),
                  ),
                  12.gapH,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (_mockGpsSimulated || _rootSimulated) ? colors.error : colors.primaryIndigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(42),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final blockType = _rootSimulated ? 'root' : (_mockGpsSimulated ? 'mock' : 'safe');
                      if (blockType == 'safe') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.deviceCheckIntegrity)),
                        );
                      } else {
                        unawaited(context.push(AppRoutes.deviceBlock, extra: blockType));
                      }
                    },
                    child: Text(
                      (_mockGpsSimulated || _rootSimulated) ? l10n.deviceTestBlockCta : l10n.deviceCheckSafetyBtn,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(String title, bool isPassed, AppColorsExtension colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isPassed ? colors.border : colors.error),
      ),
      child: Row(
        children: [
          AppIcon(
            isPassed ? AppIcons.checkCircle2 : AppIcons.xCircle,
            color: isPassed ? colors.pineGreen : colors.error,
            size: 20,
          ),
          12.gapW,
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isPassed ? colors.textPrimary : colors.error,
              ),
            ),
          ),
          Text(
            isPassed ? 'OK' : 'FAIL',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isPassed ? colors.pineGreen : colors.error,
            ),
          ),
        ],
      ),
    );
  }
}
