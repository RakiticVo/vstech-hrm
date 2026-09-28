import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Card displayed on the payslip once it has been electronically signed.
class PayslipSignedCard extends StatelessWidget {
  const PayslipSignedCard({
    required this.signerName,
    required this.signedAt,
    required this.verificationHash,
    this.signatureStrokes,
    super.key,
  });

  final String signerName;
  final String signedAt;
  final String verificationHash;
  final List<List<Offset>>? signatureStrokes;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.pineGreen.withValues(alpha: 0.4), width: 1.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.pineGreen.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Symbols.verified,
                    size: 22,
                    color: colors.pineGreen,
                  ),
                ),
              ),
              12.gapW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.payslipSignedBadge,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: colors.pineGreen,
                      ),
                    ),
                    Text(
                      l10n.payslipSignedSigner(signerName),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.gapH,
          Divider(height: 1, color: colors.border),
          12.gapH,

          // Signature drawing preview or seal
          if (signatureStrokes != null && signatureStrokes!.isNotEmpty)
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CustomPaint(
                  painter: _MiniSignaturePainter(
                    strokes: signatureStrokes!,
                    strokeColor: colors.primaryIndigo,
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  Icon(Symbols.draw, size: 18, color: colors.primaryIndigo),
                  8.gapW,
                  Text(
                    'Chữ ký điện tử số hóa xác thực',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          12.gapH,

          Text(
            l10n.payslipSignedAt(signedAt),
            style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
          ),
          4.gapH,
          Text(
            l10n.payslipSignedHash(verificationHash),
            style: TextStyle(
              fontSize: 10.5,
              fontFamily: 'monospace',
              color: colors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniSignaturePainter extends CustomPainter {
  const _MiniSignaturePainter({
    required this.strokes,
    required this.strokeColor,
  });

  final List<List<Offset>> strokes;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke.first.dx * 0.4, stroke.first.dy * 0.4);
      for (var i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx * 0.4, stroke[i].dy * 0.4);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MiniSignaturePainter oldDelegate) => false;
}
