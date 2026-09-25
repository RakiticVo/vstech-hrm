import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/router/app_shell.dart';
import 'package:vstech_hrm/core/router/feature_routes.dart';
import 'package:vstech_hrm/core/router/go_router_refresh_stream.dart';
import 'package:vstech_hrm/core/router/route_guards.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/features/approvals/presentation/screens/approvals_screen.dart';
import 'package:vstech_hrm/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:vstech_hrm/features/auth/presentation/screens/login_screen.dart';
import 'package:vstech_hrm/features/auth/presentation/screens/splash_screen.dart';
import 'package:vstech_hrm/features/home/presentation/screens/home_screen.dart';
import 'package:vstech_hrm/features/payroll/presentation/screens/payroll_screen.dart';
import 'package:vstech_hrm/features/profile/presentation/screens/profile_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/requests_screen.dart';

/// Central application router configuration using declarative GoRouter.
class AppRouter {
  new({required this.authCubit});

  final AuthCubit authCubit;

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) => authRedirectGuard(context, state, authCubit.state),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Standalone feature routes
      ...getStandaloneFeatureRoutes(),

      // 5 Main Navigation Tabs in AppShell
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(
            location: state.uri.path,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.attendance,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AttendanceScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.requests,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RequestsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.approvals,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ApprovalsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.payroll,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PayrollScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}
