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
  static const String attendanceHistory = '/api/Account/enrollment';
  static const String accountEnrollment = '/api/Account/enrollment';
  static const String accountTimesheet = '/api/Account/timesheet';

  // 3. Leave Requests
  static const String leaveRequests = '/api/LeaveRequests';
  static const String leaveRequestsSelf = '/api/LeaveRequests/self';
  static const String leaveRequestsAdminMobile = '/api/LeaveRequests/admin-mobile';
  static const String validLeavePlan2 = '/api/LeavePlans/valid-leave-plan2';
  static String leaveRequestDetail(String id) => '/api/LeaveRequests/self/$id';
  static String leaveRequestDelete(String id) => '/api/LeaveRequests/self/$id';

  // 4. Overtime Requests
  static const String overtimeRequests = '/api/OvertimeRequests';
  static const String overtimeRequestsSelf = '/api/OvertimeRequests/self';
  static const String overtimeRequestsAdmin = '/api/OvertimeRequests/admin';
  static const String overtimeRequestsAdminMobile = '/api/OvertimeRequests/admin-mobile';
  static const String overtimeRequestsValidMaxHour = '/api/OvertimeRequests/valid-max-hour';
  static const String overtimeTypesFetch = '/api/OvertimeTypes/fetch';
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

  // 7. TimeSheets (Quản lý duyệt / xác nhận giờ công)
  static const String timesheetsMobile = '/api/TimeSheets/mobile';
  static const String timesheetsMobileEmployees = '/api/TimeSheets/mobile-employees';
  static String timesheetDetail(String id) => '/api/TimeSheets/$id';
  static String timesheetUpdate(String id) => '/api/TimeSheets/$id';
  static const String timesheetAdminConfirm = '/api/TimeSheets/admin-confirm-timesheet';
  static const String timesheetReject = '/api/TimeSheets/reject-timesheet';
  static const String timesheetOvertimeConfirm = '/api/TimeSheets/overtime-confirm-timesheet';
  static String timesheetConfirmHistory(String id) => '/api/TimeSheets/confirm-history/$id';

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

  // 10. Shift Schedules (Lịch ca làm việc)
  static const String myShiftSchedules = '/api/ShiftSchedules/me';
  static const String meShiftSchedules = '/api/ShiftSchedules/me';
  static const String shiftSchedules = '/api/ShiftSchedules';
  static const String shiftSchedulesPreview = '/api/ShiftSchedules/preview';

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
