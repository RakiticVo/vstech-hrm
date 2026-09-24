import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';

class DelegationPeriodCard extends StatelessWidget {
  const new({
    required this.fromDate,
    required this.toDate,
    required this.onSelectDateRange,
    super.key,
  });

  final DateTime fromDate;
  final DateTime toDate;
  final void Function(DateTime from, DateTime to) onSelectDateRange;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final dateFormat = DateFormat('dd/MM/yyyy');
    final totalDays = toDate.difference(fromDate).inDays + 1;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final range = await showDateRangePicker(
            context: context,
            firstDate: DateTime.now().subtract(const Duration(days: 1)),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            initialDateRange: DateTimeRange(start: fromDate, end: toDate),
          );
          if (range != null) {
            onSelectDateRange(range.start, range.end);
          }
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(15),
            vertical: context.h(8),
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Column(
            children: [
              _DateRow(
                label: l10n.delFromDate,
                value: dateFormat.format(fromDate),
              ),
              Divider(height: 1, color: colors.borderSubtle),
              _DateRow(
                label: l10n.delToDate,
                value: dateFormat.format(toDate),
              ),
              Divider(height: 1, color: colors.borderSubtle),
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.h(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.delTotalDays,
                      style: AppTextStyles.body.copyWith(
                        color: colors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$totalDays ngày',
                      style: AppTextStyles.bodyBold.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.h(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: colors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: AppTextStyles.bodyBold.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              AppGap.w6,
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: colors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
