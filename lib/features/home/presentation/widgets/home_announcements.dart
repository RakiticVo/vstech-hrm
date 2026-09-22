import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Latest Announcements / Updates section on Home screen.
/// Follows Phone.dc.html lines 215–231.
class HomeAnnouncements extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final items = [
      _AnnouncementItem(
        badgeText: 'P',
        title: l10n.demoLeaveApprovedAnnouncement,
        time: l10n.twoHoursAgo,
      ),
      _AnnouncementItem(
        badgeText: 'L',
        title: l10n.demoSalaryAnnouncement,
        time: l10n.oneDayAgo,
      ),
    ];

    final badgeSize = context.custom(compact: 30, normal: 34, expanded: 38).toDouble();
    final cardPadding = context.custom(compact: 10, normal: 13, expanded: 16).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              l10n.latestUpdatesTitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
                color: colors.textPrimary,
              ),
            ),
            InkWell(
              onTap: () {},
              child: Text(
                l10n.viewAll,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colors.primaryIndigo,
                ),
              ),
            ),
          ],
        ),
        11.gapH,
        Column(
          children: items
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: colors.border),
                      ),
                      padding: EdgeInsets.all(cardPadding),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: badgeSize,
                            height: badgeSize,
                            decoration: BoxDecoration(
                              color: colors.cardSecondary,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Center(
                              child: Text(
                                item.badgeText,
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
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    height: 1.35,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                3.gapH,
                                Text(
                                  item.time,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _AnnouncementItem {
  const new({
    required this.badgeText,
    required this.title,
    required this.time,
  });

  final String badgeText;
  final String title;
  final String time;
}
