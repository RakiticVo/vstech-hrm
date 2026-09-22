import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Daily attendance logs list and holidays link (Screen 05 Part 2).
class AttendanceDailyLogCard extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final logs = [
      ('16', 'T4', 'Đang làm', '07:56 — …', '—', colors.primaryIndigo, colors.primaryIndigo.withValues(alpha: 0.12)),
      ('15', 'T3', 'Thiếu giờ ra', '08:01 — —', '—', colors.error, colors.error.withValues(alpha: 0.12)),
      ('14', 'T2', 'Đủ công', '07:58 — 17:02', '8h 04', colors.pineGreen, colors.pineGreen.withValues(alpha: 0.12)),
      ('13', 'CN', 'Nghỉ tuần', 'Không có ca', '0h 00', colors.textTertiary, colors.cardSecondary),
      ('12', 'T7', 'Đủ công · TC 3h', '07:55 — 21:00', '11h 05', colors.pineGreen, colors.pineGreen.withValues(alpha: 0.12)),
      ('11', 'T6', 'Đi muộn 12 phút', '08:12 — 17:05', '7h 53', colors.accentAmber, colors.accentAmber.withValues(alpha: 0.12)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nhật ký từng ngày',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            InkWell(
              onTap: () => context.push(AppRoutes.holidays),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  'Ngày lễ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.primaryIndigo,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.border),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logs.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              indent: 62,
              color: colors.border.withValues(alpha: 0.6),
            ),
            itemBuilder: (ctx, index) {
              final item = logs[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: item.$7,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.$1,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: item.$6,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.$2,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: item.$6,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.$3,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: item.$6,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.$4,
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.$5,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'giờ',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: colors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
