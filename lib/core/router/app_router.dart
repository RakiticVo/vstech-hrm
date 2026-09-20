import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/router/app_shell.dart';
import 'package:vstech_hrm/core/router/route_guards.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/features/approvals/presentation/screens/approvals_screen.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:vstech_hrm/features/attendance/presentation/screens/face_scan_screen.dart';
import 'package:vstech_hrm/features/auth/presentation/screens/login_screen.dart';
import 'package:vstech_hrm/features/auth/presentation/screens/splash_screen.dart';
import 'package:vstech_hrm/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:vstech_hrm/features/home/presentation/screens/home_screen.dart';
import 'package:vstech_hrm/features/payroll/presentation/screens/payroll_screen.dart';
import 'package:vstech_hrm/features/profile/presentation/screens/profile_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/requests_screen.dart';

/// Helper to bridge Stream to ChangeNotifier for GoRouter refresh.
class GoRouterRefreshStream extends ChangeNotifier {
  new(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

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
      GoRoute(
        path: AppRoutes.checkInCamera,
        builder: (context, state) {
          final type = state.extra is AttendanceType
              ? state.extra! as AttendanceType
              : AttendanceType.checkIn;
          return BlocProvider(
            create: (_) => sl<AttendanceBloc>(),
            child: FaceScanScreen(type: type),
          );
        },
      ),
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
            path: AppRoutes.requests,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RequestsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.calendar,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CalendarScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.payroll,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PayrollScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.approvals,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ApprovalsScreen(),
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
