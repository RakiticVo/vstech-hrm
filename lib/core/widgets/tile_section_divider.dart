import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// 14px high Saigon Tile Section Divider band used across Home & Dashboards.
/// Follows DESIGN.md §3 (22px tile size, 14px height).
class TileSectionDivider extends StatelessWidget {
  const new({
    this.height = 14.0,
    super.key,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patternColor = isDark
        ? const Color(0xFF2DD4BF).withValues(alpha: 0.16)
        : const Color(0xFFFFF8EC).withValues(alpha: 0.19);

    return Container(
      width: double.infinity,
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: colors.primaryIndigo,
      ),
      child: ClipRect(
        child: CustomPaint(
          painter: _TileDividerPainter(
            backgroundColor: colors.primaryIndigo,
            patternColor: patternColor,
          ),
        ),
      ),
    );
  }
}

class _TileDividerPainter extends CustomPainter {
  const new({
    required this.backgroundColor,
    required this.patternColor,
  });

  final Color backgroundColor;
  final Color patternColor;
  static const double tileSize = 22;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..clipRect(Offset.zero & size);

    // Solid background
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final strokePaint = Paint()
      ..color = patternColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final dotPaint = Paint()
      ..color = patternColor
      ..style = PaintingStyle.fill;

    final cols = (size.width / tileSize).ceil() + 1;

    for (var i = 0; i < cols; i++) {
      final x = i * tileSize;

      // Center top dot, bottom-left and bottom-right arcs
      canvas
        ..drawCircle(Offset(x + tileSize / 2, 0), 2.5, dotPaint)
        ..drawCircle(Offset(x, size.height), 7, strokePaint)
        ..drawCircle(Offset(x + tileSize, size.height), 7, strokePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TileDividerPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.patternColor != patternColor;
  }
}
