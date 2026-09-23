import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/qr_auth/domain/entities/qr_login_request_entity.dart';

/// Modal bottom sheet displaying detailed QR login request metadata and confirmation actions.
class QrConfirmationBottomSheet extends StatelessWidget {
  const new({
    required this.request,
    required this.onApprove,
    required this.onReject,
    this.isProcessing = false,
    super.key,
  });

  final QrLoginRequestEntity request;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final timeStr = DateFormat('HH:mm:ss • dd/MM/yyyy').format(request.requestTime);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          16.gapH,
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.primaryIndigo.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Symbols.desktop_windows, color: colors.primaryIndigo, size: 24),
              ),
              12.gapW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.qrConfirmTitle,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    2.gapH,
                    Text(
                      l10n.qrConfirmPrompt,
                      style: TextStyle(fontSize: 12, color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.gapH,

          // Details Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              children: [
                _buildRow(l10n.qrBrowserLabel, request.browser, Symbols.web, colors),
                Divider(height: 14, color: colors.border.withValues(alpha: 0.5)),
                _buildRow(l10n.qrDeviceLabel, request.device, Symbols.computer, colors),
                Divider(height: 14, color: colors.border.withValues(alpha: 0.5)),
                _buildRow(l10n.qrLocationLabel, request.location, Symbols.pin_drop, colors),
                Divider(height: 14, color: colors.border.withValues(alpha: 0.5)),
                _buildRow(l10n.qrIpAddressLabel, request.ipAddress, Symbols.dns, colors),
                Divider(height: 14, color: colors.border.withValues(alpha: 0.5)),
                _buildRow(l10n.qrRequestTimeLabel, timeStr, Symbols.schedule, colors),
              ],
            ),
          ),
          14.gapH,

          // Security warning
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Symbols.shield, color: Color(0xFFD97706), size: 16),
              8.gapW,
              Expanded(
                child: Text(
                  'Yêu cầu đăng nhập này sẽ tự động hết hạn sau ${request.remainingSeconds} giây.',
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFFB45309)),
                ),
              ),
            ],
          ),
          20.gapH,

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.error,
                    side: BorderSide(color: colors.error.withValues(alpha: 0.5)),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isProcessing ? null : onReject,
                  child: Text(
                    l10n.qrRejectButton,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              12.gapW,
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.pineGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isProcessing ? null : onApprove,
                  icon: isProcessing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Symbols.fingerprint, size: 20),
                  label: Text(
                    isProcessing ? 'Đang xác thực...' : l10n.qrApproveButton,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, IconData icon, AppColorsExtension colors) {
    return Row(
      children: [
        Icon(icon, size: 16, color: colors.textTertiary),
        8.gapW,
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colors.textSecondary),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
