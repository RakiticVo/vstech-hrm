import 'package:flutter/material.dart';

class TilePatternPainter extends CustomPainter {
  const new({
    required this.backgroundColor,
    required this.patternColor,
    this.tileSize = 48.0,
  });

  final Color backgroundColor;
  final Color patternColor;
  final double tileSize;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw solid background
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    // 2. Setup pattern paint
    final strokePaint = Paint()
      ..color = patternColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final fillPaint = Paint()
      ..color = patternColor.withValues(alpha: patternColor.a * 0.4)
      ..style = PaintingStyle.fill;

    // 3. Grid tile drawing
    final cols = (size.width / tileSize).ceil() + 1;
    final rows = (size.height / tileSize).ceil() + 1;

    for (var i = 0; i < cols; i++) {
      for (var j = 0; j < rows; j++) {
        final cx = i * tileSize;
        final cy = j * tileSize;

        // Draw corner arcs
        canvas
          ..drawCircle(Offset(cx, cy), tileSize * 0.42, strokePaint)
          ..drawCircle(Offset(cx, cy), tileSize * 0.22, strokePaint)
          ..drawCircle(Offset(cx, cy), tileSize * 0.08, fillPaint);

        // Draw 4 petal diamonds in tile center
        final midX = cx + tileSize / 2;
        final midY = cy + tileSize / 2;
        final petalR = tileSize * 0.16;

        final path = Path()
          ..moveTo(midX, midY - petalR)
          ..quadraticBezierTo(midX + petalR * 0.7, midY, midX, midY + petalR)
          ..quadraticBezierTo(midX - petalR * 0.7, midY, midX, midY - petalR)
          ..moveTo(midX - petalR, midY)
          ..quadraticBezierTo(midX, midY + petalR * 0.7, midX + petalR, midY)
          ..quadraticBezierTo(midX, midY - petalR * 0.7, midX - petalR, midY);

        canvas
          ..drawPath(path, strokePaint)
          ..drawCircle(Offset(midX, midY), 1.5, fillPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant TilePatternPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.patternColor != patternColor ||
        oldDelegate.tileSize != tileSize;
  }
}
