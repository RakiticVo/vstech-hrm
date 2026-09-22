class ApiEndpoints {
  const new _();

  // Auth
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String deviceBind = '/auth/device-bind';

  // Attendance
  static const String attendanceToday = '/attendance/today';
  static const String attendanceCheckIn = '/attendance/check-in';
  static const String attendanceCheckOut = '/attendance/check-out';
  static const String attendanceHistory = '/attendance/history';
  static const String attendanceCalendar = '/attendance/calendar';
  static const String attendanceRegularization = '/attendance/regularization';

  // Leave & Overtime
  static const String leaveBalance = '/leave/balance';
  static const String leaveRequests = '/leave/requests';
  static const String overtimeRequests = '/overtime/requests';

  // Payroll
  static const String payrollOverview = '/payroll/overview';
  static const String payslipDetail = '/payroll/payslip';
  static const String payslipSign = '/payroll/payslip/sign';

  // Approvals (MSS)
  static const String pendingApprovals = '/approvals/pending';
  static const String approvalAction = '/approvals/action';

  // Notifications
  static const String notifications = '/notifications';

  // Profile
  static const String profile = '/profile';
}
