import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

class RequestData {
  const new({
    required this.mark,
    required this.type,
    required this.dates,
    required this.status,
    required this.statusCode,
    required this.stage,
    required this.completedSteps,
  });

  final String mark;
  final String type;
  final String dates;
  final String status;
  final int statusCode;
  final String stage;
  final int completedSteps;
}

class RequestCard extends StatelessWidget {
  const new({
    required this.item,
    super.key,
  });

  final RequestData item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final statusColor = switch (item.statusCode) {
      2 => colors.pineGreen,
      3 => colors.error,
      _ => item.status == 'Cần bổ sung' ? colors.error : colors.accentAmber,
    };

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.cardSecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    item.mark,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: colors.primaryIndigo,
                    ),
                  ),
                ),
              ),
              11.gapW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.type,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                    2.gapH,
                    Text(
                      item.dates,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          13.gapH,
          Divider(height: 1, color: colors.border),
          12.gapH,

          // 4-step progress bar
          Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: i < item.completedSteps ? statusColor : colors.border,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                if (i < 3) 5.gapW,
              ],
              8.gapW,
              Text(
                item.stage,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
