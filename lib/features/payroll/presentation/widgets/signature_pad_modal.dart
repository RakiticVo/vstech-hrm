import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';

/// Interactive custom canvas signature pad bottom sheet modal.
class SignaturePadModal extends StatefulWidget {
  const SignaturePadModal({
    required this.onSignatureConfirmed,
    super.key,
  });

  final void Function(List<List<Offset>> strokes) onSignatureConfirmed;

  static Future<void> show(
    BuildContext context, {
    required void Function(List<List<Offset>> strokes) onConfirmed,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SignaturePadModal(onSignatureConfirmed: onConfirmed),
    );
  }

  @override
  State<SignaturePadModal> createState() => _SignaturePadModalState();
}

class _SignaturePadModalState extends State<SignaturePadModal> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];
  bool _agreedToDisclaimer = true;

  void _clear() {
    setState(() {
      _strokes.clear();
      _currentStroke = [];
    });
  }

  void _confirm() {
    if (_strokes.isEmpty && _currentStroke.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.signPadEmptyAlert)),
      );
      return;
    }
    final allStrokes = List<List<Offset>>.from(_strokes);
    if (_currentStroke.isNotEmpty) {
      allStrokes.add(List<Offset>.from(_currentStroke));
    }
    Navigator.of(context).pop();
    widget.onSignatureConfirmed(allStrokes);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.signPadTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: _clear,
                icon: const AppIcon(AppIcons.sync, size: 16),
                label: Text(l10n.signPadClear),
              ),
            ],
          ),
          4.gapH,
          Text(
            l10n.signPadSubtitle,
            style: TextStyle(fontSize: 12.5, color: colors.textSecondary),
          ),
          16.gapH,

          // Canvas signature box
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border, width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _currentStroke = [details.localPosition];
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    _currentStroke.add(details.localPosition);
                  });
                },
                onPanEnd: (_) {
                  setState(() {
                    if (_currentStroke.isNotEmpty) {
                      _strokes.add(List.from(_currentStroke));
                      _currentStroke = [];
                    }
                  });
                },
                child: CustomPaint(
                  painter: _SignaturePainter(
                    strokes: _strokes,
                    currentStroke: _currentStroke,
                    strokeColor: colors.primaryIndigo,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          14.gapH,

          // Disclaimer row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _agreedToDisclaimer,
                onChanged: (val) => setState(() => _agreedToDisclaimer = val ?? true),
                activeColor: colors.primaryIndigo,
              ),
              Expanded(
                child: Text(
                  l10n.signPadDisclaimer,
                  style: TextStyle(fontSize: 11.5, color: colors.textSecondary, height: 1.35),
                ),
              ),
            ],
          ),
          16.gapH,

          // Confirm button
          PrimaryButton(
            text: l10n.signPadConfirm,
            iconName: AppIcons.sign,
            onPressed: _agreedToDisclaimer ? _confirm : null,
          ),
        ],
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  const _SignaturePainter({
    required this.strokes,
    required this.currentStroke,
    required this.strokeColor,
  });

  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      _drawStroke(canvas, stroke, paint);
    }
    _drawStroke(canvas, currentStroke, paint);
  }

  void _drawStroke(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.length < 2) {
      if (points.isNotEmpty) {
        canvas.drawCircle(points.first, 1.5, paint);
      }
      return;
    }
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
