/// Central definition of all route paths in the application.
class AppRoutes {
  const new _();

  // Root & Auth
  static const String splash = '/';
  static const String login = '/login';

  // 5 Main Navigation Shell Tabs (Matching reference mockups)
  static const String home = '/home';
  static const String attendance = '/attendance';
  static const String requests = '/requests';
  static const String payroll = '/payroll';
  static const String profile = '/profile';

  // Feature Screens & Services
  static const String services = '/services';
  static const String calendar = '/calendar';
  static const String holidays = '/holidays';
  static const String shiftSchedule = '/schedule/shifts';
  static const String leaveCreate = '/requests/leave-create';
  static const String overtimeCreate = '/requests/overtime-create';
  static const String attendanceCorrection = '/requests/correction-create';
  static const String payslipDetail = '/payroll/payslip';
  static const String rewards = '/rewards';
  static const String jobRecruitment = '/recruitment';
  static const String jobDetail = '/recruitment/detail';
  static const String notifications = '/notifications';
  static const String approvals = '/approvals';
  static const String settings = '/settings';

  // UI States Showcase (Empty, Shimmer, Error, Success)
  static const String stateShowcase = '/states';

  // Sub-routes / Detail screens
  static const String checkInCamera = '/home/check-in';
}
