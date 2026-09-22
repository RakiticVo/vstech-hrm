import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Navigation item model for bottom navigation bar.
class _NavItem {
  const new({
    required this.route,
    required this.label,
    required this.icon,
    this.badgeCount,
  });

  final String route;
  final String label;
  final IconData icon;
  final int? badgeCount;
}

/// Navigation Shell hosting the 5-tab bottom navigation bar for NV and QL.
class AppShell extends StatelessWidget {
  const new({
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

    final navItems = isManager ? _buildManagerNavItems() : _buildEmployeeNavItems();
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

    final iconWidget = Icon(
      item.icon,
      size: 22,
      color: iconColor,
      fill: isSelected ? 1.0 : 0.0,
      weight: isSelected ? 600 : 400,
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

  List<_NavItem> _buildEmployeeNavItems() {
    return const [
      _NavItem(
        route: AppRoutes.home,
        label: 'Trang chủ',
        icon: Symbols.home,
      ),
      _NavItem(
        route: AppRoutes.attendance,
        label: 'Chấm công',
        icon: Symbols.schedule,
      ),
      _NavItem(
        route: AppRoutes.requests,
        label: 'Yêu cầu',
        icon: Symbols.event_available,
        badgeCount: 1,
      ),
      _NavItem(
        route: AppRoutes.payroll,
        label: 'Lương',
        icon: Symbols.account_balance_wallet,
      ),
      _NavItem(
        route: AppRoutes.profile,
        label: 'Cá nhân',
        icon: Symbols.person,
      ),
    ];
  }

  List<_NavItem> _buildManagerNavItems() {
    return const [
      _NavItem(
        route: AppRoutes.home,
        label: 'Trang chủ',
        icon: Symbols.home,
      ),
      _NavItem(
        route: AppRoutes.attendance,
        label: 'Chấm công',
        icon: Symbols.schedule,
      ),
      _NavItem(
        route: AppRoutes.approvals,
        label: 'Duyệt',
        icon: Symbols.fact_check,
        badgeCount: 9,
      ),
      _NavItem(
        route: AppRoutes.payroll,
        label: 'Lương',
        icon: Symbols.account_balance_wallet,
      ),
      _NavItem(
        route: AppRoutes.profile,
        label: 'Cá nhân',
        icon: Symbols.person,
      ),
    ];
  }
}
