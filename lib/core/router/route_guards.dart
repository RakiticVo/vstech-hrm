import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';

/// Evaluates navigation redirects based on authentication state and user role.
String? authRedirectGuard(BuildContext context, GoRouterState state, AuthState authState) {
  final currentPath = state.uri.path;
  final isGoingToLogin = currentPath == AppRoutes.login;
  final isGoingToSplash = currentPath == AppRoutes.splash;

  if (authState is AuthInitial || authState is AuthLoading) {
    return isGoingToSplash ? null : AppRoutes.splash;
  }

  if (authState is Unauthenticated) {
    return isGoingToLogin ? null : AppRoutes.login;
  }

  if (authState is Authenticated) {
    if (isGoingToLogin || isGoingToSplash) {
      return AppRoutes.home;
    }

    // Role-based route protection
    final isManagerRoute = currentPath.startsWith(AppRoutes.approvals);
    if (isManagerRoute && !authState.role.isManager) {
      return AppRoutes.home;
    }
  }

  return null;
}
