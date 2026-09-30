import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

class _CategoryItem {
  const _CategoryItem({
    required this.iconName,
    required this.title,
    required this.subtitle,
    required this.route,
    this.pendingBadge,
  });

  final String iconName;
  final String title;
  final String subtitle;
  final String route;
  final String? pendingBadge;
}

/// 5-category hub per HRM Employee App Phase 0 spec.
class RequestsCategoryTiles extends StatelessWidget {
  const RequestsCategoryTiles({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final categories = [
      _CategoryItem(
        iconName: AppIcons.leave,
        title: l10n.quickActionLeave,
        subtitle: 'Nghỉ phép năm, ốm, việc riêng...',
        route: AppRoutes.leaveManage,
        pendingBadge: '1 chờ',
      ),
      _CategoryItem(
        iconName: AppIcons.overtime,
        title: l10n.quickActionOvertime,
        subtitle: 'Đăng ký làm thêm giờ, ca đêm...',
        route: AppRoutes.overtimeManage,
        pendingBadge: '1 chờ',
      ),
      _CategoryItem(
        iconName: AppIcons.correction,
        title: l10n.quickActionCorrection,
        subtitle: 'Bổ sung giờ vào/ra, quên chấm...',
        route: AppRoutes.correctionManage,
      ),
      const _CategoryItem(
        iconName: AppIcons.dispute,
        title: 'Khiếu nại lương',
        subtitle: 'Thắc mắc tính công, khấu trừ...',
        route: AppRoutes.salaryDisputes,
      ),
      const _CategoryItem(
        iconName: AppIcons.shiftSwap,
        title: 'Đổi ca làm việc',
        subtitle: 'Đổi ca với đồng nghiệp cùng chi nhánh...',
        route: AppRoutes.shiftSwaps,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: SizedBox(
        height: 82,
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
                width: 210,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: colors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (item.pendingBadge != null) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: colors.accentAmber.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    item.pendingBadge!,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w800,
                                      color: colors.accentAmber,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: colors.textSecondary,
                            ),
                            maxLines: 1,
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
