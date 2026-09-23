import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Modal sheet offering interactive test payloads for verifying all QR edge cases.
class QrSamplePayloadsSheet extends StatelessWidget {
  const new({required this.onSelectPayload, super.key});

  final ValueChanged<String> onSelectPayload;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final samples = [
      (
        'QR Hợp lệ (Máy trạm Xưởng A)',
        'vstech://qr-login?session=SESS_VALID_01&browser=Chrome+122&device=Workstation+A',
        Symbols.check_circle,
        const Color(0xFF16A34A),
      ),
      (
        'QR Hết hạn (> 5 phút)',
        'vstech://qr-login?session=SESS_EXPIRED&status=expired',
        Symbols.timer_off,
        const Color(0xFFD97706),
      ),
      (
        'QR Đã sử dụng trước đó',
        'vstech://qr-login?session=SESS_USED&status=used',
        Symbols.history,
        const Color(0xFF2563EB),
      ),
      (
        'QR Bị huỷ bởi máy tính trạm',
        'vstech://qr-login?session=SESS_CANCELLED&status=cancelled',
        Symbols.cancel,
        const Color(0xFF6B7280),
      ),
      (
        'QR Sai định dạng / Không thuộc VSTech',
        'https://external-website.com/invalid-code',
        Symbols.error,
        const Color(0xFFDC2626),
      ),
    ];

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
          Text(
            'Mã QR Mẫu để Thử Nghiệm',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          4.gapH,
          Text(
            'Chọn trường hợp kiểm thử để mô phỏng quét QR tức thì:',
            style: TextStyle(fontSize: 12.5, color: colors.textSecondary),
          ),
          16.gapH,
          ...samples.map((s) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: ListTile(
                leading: Icon(s.$3, color: s.$4, size: 22),
                title: Text(
                  s.$1,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                trailing: Icon(Symbols.chevron_right, size: 18, color: colors.textTertiary),
                onTap: () {
                  Navigator.of(context).pop();
                  onSelectPayload(s.$2);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
