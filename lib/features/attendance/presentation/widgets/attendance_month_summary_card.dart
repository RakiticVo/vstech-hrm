import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Donut chart and legend for monthly attendance summary (Screen 05).
class AttendanceMonthSummaryCard extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final legends = [
      ('Có mặt', '18 ngày', colors.pineGreen),
      ('Nghỉ phép', '2 ngày', colors.accentAmber),
      ('Thiếu công', '1 ngày', colors.error),
      ('Ngày lễ', '1 ngày', colors.primaryIndigo),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
            children: [
              // Donut chart with 18 in center
              SizedBox(
                width: 96,
                height: 96,
                child: CustomPaint(
                  painter: _AttendanceDonutPainter(
                    present: 18,
                    leave: 2,
                    missing: 1,
                    holiday: 1,
                    colors: colors,
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '18',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'ngày công',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 22),
              // Legend column
              Expanded(
                child: Column(
                  children: legends
                      .map((l) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: l.$3,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      l.$1,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  l.$2,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: colors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
    );
  }
}

class _AttendanceDonutPainter extends CustomPainter {
  const new({
    required this.present,
    required this.leave,
    required this.missing,
    required this.holiday,
    required this.colors,
  });

  final int present;
  final int leave;
  final int missing;
  final int holiday;
  final AppColorsExtension colors;

  @override
  void paint(Canvas canvas, Size size) {
    final total = present + leave + missing + holiday;
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 12) / 2;
    const strokeWidth = 10.0;

    final segments = [
      (present, colors.pineGreen),
      (leave, colors.accentAmber),
      (missing, colors.error),
      (holiday, colors.primaryIndigo),
    ];

    var startAngle = -math.pi / 2;

    for (final seg in segments) {
      final sweepAngle = (seg.$1 / total) * 2 * math.pi;
      final paint = Paint()
        ..color = seg.$2
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle - 0.05, // small gap between arcs
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _AttendanceDonutPainter old) => false;
}
