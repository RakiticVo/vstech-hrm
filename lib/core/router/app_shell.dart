import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Navigation item model for bottom navigation bar.
class _NavItem {
  const _NavItem({
    required this.route,
    required this.label,
    required this.iconName,
    this.badgeCount,
  });

  final String route;
  final String label;
  final String iconName;
  final int? badgeCount;
}

/// Navigation Shell hosting the 5-tab bottom navigation bar for NV and QL.
class AppShell extends StatelessWidget {
  const AppShell({
    required this.child,
    required this.location,
    super.key,
  });

  final Widget child;
  final String location;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authState = context.watch<AuthCubit>().state;
    final isManager = authState is Authenticated && authState.role.isManager;

    final navItems = isManager ? _buildManagerNavItems(context) : _buildEmployeeNavItems(context);
    final currentIndex = _calculateSelectedIndex(location, navItems);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            top: BorderSide(color: colors.border),
          ),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(navItems.length, (index) {
                final item = navItems[index];
                final isSelected = index == currentIndex;

                return Expanded(
                  child: InkWell(
                    onTap: () => context.go(item.route),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Top active indicator line 26x3px
                        Positioned(
                          top: 0,
                          child: Container(
                            width: 26,
                            height: 3,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors.primaryIndigo
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6, bottom: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildNavIcon(item, isSelected, colors),
                              const SizedBox(height: 3),
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? colors.primaryIndigo
                                      : colors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                            ),
                          ],
                        ),
                      ),
                    );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(_NavItem item, bool isSelected, AppColorsExtension colors) {
    final iconColor = isSelected ? colors.primaryIndigo : colors.textSecondary;

    final iconWidget = AppIcon(
      item.iconName,
      size: 24,
      color: iconColor,
      filled: isSelected,
    );

    if (item.badgeCount != null && item.badgeCount! > 0) {
      return Badge(
        label: Text(
          '${item.badgeCount}',
          style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        backgroundColor: colors.error,
        child: iconWidget,
      );
    }

    return iconWidget;
  }

  int _calculateSelectedIndex(String currentPath, List<_NavItem> items) {
    for (var i = 0; i < items.length; i++) {
      if (currentPath.startsWith(items[i].route)) {
        return i;
      }
    }
    return 0;
  }

  List<_NavItem> _buildEmployeeNavItems(BuildContext context) {
    final l10n = context.l10n;
    return [
      _NavItem(
        route: AppRoutes.home,
        label: l10n.home,
        iconName: AppIcons.home,
      ),
      _NavItem(
        route: AppRoutes.attendance,
        label: l10n.attendance,
        iconName: AppIcons.attendance,
      ),
      _NavItem(
        route: AppRoutes.requests,
        label: l10n.requests,
        iconName: AppIcons.requests,
        badgeCount: 1,
      ),
      _NavItem(
        route: AppRoutes.payroll,
        label: l10n.payroll,
        iconName: AppIcons.payroll,
      ),
      _NavItem(
        route: AppRoutes.profile,
        label: l10n.profile,
        iconName: AppIcons.profile,
      ),
    ];
  }

  List<_NavItem> _buildManagerNavItems(BuildContext context) {
    final l10n = context.l10n;
    return [
      _NavItem(
        route: AppRoutes.home,
        label: l10n.home,
        iconName: AppIcons.home,
      ),
      _NavItem(
        route: AppRoutes.attendance,
        label: l10n.attendance,
        iconName: AppIcons.attendance,
      ),
      _NavItem(
        route: AppRoutes.approvals,
        label: l10n.approvals,
        iconName: AppIcons.approvals,
        badgeCount: 9,
      ),
      _NavItem(
        route: AppRoutes.payroll,
        label: l10n.payroll,
        iconName: AppIcons.payroll,
      ),
      _NavItem(
        route: AppRoutes.profile,
        label: l10n.profile,
        iconName: AppIcons.profile,
      ),
    ];
  }
}
