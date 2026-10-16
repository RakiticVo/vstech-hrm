import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

class _CategoryItem {
  const new({
    required this.iconName,
    required this.title,
    required this.subtitle,
    required this.route,
    this.pendingCount = 0,
  });

  final String iconName;
  final String title;
  final String subtitle;
  final String route;
  final int pendingCount;
}

/// Category hub displaying Leave & Overtime for Users, plus Correction for Managers.
class RequestsCategoryTiles extends StatelessWidget {
  const new({
    this.leavePendingCount = 0,
    this.otPendingCount = 0,
    this.correctionPendingCount = 0,
    super.key,
  });

  final int leavePendingCount;
  final int otPendingCount;
  final int correctionPendingCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final categories = [
      _CategoryItem(
        iconName: AppIcons.leave,
        title: l10n.quickActionLeave,
        subtitle: 'Nghỉ phép năm, ốm, việc riêng',
        route: AppRoutes.leaveManage,
        pendingCount: leavePendingCount,
      ),
      _CategoryItem(
        iconName: AppIcons.overtime,
        title: l10n.quickActionOvertime,
        subtitle: 'Đăng ký làm thêm giờ, ca đêm',
        route: AppRoutes.overtimeManage,
        pendingCount: otPendingCount,
      ),
      _CategoryItem(
        iconName: AppIcons.correction,
        title: l10n.requestTypeCorrection,
        subtitle: 'Giải trình quên chấm công, sai giờ',
        route: AppRoutes.correctionManage,
        pendingCount: correctionPendingCount,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: SizedBox(
        height: 88,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, _) => 10.gapW,
          itemBuilder: (ctx, index) {
            final item = categories[index];
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.push(item.route),
              child: Container(
                width: 228,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: colors.cardBackground,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: AppIcon(
                              item.iconName,
                              size: 22,
                              color: colors.primaryIndigo,
                            ),
                          ),
                        ),
                        if (item.pendingCount > 0)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: colors.accentAmber,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: colors.surface, width: 1.5),
                              ),
                              child: Text(
                                '${item.pendingCount}',
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1C1408),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: colors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.subtitle,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: colors.textSecondary,
                              height: 1.25,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    AppIcon(
                      AppIcons.chevronRight,
                      size: 15,
                      color: colors.textSecondary,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
