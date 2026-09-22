import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Latest Announcements / Updates section on Home screen.
/// Follows Phone.dc.html lines 215–231.
class HomeAnnouncements extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final items = [
      const _AnnouncementItem(
        badgeText: 'P',
        title: 'Yêu cầu nghỉ phép 21–23/09 đã được phê duyệt.',
        time: '2 giờ trước',
      ),
      const _AnnouncementItem(
        badgeText: 'L',
        title: 'Phiếu lương tháng 9 đã có. Thực nhận 25.500.000 ₫.',
        time: '1 ngày trước',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'Cập nhật mới',
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
                'Xem tất cả',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colors.primaryIndigo,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
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
                      padding: const EdgeInsets.all(13),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
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
                          const SizedBox(width: 11),
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
                                const SizedBox(height: 3),
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
