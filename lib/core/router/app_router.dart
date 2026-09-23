import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/router/app_shell.dart';
import 'package:vstech_hrm/core/router/route_guards.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/screens/state_showcase_screen.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/features/announcements/domain/entities/announcement_entity.dart';
import 'package:vstech_hrm/features/announcements/presentation/cubit/announcements_cubit.dart';
import 'package:vstech_hrm/features/announcements/presentation/screens/announcement_detail_screen.dart';
import 'package:vstech_hrm/features/announcements/presentation/screens/announcements_screen.dart';
import 'package:vstech_hrm/features/approvals/presentation/screens/approvals_screen.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:vstech_hrm/features/attendance/presentation/cubit/offline_queue_cubit.dart';
import 'package:vstech_hrm/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:vstech_hrm/features/attendance/presentation/screens/face_scan_screen.dart';
import 'package:vstech_hrm/features/attendance/presentation/screens/offline_queue_screen.dart';
import 'package:vstech_hrm/features/auth/presentation/screens/login_screen.dart';
import 'package:vstech_hrm/features/auth/presentation/screens/splash_screen.dart';
import 'package:vstech_hrm/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:vstech_hrm/features/holidays/presentation/screens/holidays_screen.dart';
import 'package:vstech_hrm/features/home/presentation/screens/home_screen.dart';
import 'package:vstech_hrm/features/labor_profile/presentation/cubit/labor_profile_cubit.dart';
import 'package:vstech_hrm/features/labor_profile/presentation/screens/labor_profile_screen.dart';
import 'package:vstech_hrm/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:vstech_hrm/features/payroll/presentation/screens/payroll_screen.dart';
import 'package:vstech_hrm/features/payroll/presentation/screens/payslip_detail_screen.dart';
import 'package:vstech_hrm/features/profile/presentation/screens/profile_screen.dart';
import 'package:vstech_hrm/features/qr_auth/presentation/cubit/qr_scanner_cubit.dart';
import 'package:vstech_hrm/features/qr_auth/presentation/screens/qr_scanner_screen.dart';
import 'package:vstech_hrm/features/recruitment/presentation/screens/internal_recruitment_screen.dart';
import 'package:vstech_hrm/features/recruitment/presentation/screens/job_detail_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/attendance_correction_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/leave_request_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/overtime_request_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/requests_screen.dart';
import 'package:vstech_hrm/features/rewards/presentation/screens/rewards_screen.dart';
import 'package:vstech_hrm/features/schedule/presentation/screens/shift_schedule_screen.dart';
import 'package:vstech_hrm/features/services/presentation/screens/all_services_screen.dart';
import 'package:vstech_hrm/features/settings/presentation/screens/settings_screen.dart';

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

      // Standalone Feature Screens (Push Navigation with Back button)
      GoRoute(
        path: AppRoutes.services,
        builder: (context, state) => const AllServicesScreen(),
      ),
      GoRoute(
        path: AppRoutes.calendar,
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: AppRoutes.holidays,
        builder: (context, state) => const HolidaysScreen(),
      ),
      GoRoute(
        path: AppRoutes.leaveCreate,
        builder: (context, state) => const LeaveRequestScreen(),
      ),
      GoRoute(
        path: AppRoutes.overtimeCreate,
        builder: (context, state) => const OvertimeRequestScreen(),
      ),
      GoRoute(
        path: AppRoutes.attendanceCorrection,
        builder: (context, state) => const AttendanceCorrectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.payslipDetail,
        builder: (context, state) => const PayslipDetailScreen(),
      ),
      GoRoute(
        path: AppRoutes.rewards,
        builder: (context, state) => const RewardsScreen(),
      ),
      GoRoute(
        path: AppRoutes.jobRecruitment,
        builder: (context, state) => const InternalRecruitmentScreen(),
      ),
      GoRoute(
        path: AppRoutes.jobDetail,
        builder: (context, state) => const JobDetailScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.shiftSchedule,
        builder: (context, state) => const ShiftScheduleScreen(),
      ),
      GoRoute(
        path: AppRoutes.stateShowcase,
        builder: (context, state) => const StateShowcaseScreen(),
      ),

      // 4 Core MVP Features
      GoRoute(
        path: AppRoutes.announcements,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AnnouncementsCubit>(),
          child: const AnnouncementsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.announcementDetail,
        builder: (context, state) {
          final item = state.extra is AnnouncementEntity
              ? state.extra! as AnnouncementEntity
              : null;
          if (item == null) {
            return BlocProvider(
              create: (_) => sl<AnnouncementsCubit>(),
              child: const AnnouncementsScreen(),
            );
          }
          return BlocProvider(
            create: (_) => sl<AnnouncementsCubit>(),
            child: AnnouncementDetailScreen(announcement: item),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.laborProfile,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<LaborProfileCubit>(),
          child: const LaborProfileScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.offlineQueue,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<OfflineQueueCubit>(),
          child: const OfflineQueueScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.qrScanner,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<QrScannerCubit>(),
          child: const QrScannerScreen(),
        ),
      ),

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
