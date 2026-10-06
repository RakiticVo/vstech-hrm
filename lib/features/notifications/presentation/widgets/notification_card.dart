import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

class NotificationItemData {
  const new({
    required this.id,
    required this.letter,
    required this.type,
    required this.time,
    required this.title,
    required this.isUnread,
    required this.accentColor,
    required this.bgColor,
  });

  final int id;
  final String letter;
  final String type;
  final String time;
  final String title;
  final bool isUnread;
  final Color accentColor;
  final Color bgColor;

  NotificationItemData copyWith({bool? isUnread}) => NotificationItemData(
        id: id,
        letter: letter,
        type: type,
        time: time,
        title: title,
        isUnread: isUnread ?? this.isUnread,
        accentColor: accentColor,
        bgColor: bgColor,
      );

  String categoryLabel(BuildContext context) {
    return switch (type) {
      'leave' => context.l10n.notificationCatLeave,
      'salary' => context.l10n.notificationCatSalary,
      'attendance' => context.l10n.notificationCatAttendance,
      'reward' => context.l10n.notificationCatReward,
      'recruitment' => context.l10n.notificationCatRecruitment,
      _ => context.l10n.notificationCatSystem,
    };
  }
}

class NotificationCard extends StatelessWidget {
  const new({
    required this.item,
    this.onTap,
    super.key,
  });

  final NotificationItemData item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.isUnread ? item.accentColor.withValues(alpha: 0.35) : colors.border,
            width: item.isUnread ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: item.bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  item.letter,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: item.accentColor,
                  ),
                ),
              ),
            ),
            12.gapW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.bgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.categoryLabel(context),
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: item.accentColor,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          if (item.isUnread)
                            Container(
                              width: 7,
                              height: 7,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: item.accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          Text(
                            item.time,
                            style: TextStyle(fontSize: 11, color: colors.textTertiary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  6.gapH,
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: item.isUnread ? FontWeight.w800 : FontWeight.w600,
                      color: colors.textPrimary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
