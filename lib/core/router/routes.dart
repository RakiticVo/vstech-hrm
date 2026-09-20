/// Central definition of all route paths in the application.
class AppRoutes {
  const new _();

  // Root & Auth
  static const String splash = '/';
  static const String login = '/login';

  // Employee & Manager Shared Navigation Shell Routes
  static const String home = '/home';
  static const String requests = '/requests';
  static const String calendar = '/calendar';
  static const String payroll = '/payroll';
  static const String profile = '/profile';

  // Manager specific route (Tab 3 for MSS)
  static const String approvals = '/approvals';

  // Sub-routes / Detail screens
  static const String checkInCamera = '/home/check-in';
  static const String leaveCreate = '/requests/create';
  static const String leaveDetail = '/requests/detail/:id';
  static const String payslipDetail = '/payroll/payslip/:month';
  static const String approvalDetail = '/approvals/detail/:id';
}
