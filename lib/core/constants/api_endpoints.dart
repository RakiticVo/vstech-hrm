/// Canonical API endpoint constants matching OpenAPI 3.0.1 specification (docs/api/api-1.json).
class ApiEndpoints {
  const new _();

  // 1. Account & Authentication
  static const String login = '/api/Account';
  static const String accountProfile = '/api/Account';
  static const String accountBasic = '/api/Account/basic';
  static const String checkAuth = '/api/Account/check-auth';
  static const String refreshToken = '/api/Account/refresh-token';

  // 2. Enrollments (Attendance & Check-in/out)
  static const String attendanceCheckIn = '/api/Enrollments/Checkin';
  static const String attendanceCheckOut = '/api/Enrollments/Checkout';
  static const String attendanceToday = '/api/Enrollments/info';
  static const String enrollmentAttend = '/api/Enrollments/attend';
  static const String attendanceHistory = '/api/Enrollments/info';

  // 3. Leave Requests
  static const String leaveRequests = '/api/LeaveRequests';
  static const String leaveRequestsSelf = '/api/LeaveRequests/self';
  static String leaveRequestDetail(String id) => '/api/LeaveRequests/self/$id';
  static String leaveRequestDelete(String id) => '/api/LeaveRequests/self/$id';

  // 4. Overtime Requests
  static const String overtimeRequests = '/api/OvertimeRequests';
  static const String overtimeRequestsSelf = '/api/OvertimeRequests/self';
  static String overtimeRequestDelete(String id) => '/api/OvertimeRequests/self/$id';

  // 5. Timesheet Regularization & Sửa công
  static const String timesheetConfirmRequests = '/api/TimesheetConfirmRequests';
  static const String timesheetConfirmReasons = '/api/TimesheetConfirmRequests/reasons';
  static String timesheetConfirmInfo(int id) => '/api/TimesheetConfirmRequests/info/$id';
  static String timesheetConfirmAccept(int id) => '/api/TimesheetConfirmRequests/confirm/$id';
  static String timesheetConfirmReject(int id) => '/api/TimesheetConfirmRequests/reject/$id';

  // 6. Confirm Requests (Manager Approvals)
  static const String pendingApprovals = '/api/TimesheetConfirmRequests';
  static String leaveAccept(String id) => '/api/ConfirmRequests/leave/accept/$id';
  static String leaveDeny(String id) => '/api/ConfirmRequests/leave/deny/$id';
  static String businessAccept(String id) => '/api/ConfirmRequests/business/accept/$id';
  static String businessDeny(String id) => '/business/deny/$id';
  static String overtimeAccept(String id) => '/overtime/accept/$id';
  static String overtimeDeny(String id) => '/overtime/Deny/$id';

  // 7. Payroll & Payslips
  static const String payrollOverview = '/api/EmployeeSalaryPayrolls';
  static String payslipDetail(int id) => '/api/EmployeeSalaryPayrolls/detail/$id';
  static String payrollSummary(int id) => '/api/EmployeeSalaryPayrolls/summary/$id';

  // 8. Notifications & FCM
  static const String notifications = '/api/BaseNotifications';
  static String notificationRead(int id) => '/api/BaseNotifications/$id/read';
  static const String notificationsReadAll = '/api/BaseNotifications/read-all';
  static const String fcmSetToken = '/api/FCM/set-token';

  // 9. Holidays
  static const String holidays = '/api/Holidays';

  // Compatibility aliases
  static const String profile = accountProfile;
  static const String leaveBalance = '/api/LeaveRequests/self';
}

/// Face Authentication API endpoints (docs/api/face/api-1.json).
class FaceApiEndpoints {
  const new _();

  static const String health = '/health/';
  static const String checkReg = '/checkreg/';
  static const String register = '/register/';
  static const String update = '/update/';
  static const String delete = '/delete/';
  static const String verify = '/verify/';
  static const String verifyRealtime = '/verify-realtime/';
  static const String liveVerify = '/live_verify/';
}

