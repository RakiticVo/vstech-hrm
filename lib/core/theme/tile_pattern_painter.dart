import 'package:flutter/material.dart';

/// Saigon Tile (Gạch bông Sài Gòn) canvas pattern painter.
/// Faithfully reproduces the official 46x46 Saigon tile geometry specified in
/// `docs/ui/DESIGN.md` and `assets/images/background/gach-bong-tile-46.svg`.
class TilePatternPainter extends CustomPainter {
  const new({
    required this.backgroundColor,
    required this.patternColor,
    this.tileSize = 46.0,
  });

  final Color backgroundColor;
  final Color patternColor;
  final double tileSize;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..clipRect(Offset.zero & size);

    // 1. Draw solid background (#0A544E or theme color)
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final scale = tileSize / 46.0;

    // 2. Setup pattern paint matching gach-bong-tile-46.svg
    // Corner concentric arc stroke (r = 13.25, strokeWidth = 2.5 on 46x46 tile)
    final strokePaint = Paint()
      ..color = patternColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * scale;

    // Center dot fill (r = 2.75 on 46x46 tile)
    final fillPaint = Paint()
      ..color = patternColor
      ..style = PaintingStyle.fill;

    // 3. Grid tile drawing
    final cols = (size.width / tileSize).ceil() + 1;
    final rows = (size.height / tileSize).ceil() + 1;

    final cornerR = 13.25 * scale;
    final centerR = 2.75 * scale;

    // Draw all corner arcs at grid vertices
    for (var i = 0; i <= cols; i++) {
      final cx = i * tileSize;
      for (var j = 0; j <= rows; j++) {
        final cy = j * tileSize;
        canvas.drawCircle(Offset(cx, cy), cornerR, strokePaint);
      }
    }

    // Draw center dots in cell centers
    for (var i = 0; i < cols; i++) {
      final midX = (i + 0.5) * tileSize;
      for (var j = 0; j < rows; j++) {
        final midY = (j + 0.5) * tileSize;
        canvas.drawCircle(Offset(midX, midY), centerR, fillPaint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TilePatternPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.patternColor != patternColor ||
        oldDelegate.tileSize != tileSize;
  }
}
