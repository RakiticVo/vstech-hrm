import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/date_formatter_extension.dart';
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
    this.totalSteps = 2,
    this.requestTypeKey = 'all',
    this.code,
    this.requesterName,
    this.reason,
    this.worktime,
    this.createdBy,
    this.isProxy = false,
    this.confirmerName,
  });

  final String mark;
  final String type;
  final String dates;
  final String status;
  final int statusCode;
  final String stage;
  final int completedSteps;
  final int totalSteps;
  final String requestTypeKey;
  final String? code;
  final String? requesterName;
  final String? reason;
  final double? worktime;
  final String? createdBy;
  final bool isProxy;
  final String? confirmerName;
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
                      maxLines: 3,
                      softWrap: true,
                    ),
                    if (item.code != null && item.code!.isNotEmpty) ...[
                      2.gapH,
                      Text(
                        '#${item.code}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.primaryIndigo,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    3.gapH,
                    Text(
                      item.dates.toDisplayDate(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                      maxLines: 3,
                      softWrap: true,
                    ),
                    if (item.createdBy != null && item.createdBy!.isNotEmpty) ...[
                      3.gapH,
                      Row(
                        children: [
                          Icon(Icons.person_outline_rounded, size: 12, color: colors.accentAmber),
                          3.gapW,
                          Expanded(
                            child: Text(
                              'Tạo bởi: ${item.createdBy}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: colors.accentAmber,
                              ),
                              maxLines: 2,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (item.confirmerName != null && item.confirmerName!.isNotEmpty) ...[
                      3.gapH,
                      Row(
                        children: [
                          Icon(Icons.verified_outlined, size: 12, color: colors.tealPrimary),
                          3.gapW,
                          Expanded(
                            child: Text(
                              'Duyệt bởi: ${item.confirmerName}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: colors.tealPrimary,
                              ),
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              8.gapW,
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

          // Dynamic approval chain progress bar matching request type
          Row(
            children: [
              for (var i = 0; i < item.totalSteps; i++) ...[
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: i < item.completedSteps ? statusColor : colors.border,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                if (i < item.totalSteps - 1) 5.gapW,
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
