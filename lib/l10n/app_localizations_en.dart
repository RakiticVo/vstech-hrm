// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'VSTech HRM';

  @override
  String get login => 'Log in';

  @override
  String get employeeCode => 'Employee Code';

  @override
  String get password => 'Password';

  @override
  String get checkIn => 'Clock In';

  @override
  String get checkOut => 'Clock Out';

  @override
  String get home => 'Home';

  @override
  String get attendance => 'Attendance';

  @override
  String get requests => 'Requests';

  @override
  String get approvals => 'Approvals';

  @override
  String get payroll => 'Payroll';

  @override
  String get profile => 'Profile';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get contactHr => 'Contact HR';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get viewAll => 'View All';

  @override
  String get back => 'Back';

  @override
  String get details => 'Details';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get loginSubtitle => 'Smart Human Resource Management';

  @override
  String get loginInstruction => 'Enter your employee ID and password';

  @override
  String get loginButton => 'LOG IN';

  @override
  String get biometricLogin => 'Sign in with Face ID / Biometrics';

  @override
  String get demoQuickLogin => 'Quick Login (Demo Mode)';

  @override
  String get demoEmployee => 'Employee';

  @override
  String get demoManager => 'Manager';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get greetingDefault => 'Hello';

  @override
  String get todayWorkedHours => 'TODAY\'S WORKED HOURS';

  @override
  String get todayShiftLabel => 'Today\'s Shift';

  @override
  String get clockInCta => 'CLOCK IN';

  @override
  String get clockOutCta => 'CLOCK OUT';

  @override
  String get timeIn => 'Time in';

  @override
  String get timeOut => 'Time out';

  @override
  String get lateMinutes => 'Late';

  @override
  String get overtimeLabel => 'Overtime';

  @override
  String get locationVerified => 'Location verified';

  @override
  String get managerApprovalPending => 'requests awaiting your approval';

  @override
  String get managerApprovalAction => 'Review now';

  @override
  String get metricWorkdays => 'Workdays';

  @override
  String get metricLeaveBalance => 'Leave Left';

  @override
  String get metricOvertime => 'Overtime';

  @override
  String get metricPending => 'Pending';

  @override
  String get quickActionLeave => 'Leave';

  @override
  String get quickActionOvertime => 'Overtime';

  @override
  String get quickActionCorrection => 'Correction';

  @override
  String get quickActionPayroll => 'Payslip';

  @override
  String get quickActionAll => 'All';

  @override
  String get salarySummaryTitle => 'Income Sep 2026';

  @override
  String get salaryNetPay => 'Net Salary';

  @override
  String get announcementsTitle => 'Internal Announcements';

  @override
  String get roleSwitcherTitle => 'Demo Role Switcher';

  @override
  String get shiftCheckInLabel => 'CHECK-IN';

  @override
  String get shiftCheckOutLabel => 'CHECK-OUT';

  @override
  String get shiftDoneCta => 'SHIFT DONE';

  @override
  String get shiftCheckOutCta => 'CHECK OUT';

  @override
  String get todayShiftDefault => 'Today\'s shift 08:00 — 17:00';

  @override
  String get metricLateEarly => 'LATE / EARLY';

  @override
  String get daysUnit => 'days';

  @override
  String get hoursUnit => 'h';

  @override
  String get monthlyNetSalaryLabel => 'THIS MONTH\'S NET SALARY';

  @override
  String get salaryMasked => '•••••••• ₫';

  @override
  String get salaryHintRevealed =>
      'Includes KPI bonus 2,500,000 ₫ · View details';

  @override
  String get salaryHintHidden => 'Tap the eye to reveal · View payslip';

  @override
  String get latestUpdatesTitle => 'Recent Updates';

  @override
  String get demoLeaveApprovedAnnouncement =>
      'Leave request 21–23/09 has been approved.';

  @override
  String get demoSalaryAnnouncement =>
      'September payslip is available. Net: 25,500,000 ₫.';

  @override
  String get twoHoursAgo => '2 hours ago';

  @override
  String get oneDayAgo => '1 day ago';

  @override
  String get managerPendingApprovalTitle => 'Awaiting your approval';

  @override
  String switchToRole(String role) {
    return 'Switch to $role';
  }

  @override
  String get shiftScheduleNav => 'Shifts';

  @override
  String get shiftScheduleTitle => 'Shift Schedule';

  @override
  String get workCalendarTooltip => 'Work Calendar';

  @override
  String attendanceMonthSummaryTitle(int month) {
    return 'Monthly Summary (Month $month)';
  }

  @override
  String get sendCorrectionRequest => 'Submit Attendance Correction';

  @override
  String get statusCheckedIn => 'Checked in';

  @override
  String get statusNotCheckedIn => 'Not checked in';

  @override
  String get shiftPromptArrive =>
      'Your shift starts at 08:00. Punch in upon arrival.';

  @override
  String get hcmOfficeVerified => 'HCM Office - Location verified';

  @override
  String get zeroMinutes => '0 min';

  @override
  String get offlineAttendanceModeLabel => 'Offline Punch (Vector ≥ 85%)';

  @override
  String get onlineAttendanceModeLabel => 'Online Mode';

  @override
  String get faceScanCheckInTitle => 'Clock-in Face Scan';

  @override
  String get faceScanCheckOutTitle => 'Clock-out Face Scan';

  @override
  String get faceScanCaptureCheckInCta => 'Capture & Clock In';

  @override
  String get faceScanCaptureCheckOutCta => 'Capture & Clock Out';

  @override
  String get offlineLocationLabel => 'HCM Office (Local GPS Check)';

  @override
  String offlineMatchSuccess(String pct) {
    return 'Face match $pct% (≥ 85%). Saved to offline queue.';
  }

  @override
  String get offlineMatchFailed =>
      'Face match under 85% threshold. Please adjust your face angle.';

  @override
  String offlineQueueCount(int count) {
    return '$count offline punch record(s)';
  }

  @override
  String get offlineQueueDesc => 'Safely saved locally, ready to sync.';

  @override
  String offlineSyncSuccess(int count) {
    return 'Successfully synced $count attendance records to server!';
  }

  @override
  String get syncButtonLabel => 'Sync';

  @override
  String get attendanceFailed => 'Attendance punch failed';

  @override
  String get viewMonthTooltip => 'View Entire Month';

  @override
  String get viewMonth => 'Month View';

  @override
  String weekStatsTitle(String week, String range) {
    return 'Week $week ($range)';
  }

  @override
  String weekStatsSummary(int shifts, int hours, int daysOff) {
    return '$shifts shifts · $hours work hours · $daysOff days off';
  }

  @override
  String shiftDetailHeader(String dayOfWeek, String date) {
    return 'Shift details for $dayOfWeek, $date';
  }

  @override
  String get shiftStatusActive => 'In Progress';

  @override
  String get shiftStatusCompleted => 'Completed';

  @override
  String get shiftStatusUpcoming => 'Upcoming';

  @override
  String get shiftStatusDayOff => 'Day Off';

  @override
  String get dayOffTitle => 'Today is your Day Off';

  @override
  String get dayOffDescription =>
      'No shifts scheduled for today. Rest, recharge, and get ready for the upcoming week!';

  @override
  String get registerOvertimeCta => 'Register Overtime (OT)';

  @override
  String get shiftLabelTime => 'Time:';

  @override
  String get shiftLabelBreak => 'Break:';

  @override
  String get shiftLabelLocation => 'Location:';

  @override
  String get shiftLabelManager => 'Shift Manager:';

  @override
  String get shiftLabelNotes => 'Notes:';

  @override
  String get shiftSwapButton => 'Swap Shift';

  @override
  String get shiftOvertimeButton => 'Request Overtime';

  @override
  String swapRequestSent(String colleague) {
    return 'Swap shift request sent to $colleague!';
  }

  @override
  String get swapShiftProposalTitle => 'Propose Shift Swap';

  @override
  String get selectColleagueLabel => 'Select colleague to swap with:';

  @override
  String get swapReasonLabel => 'Reason for swap:';

  @override
  String get swapReasonHint => 'Enter specific reason for shift swap...';

  @override
  String get submitSwapRequestButton => 'Submit Swap Request';

  @override
  String shiftCalendarMonthTitle(int month, int year) {
    return 'Shift Schedule Month $month/$year';
  }

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get daySun => 'Sun';

  @override
  String get shiftMorning => 'Morning';

  @override
  String get shiftAfternoon => 'Afternoon';

  @override
  String get shiftSplit => 'Split';

  @override
  String get shiftNight => 'Night';

  @override
  String get shiftOff => 'Off';

  @override
  String get tabAll => 'All';

  @override
  String get tabPending => 'Pending';

  @override
  String get tabApproved => 'Approved';

  @override
  String get tabRejected => 'Rejected';

  @override
  String get createNewRequestTitle => 'Create New Request';

  @override
  String get requestTypeLeave => 'Leave Request';

  @override
  String get requestTypeOvertime => 'Overtime Request';

  @override
  String get requestTypeCorrection => 'Correction Request';

  @override
  String get requestsCenterTitle => 'Requests Center';

  @override
  String get requestsCenterSubtitle =>
      'Leave · Overtime · Attendance Correction';

  @override
  String get monthlyRequestsTitle => 'Monthly Requests';

  @override
  String get selectMonthToView => 'Select month to view';

  @override
  String noRequestsInMonth(String month) {
    return 'No requests in $month';
  }

  @override
  String get roleIndicatorEmployee => 'View Manager role:';

  @override
  String get roleIndicatorSwitchToManager =>
      'Switch to Manager (Approvals tab)';

  @override
  String managerPendingApprovalsBanner(int count) {
    return 'You have $count requests awaiting approval';
  }

  @override
  String get openApprovalsLink => 'Open Approvals >';

  @override
  String get submitRequestButton => 'Submit Request';

  @override
  String get leaveRemainingStat => 'Leave Left';

  @override
  String get leaveUsedStat => 'Leave Used';

  @override
  String get newLeaveRequestSection => 'New Leave Request';

  @override
  String get leaveTypeLabel => 'Leave Type';

  @override
  String get timeRangeLabel => 'Time Period';

  @override
  String get totalLabel => 'Total';

  @override
  String get leaveHistorySection => 'Leave Request History';

  @override
  String noLeaveRequestsInMonth(String month) {
    return 'No leave requests in $month';
  }

  @override
  String get leaveRequestSubmittedTitle => 'Leave request submitted!';

  @override
  String leaveRequestSubmittedMsg(
    String type,
    String start,
    String end,
    String total,
  ) {
    return '$type request from $start to $end ($total) has been sent for Manager approval.';
  }

  @override
  String get thisMonthStat => 'This Month';

  @override
  String get paidStat => 'Paid';

  @override
  String get needsActionStat => 'Action Required';

  @override
  String get newOvertimeRequestSection => 'New Overtime Request';

  @override
  String get newCorrectionRequestSection => 'New Correction Request';

  @override
  String get overtimeHistorySection => 'Overtime History';

  @override
  String get correctionHistorySection => 'Correction History';

  @override
  String get approvalsCenterTitle => 'Approvals Center';

  @override
  String get awaitingYourAction => 'Awaiting Your Action';

  @override
  String get noPendingApprovals => 'No pending approval requests';

  @override
  String requestApprovedSuccess(String name) {
    return 'Approved request from $name';
  }

  @override
  String requestRejectedSuccess(String name) {
    return 'Rejected request from $name';
  }

  @override
  String get statusPending => 'Pending';

  @override
  String get actionReject => 'Reject';

  @override
  String get actionApprove => 'Approve';

  @override
  String get statusApproved => 'Approved';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get statusNeedsAction => 'Needs Info';

  @override
  String get stagePendingManager => 'Pending Manager';

  @override
  String get stagePendingHr => 'Pending HR';

  @override
  String get stagePendingDirector => 'Pending Director';

  @override
  String get stageCompleted => 'Completed';

  @override
  String get stageRejected => 'Rejected';

  @override
  String get leaveTypeAnnual => 'Annual Leave';

  @override
  String get leaveTypeSick => 'Sick Leave (Social Ins.)';

  @override
  String get leaveTypeUnpaid => 'Unpaid Leave';

  @override
  String get leaveTypeSpecial => 'Special Leave';

  @override
  String get leaveTypePersonal => 'Personal Leave';

  @override
  String get createLeaveRequestTitle => 'Create Leave Request';

  @override
  String get leaveTypeSelectorTitle => 'Leave Type';

  @override
  String get fromDateLabel => 'From Date';

  @override
  String get toDateLabel => 'To Date';

  @override
  String get reasonLabel => 'Reason';

  @override
  String get addAttachmentOptional => 'Add attachment (optional)';

  @override
  String attachmentSelected(String fileName, String size) {
    return 'Attachment selected: $fileName ($size)';
  }

  @override
  String get confirmSendLeaveRequest => 'Confirm Submit Request';

  @override
  String get overtimeModalTitle => 'Enter Overtime Info';

  @override
  String get overtimeDateLabel => 'Overtime Date';

  @override
  String get overtimeTimeRangeLabel => 'Overtime Time Period';

  @override
  String get startTimeLabel => 'Start';

  @override
  String get endTimeLabel => 'End';

  @override
  String overtimeEstimateCalc(int hours, String rate, String type) {
    return 'Total: $hours hours · Rate $rate ($type)';
  }

  @override
  String get overtimeDayTypeNormal => 'Normal day';

  @override
  String get overtimeReasonLabel => 'Overtime Reason';

  @override
  String get confirmSendOvertime => 'Confirm Submit';

  @override
  String get overtimeSubmittedTitle => 'Overtime request submitted!';

  @override
  String overtimeSubmittedMsg(String date, String time) {
    return 'Overtime request on $date ($time) has been sent for Manager approval.';
  }

  @override
  String noOvertimeInMonth(String month) {
    return 'No overtime data in $month';
  }

  @override
  String get createCorrectionTitle => 'Create Correction Request';

  @override
  String get correctionDateLabel => 'Correction Date';

  @override
  String get correctionTimeLabel => 'Corrected Time';

  @override
  String get correctionIssueLabel => 'Issue Encountered';

  @override
  String get issueMissingCheckout => 'Missing Check-out';

  @override
  String get issueMissingCheckin => 'Missing Check-in';

  @override
  String get issueWrongShift => 'Wrong Shift';

  @override
  String get issueScannerError => 'Scanner Error';

  @override
  String get explanationDetailLabel => 'Detailed Explanation';

  @override
  String get addProofOptional => 'Attach proof image (optional)';

  @override
  String proofSelected(String fileName, String size) {
    return 'Proof selected: $fileName ($size)';
  }

  @override
  String get confirmSendCorrection => 'Confirm Submit Request';

  @override
  String get correctionSubmittedTitle => 'Correction request submitted!';

  @override
  String correctionSubmittedMsg(String issue, String date, String time) {
    return 'Correction for $issue on $date ($time) has been sent to HR & Manager.';
  }

  @override
  String noCorrectionsInMonth(String month) {
    return 'No attendance corrections in $month';
  }

  @override
  String get correctionWarningBanner =>
      'Date 15/09/2026 missing check-out time. This day counts as incomplete attendance until correction is approved.';

  @override
  String get correctionIssueTitle => 'Issue';

  @override
  String get correctionChangeTo => 'Correct To';

  @override
  String get payrollTitle => 'Payroll & Income';

  @override
  String payrollPeriodSubtitle(String month, String year) {
    return 'Payroll Period Month $month/$year';
  }

  @override
  String get rewardsAction => 'Rewards';

  @override
  String get payrollNetSalaryTitle => 'NET TAKE-HOME SALARY';

  @override
  String payrollPayDate(String date) {
    return 'VND · Pay date $date';
  }

  @override
  String get viewPayslipButton => 'View Payslip';

  @override
  String get incomeAndDeductionBreakdown => 'Income & Deduction Breakdown';

  @override
  String get salaryHistoryTitle => 'Payroll History';

  @override
  String get payslipTitle => 'Payslip';

  @override
  String get downloadingPdfSnackbar => 'Downloading payslip PDF...';

  @override
  String salaryTransferredTo(String bank, String date) {
    return 'Transferred $bank · $date';
  }

  @override
  String get basicSalaryLabel => 'Base Salary';

  @override
  String get lunchAndTransportAllowance => 'Lunch & Travel Allowance';

  @override
  String kpiQuarterBonus(int quarter) {
    return 'Quarter $quarter KPI Bonus';
  }

  @override
  String get socialInsuranceDeduction => 'Insurance (10.5%)';

  @override
  String get personalIncomeTaxDeduction => 'Estimated PIT Deduction';

  @override
  String get unionFeeDeduction => 'Union Fee';

  @override
  String get incomeSectionTitle => 'Income';

  @override
  String get deductionSectionTitle => 'Deductions';

  @override
  String get netSalaryLabel => 'Net Salary';

  @override
  String get overtimePayLabel => 'Overtime 12h (x1.5)';

  @override
  String payslipNetSalaryMonth(String month, String year) {
    return 'Net Salary: Month $month $year';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get personalInfoSection => 'Personal Information';

  @override
  String get workInfoSection => 'Work Information';

  @override
  String get bankAccountSection => 'Bank Account';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get dateOfBirthLabel => 'Date of Birth';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get emailLabel => 'Email';

  @override
  String get addressLabel => 'Address';

  @override
  String get departmentLabel => 'Department';

  @override
  String get jobTitleLabel => 'Job Title';

  @override
  String get directManagerLabel => 'Direct Manager';

  @override
  String get joinDateLabel => 'Start Date';

  @override
  String get employmentStatusLabel => 'Status';

  @override
  String get officialStatus => 'Permanent';

  @override
  String get bankNameLabel => 'Bank';

  @override
  String get accountNumberLabel => 'Account Number';

  @override
  String get emergencyContactLink => 'Emergency Contact';

  @override
  String get documentsAndRecordsLink => 'Documents & Contracts';

  @override
  String get internalRecruitmentLink => 'Internal Recruitment';

  @override
  String get settingsLink => 'Settings';

  @override
  String get logoutButton => 'Log Out';

  @override
  String get logoutConfirmTitle => 'Confirm Logout';

  @override
  String get logoutConfirmMsg =>
      'Are you sure you want to log out of VSTech HRM?';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get roleBadgeManager => 'MGR';

  @override
  String get roleBadgeEmployee => 'EMP';

  @override
  String get readyToUploadAvatarSnackbar =>
      'Ready to upload new profile avatar';

  @override
  String get languageSettingTitle => 'LANGUAGE SETTINGS';

  @override
  String get chooseLanguageTitle => 'Choose Display Language';

  @override
  String get languageDesc =>
      'Interface and notifications will immediately switch to your selected language.';

  @override
  String get vietnameseLanguage => 'Tiếng Việt';

  @override
  String get vietnameseDesc => 'Application default language.';

  @override
  String get englishLanguage => 'English';

  @override
  String get englishDesc => 'English display for global workplace standards.';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get closeButton => 'Close';

  @override
  String get themeSettingTitle => 'APPEARANCE SETTINGS';

  @override
  String get chooseThemeTitle => 'Choose Theme Mode';

  @override
  String get themeDesc =>
      'Theme applies immediately and persists automatically across future sessions.';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeSystemDesc =>
      'Synchronizes automatically with device Light / Dark settings.';

  @override
  String get themeLight => 'Light Theme';

  @override
  String get themeLightDesc =>
      'Warm cream tone with signature Saigon tile pattern.';

  @override
  String get themeDark => 'Dark Theme';

  @override
  String get themeDarkDesc =>
      'Deep dark slate tone, easy on eyes during night shifts.';

  @override
  String get appLockSettingTitle => 'DATA PROTECTION';

  @override
  String get appLockTitle => 'App Lock & PIN Code';

  @override
  String get appLockDesc =>
      'Automatically lock app when leaving screen to protect salary and personnel data.';

  @override
  String get enableAppLock => 'Enable App Lock';

  @override
  String get autoLockAfter => 'AUTO-LOCK AFTER';

  @override
  String get lockImmediately => 'Immediately when leaving app';

  @override
  String get lockAfter1Min => 'After 1 minute';

  @override
  String get lockAfter5Mins => 'After 5 minutes';

  @override
  String get saveSettingsButton => 'Save Settings';

  @override
  String get appLockUpdatedSnackbar =>
      'App lock configuration updated successfully';

  @override
  String get biometricSecurityTitle => 'BIOMETRIC SECURITY';

  @override
  String get biometricAuthTitle => 'Fingerprint / Face Unlock';

  @override
  String get biometricDesc =>
      'Use device biometrics to unlock app quickly and secure payslip access.';

  @override
  String get enableBiometrics => 'Enable Biometrics';

  @override
  String get hardwareSupportLabel => 'Hardware Support:';

  @override
  String get hardwareAvailable => 'Available';

  @override
  String get hardwareNotSupported => 'Not Supported';

  @override
  String get biometricSensorLabel => 'Biometric Sensor:';

  @override
  String get sensorConfigured => 'Enrolled on Device';

  @override
  String get sensorNotConfigured => 'Not Enrolled';

  @override
  String get testBiometricNow => 'Test Biometric Sensor';

  @override
  String get deviceSecurityTitle => 'Device Security';

  @override
  String get linkedDeviceTitle => 'Bound Hardware Device';

  @override
  String get deviceSecurityDesc =>
      'Security policies strictly bind account to 1 trusted device for attendance and payslips.';

  @override
  String get officialDeviceRegistered => 'Official Device • Registered';

  @override
  String get physicalDeviceLabel => 'Physical Device';

  @override
  String get physicalDeviceValid => 'Valid (Physical)';

  @override
  String get physicalDeviceWarning => 'Warning (Simulator)';

  @override
  String get jailbreakLabel => 'Root / Jailbreak';

  @override
  String get jailbreakSafe => 'Secure (Unrooted)';

  @override
  String get jailbreakDetected => 'Tampering Detected!';

  @override
  String get mockGpsLabel => 'Mock GPS Location';

  @override
  String get mockGpsNotDetected => 'Not Detected';

  @override
  String get mockGpsDetected => 'Fake Location Detected!';

  @override
  String get developerModeLabel => 'Developer Mode';

  @override
  String get devModeOn => 'Enabled (Dev Mode)';

  @override
  String get devModeOff => 'Disabled';

  @override
  String get systemInfoTitle => 'SYSTEM INFORMATION';

  @override
  String get systemDesc =>
      'B2B SaaS Human Resource Management System • Employee & Manager Modules.';

  @override
  String get appVersionLabel => 'Application Version';

  @override
  String get runtimeEnvLabel => 'Runtime Environment';

  @override
  String get dataEngineLabel => 'Data Engine';

  @override
  String get uiFontLabel => 'UI Typography & Theme';

  @override
  String get checkUpdatesButton => 'Check for Updates';

  @override
  String get appUpToDateSnackbar =>
      'Application is running the latest version (v1.0.0)!';

  @override
  String get roleSwitchDemoTitle => 'ROLE SWITCHER (DEMO)';

  @override
  String get chooseRoleTitle => 'Choose Experience Role';

  @override
  String get roleSwitchDesc =>
      'Standalone demo mode switches interfaces and approval pipelines between Employee and Manager instantly.';

  @override
  String get roleEmployeeTitle => 'Employee (NV / ESS)';

  @override
  String get roleEmployeeDesc =>
      'Nguyen Van An • NV0142\nAttendance, submit leave requests, view payslips.';

  @override
  String get roleManagerTitle => 'Direct Manager (QL / MSS)';

  @override
  String get roleManagerDesc =>
      'Tran Thi Mai • NV0089\nPending review bar, first-line approvals for team requests.';

  @override
  String switchedToRoleSnackbar(String role) {
    return 'Switched role to: $role';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get pushNotificationsDesc =>
      'Receive approval and shift schedule alerts';

  @override
  String get emailReport => 'Email Reports';

  @override
  String get emailReportDesc =>
      'Receive monthly timesheet and payroll summary via email';

  @override
  String get punchReminder => 'Attendance Reminders';

  @override
  String get punchReminderDesc => 'Remind 15 minutes before shift start';

  @override
  String get systemPermissionsSection => 'System Permissions';

  @override
  String get manageDevicePermissions => 'Manage Device Permissions';

  @override
  String get permissionsSubtext =>
      'Camera, GPS Location, Files & Photos, Notifications';

  @override
  String get securityAndPrivacySection => 'Security & Privacy';

  @override
  String get biometricUnlock => 'Biometric Unlock';

  @override
  String get biometricUnlockDesc => 'Use Face ID or Fingerprint to unlock';

  @override
  String get autoLock => 'Auto Lock';

  @override
  String get autoLockDesc => 'Lock app immediately when switching apps';

  @override
  String get designAndSystemSection => 'Design & System';

  @override
  String get uiStateShowcase =>
      'Showcase 4 UI States (Empty, Shimmer, Error, Success)';

  @override
  String get uiStateShowcaseDesc =>
      'Inspect Empty, Loading Shimmer, Error & Success layouts';

  @override
  String get clearCache => 'Clear App Cache';

  @override
  String get cacheClearedSnackbar => 'Cache cleaned successfully';

  @override
  String get enableNotificationInSettings =>
      'Please enable notification permissions in system settings';

  @override
  String get allServicesTitle => 'All Services';

  @override
  String get categoryAttendanceTime => 'Time & Attendance';

  @override
  String get categoryRequests => 'Requests';

  @override
  String get categoryPayrollRewards => 'Payroll & Rewards';

  @override
  String get categoryCareerProfile => 'Career & Profile';

  @override
  String get categoryGovernance => 'Governance & Executive';

  @override
  String get serviceCheckInOut => 'Punch In / Out';

  @override
  String get serviceShiftSchedule => 'Shift Schedule';

  @override
  String get serviceMonthlyTimesheet => 'Monthly Timesheet';

  @override
  String get serviceHolidays => 'Public Holidays';

  @override
  String get serviceLeave => 'Leave Request';

  @override
  String get serviceOvertime => 'Overtime Request';

  @override
  String get serviceCorrection => 'Attendance Correction';

  @override
  String get serviceTrackRequests => 'Track Requests';

  @override
  String get serviceSalaryTable => 'Monthly Payroll';

  @override
  String get servicePayslip => 'Payslip';

  @override
  String get serviceRewards => 'Rewards & Recognition';

  @override
  String get serviceAllowance => 'Allowances';

  @override
  String get serviceInternalJobs => 'Internal Recruitment';

  @override
  String get serviceProfile => 'Personnel Profile';

  @override
  String get serviceSettings => 'Settings';

  @override
  String get serviceApprovals => 'Approvals';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get allNotificationsReadSnackbar => 'All notifications marked as read';

  @override
  String get notificationCatLeave => 'Leave';

  @override
  String get notificationCatSalary => 'Salary';

  @override
  String get notificationCatAttendance => 'Attendance';

  @override
  String get notificationCatReward => 'Rewards';

  @override
  String get notificationCatRecruitment => 'Jobs';

  @override
  String get notificationCatSystem => 'System';

  @override
  String get calendarScreenTitle => 'Calendar & Shifts';

  @override
  String get calendarSubtitle => 'Month 09/2026 · 22 Standard Workdays';

  @override
  String get monthSummaryTitle => 'September Summary';

  @override
  String get payableWorkdays => 'Payable Workdays';

  @override
  String get totalWorkHours => 'Total Work Hours';

  @override
  String get cumulativeOvertime => 'Cumulative Overtime';

  @override
  String get paidLeaveDays => 'Paid Leave Days';

  @override
  String get lateEarlyArrivals => 'Late / Early Arrivals';

  @override
  String get legendFullWork => 'Full Work';

  @override
  String get legendLeave => 'Leave';

  @override
  String get legendMissingTime => 'Missing Time';

  @override
  String get legendHoliday => 'Holiday';

  @override
  String get holidaysTitle => 'Holidays';

  @override
  String get year2026 => 'Year 2026';

  @override
  String get nationalHolidaysStat => 'Holidays';

  @override
  String get compensatoryLeaveStat => 'Compensatory';

  @override
  String get optionalHolidaysStat => 'Floating';

  @override
  String get rewardsTitle => 'Rewards & Recognition';

  @override
  String get rewardMonthHeader => 'September Reward';

  @override
  String get paidWithMonthSalary => 'VND · Paid with September salary';

  @override
  String get monthlyBonusStat => 'Monthly Bonus';

  @override
  String get kpiBonusStat => 'KPI Bonus';

  @override
  String get yearTotalBonusStat => '2026 Annual Total';

  @override
  String get internalRecognitionStat => 'Internal Recognition';

  @override
  String get whyReceivedBonus => 'Reason for Reward';

  @override
  String get bonusHistoryTitle => 'Bonus History';

  @override
  String get internalRecruitmentTitle => 'Internal Recruitment';

  @override
  String get searchJobPlaceholder => 'Search position, department...';

  @override
  String openPositionsCount(int count) {
    return '$count open positions for internal candidates';
  }

  @override
  String get tagNew => 'NEW';

  @override
  String get jobDetailTitle => 'Position Details';

  @override
  String get applyButton => 'Apply Now';

  @override
  String get jobDescriptionSection => 'Job Description';

  @override
  String get jobRequirementsSection => 'Requirements';

  @override
  String get jobBenefitsSection => 'Benefits';

  @override
  String get applySuccessTitle => 'Applied Successfully!';

  @override
  String get applySuccessMsg =>
      'Your internal profile has been forwarded to HR & Hiring Manager.';

  @override
  String get emptyDataMessage => 'No data available to display';

  @override
  String get errorOccurredTitle => 'An error occurred';

  @override
  String get errorOccurredMessage =>
      'Unable to load data right now. Please check your network connection.';

  @override
  String get successDialogTitle => 'Action successful!';

  @override
  String get successDialogMessage =>
      'Your request has been recorded and forwarded for processing.';

  @override
  String get doneButton => 'Done';

  @override
  String get filterAll => 'All';

  @override
  String get forgotPasswordShort => 'Forgot?';

  @override
  String get orDivider => 'or';

  @override
  String get faceIdLoginTitle => 'Face ID Login';

  @override
  String get faceIdLoginSubtitle => 'Smart and secure facial recognition';

  @override
  String get faceDetecting => 'Detecting face...';

  @override
  String get faceAligning => 'Aligning face angle...';

  @override
  String get faceMatching => 'Verifying biometric data...';

  @override
  String faceAuthSuccessGreeting(String name) {
    return 'Recognition successful! Welcome $name';
  }

  @override
  String get systemBiometricAuthButton => 'System Biometrics / Fingerprint';

  @override
  String get loginWithCredentialsButton => 'Log in with Employee ID & Password';

  @override
  String get biometricAuthReason =>
      'Biometric authentication to log in to vstech-hrm';

  @override
  String get punchSuccessTitle => 'Clock-in successful!';

  @override
  String get checkInRecorded => 'Clock-in recorded';

  @override
  String get checkOutRecorded => 'Clock-out recorded';

  @override
  String get timeLabel => 'Time';

  @override
  String get classificationLabel => 'Classification';

  @override
  String get locationLabel => 'Location';

  @override
  String get methodLabel => 'Method';

  @override
  String get methodFaceGps => 'Face Recognition + GPS';

  @override
  String get completeAndHomeCta => 'Done & Return Home';

  @override
  String get dailyLogSectionTitle => 'Daily Log';

  @override
  String get holidaysLink => 'Holidays';

  @override
  String get statusWorking => 'Working';

  @override
  String get statusMissingCheckOut => 'Missing Clock-out';

  @override
  String get statusFullWork => 'Full Workday';

  @override
  String get statusWeeklyOff => 'Day Off';

  @override
  String statusFullWorkOt(String hours) {
    return 'Full Work · OT ${hours}h';
  }

  @override
  String statusLateMinutes(String minutes) {
    return 'Late $minutes mins';
  }

  @override
  String get noShiftAssigned => 'No shift';

  @override
  String get monthlyWorkdaysUnit => 'workdays';

  @override
  String daysCountUnit(int count) {
    return '$count days';
  }

  @override
  String get faceScanSuccessTitle => 'Authentication successful!';

  @override
  String get faceScanSuccessSubtitle =>
      'Face recognition and location successfully recorded';

  @override
  String get faceScanningTitle => 'Scanning...';

  @override
  String get faceScanningSubtitle =>
      'Sending face capture and GPS coordinates to server';

  @override
  String get faceAlignPromptTitle => 'Align Face';

  @override
  String get faceAlignPromptSubtitle =>
      'Hold head straight and look directly into camera';

  @override
  String get emergencyContactInfo =>
      'Emergency Contact: 0908 221 470 (Family member)';

  @override
  String get documentsAndRecordsInfo => 'Employee Records & Labor Contracts';

  @override
  String get annualLeaveCardTitle => 'Annual Leave Balance';

  @override
  String leaveRatio(String used, String total) {
    return '$used / $total days';
  }

  @override
  String usedDaysCount(String count) {
    return 'Used $count';
  }

  @override
  String remainingDaysCount(String count) {
    return 'Remaining $count';
  }

  @override
  String get announcementsSubtitle =>
      'Official updates from HR & Executive Management';

  @override
  String get announcementScopeAll => 'All';

  @override
  String get announcementScopeCompany => 'Company-wide';

  @override
  String get announcementScopeOffice => 'Office';

  @override
  String get announcementScopeFactory => 'Factory & Team';

  @override
  String get announcementScopeDept => 'Department';

  @override
  String announcementTargetScope(String scope) {
    return 'Scope: $scope';
  }

  @override
  String announcementAuthor(String author) {
    return 'Author: $author';
  }

  @override
  String announcementPublishDate(String date) {
    return 'Published: $date';
  }

  @override
  String get announcementUnreadBadge => 'NEW';

  @override
  String get announcementMarkAllRead => 'Mark all as read';

  @override
  String get announcementEmpty => 'No announcements in this category';

  @override
  String get announcementDetailTitle => 'Announcement Detail';

  @override
  String get announcementReadConfirmed => 'Marked as read';

  @override
  String get laborProfileTitle => 'Labor Profile & Contracts';

  @override
  String get contractSectionTitle => 'Labor Contracts & Addendums';

  @override
  String get contractNumberLabel => 'Contract Number';

  @override
  String get contractTypeLabel => 'Contract Type';

  @override
  String get contractSigningDateLabel => 'Signing Date';

  @override
  String get contractEffectiveDateLabel => 'Effective Date';

  @override
  String get contractExpirationDateLabel => 'Expiration Date';

  @override
  String get contractStatusLabel => 'Contract Status';

  @override
  String get contractStatusActive => 'Active';

  @override
  String get salaryAndBenefitsSection => 'Agreed Salary & Allowances';

  @override
  String get agreedBaseSalary => 'Agreed Base Salary';

  @override
  String get responsibilityAllowance => 'Responsibility Allowance';

  @override
  String get mealAllowance => 'Meal Allowance';

  @override
  String get overtimeRateDescription =>
      'OT Rate: 150% (weekday), 200% (weekend), 300% (holiday)';

  @override
  String get socialInsuranceSection => 'Social & Health Insurance';

  @override
  String get socialInsuranceNumber => 'Social Insurance Code';

  @override
  String get hospitalRegistered => 'Primary Registered Clinic/Hospital';

  @override
  String get insuranceSalaryLevel => 'Insurance Contribution Base';

  @override
  String get insuranceStatus => 'Insurance Book Status';

  @override
  String get insuranceStatusActive => 'Fully Contributing';

  @override
  String get contractAttachmentsSection => 'Attachments & Contract Scans';

  @override
  String get downloadAttachmentButton => 'Download';

  @override
  String get previewAttachmentButton => 'Preview';

  @override
  String get laborProfileHrNotice =>
      'Contract and labor terms are managed by HR. Employees cannot edit this data on mobile. Please contact HR for inquiries.';

  @override
  String get offlineQueueTitle => 'Offline Attendance Queue';

  @override
  String get offlineQueueSubtitle =>
      'Locally saved punches pending server synchronization';

  @override
  String get statusRecorded => 'Recorded';

  @override
  String get statusPendingSync => 'Pending Sync';

  @override
  String get statusSyncing => 'Synchronizing...';

  @override
  String get statusSynced => 'Synchronized';

  @override
  String get statusSyncFailed => 'Sync Failed';

  @override
  String get syncAllButton => 'Sync All';

  @override
  String get syncRetryButton => 'Retry';

  @override
  String persistentQueueWarning(int count) {
    return 'WARNING: $count offline attendance punches are still pending synchronization!';
  }

  @override
  String get factoryRemindersTitle => 'Factory Shift Reminders';

  @override
  String get factoryRemindersSubtitle =>
      'Alerts for shift starts and lunch breaks (workers cannot carry phones inside factory)';

  @override
  String get reminderMorningShift => 'Morning Shift In (07:45)';

  @override
  String get reminderLunchBreak => 'Lunch Break (11:45)';

  @override
  String get reminderAfternoonShift => 'Afternoon Shift In (12:45)';

  @override
  String get reminderShiftEnd => 'Shift End Out (17:00)';

  @override
  String get reminderSavedSuccess =>
      'Factory shift reminders saved successfully!';

  @override
  String geofenceDistanceLabel(int meters) {
    return 'Distance: ${meters}m from factory center';
  }

  @override
  String get geofenceWithinRange => 'Within valid geofence (≤ 50m)';

  @override
  String get geofenceOutOfRange => 'Outside factory geofence (> 50m)';

  @override
  String get checkInGpsSuccess => 'GPS Check-in recorded successfully!';

  @override
  String get checkOutGpsSuccess => 'GPS Check-out recorded successfully!';

  @override
  String get qrScannerTitle => 'Scan QR to Login';

  @override
  String get qrScannerSubtitle =>
      'Point camera at the QR code on the Web Portal';

  @override
  String get qrTorchToggle => 'Toggle Torch';

  @override
  String get qrSamplePayloadsButton => 'Demo QR Payloads';

  @override
  String get qrConfirmTitle => 'Confirm Web Login';

  @override
  String get qrConfirmPrompt =>
      'Are you attempting to log in to VSTech Web Portal?';

  @override
  String get qrBrowserLabel => 'Browser';

  @override
  String get qrDeviceLabel => 'Device / Workstation';

  @override
  String get qrLocationLabel => 'Login Location';

  @override
  String get qrRequestTimeLabel => 'Request Time';

  @override
  String get qrIpAddressLabel => 'IP Address';

  @override
  String get qrApproveButton => 'Approve Login';

  @override
  String get qrRejectButton => 'Reject';

  @override
  String get qrBiometricPromptReason =>
      'Biometric authentication required to approve web login';

  @override
  String get qrLoginApprovedSuccess =>
      'Login approved! Web workstation session activated.';

  @override
  String get qrLoginRejectedMsg => 'You rejected this login request.';

  @override
  String get qrExpiredWarning =>
      'This QR code has expired. Please refresh the web page.';

  @override
  String get qrInvalidWarning => 'Invalid QR code. Not recognized by VSTech.';

  @override
  String get qrUsedWarning => 'This QR code has already been used.';

  @override
  String get qrCancelledWarning =>
      'This login request has been cancelled by the workstation.';

  @override
  String get execDashboardTitle => 'Executive Dashboard';

  @override
  String get execRoleTag => 'CHIEF EXECUTIVE OFFICER';

  @override
  String get execGreeting => 'Welcome, Mr. Le Hoang';

  @override
  String get execWaitingBadge => 'PENDING FINAL APPROVAL';

  @override
  String get execWaitingSub => 'Requires Director sign-off';

  @override
  String get execOldestWaiting => 'Oldest request: 18h ago';

  @override
  String get execCompanyNow => 'ENTERPRISE REAL-TIME STATUS';

  @override
  String get execHeadcount => 'Total Headcount';

  @override
  String get execAttendanceRate => 'Attendance Rate';

  @override
  String get execMonthlyPayroll => 'Monthly Payroll';

  @override
  String get execOvertimeHours => 'Monthly OT Hours';

  @override
  String get execTurnoverRate => 'Turnover Rate';

  @override
  String get execNeedAttention => 'Risk & Compliance Alerts';

  @override
  String get execSeeAllAlerts => 'View All Alerts';

  @override
  String get execAttendanceByDept => 'Attendance by Workshop & Division';

  @override
  String get finalApprovalTitle => 'Final Approval';

  @override
  String get finalApprovalCaption =>
      'Highest authorization tier · Closes the pipeline';

  @override
  String get finalApprovalDelegateBtn => 'Delegation';

  @override
  String get finalApprovalBatchHint =>
      'Quick-approve requests verified by HR & Finance';

  @override
  String get finalApprovalApproveAll => 'Approve All';

  @override
  String get finalApprovalFinancialImpact => 'FINANCIAL IMPACT';

  @override
  String get finalApprovalBudget => 'CONTINGENCY BUDGET';

  @override
  String get finalApprovalApproveBtn => 'Final Approve';

  @override
  String get finalApprovalRejectBtn => 'Reject';

  @override
  String get finalApprovalSuccess =>
      'Final approval recorded. HR will execute.';

  @override
  String get finalApprovalRejected => 'Request has been rejected.';

  @override
  String get riskTitle => 'Risk & Compliance Alerts';

  @override
  String get riskCaption =>
      'Three-tier compliance alerts · Assign to HR directly';

  @override
  String get riskTierCritical => 'Critical';

  @override
  String get riskTierHigh => 'High Risk';

  @override
  String get riskTierMedium => 'Medium';

  @override
  String get riskAssignHr => 'Assign to HR';

  @override
  String get riskAssignedSuccess => 'Task assigned to HR team successfully!';

  @override
  String get delTitle => 'Delegation Center';

  @override
  String get delCaption =>
      'Transfer approval authority during leave or business trips';

  @override
  String get delSelectPerson => 'Authorized Delegate';

  @override
  String get delPeriod => 'Delegation Period';

  @override
  String get delFromDate => 'From Date';

  @override
  String get delToDate => 'To Date';

  @override
  String get delTotalDays => 'Total';

  @override
  String get delScope => 'Authority Scope';

  @override
  String get delAllScope => 'All Permissions';

  @override
  String get delPartialScope => 'Selected Request Types';

  @override
  String get delLimit => 'Approval Financial Limit';

  @override
  String get delLimitHint =>
      'Requests exceeding this cap will still be routed to you when online';

  @override
  String get delUnlimited => 'Unlimited';

  @override
  String get delSubmit => 'Confirm & Activate Delegation';

  @override
  String get delActiveList => 'Active Delegations';

  @override
  String get delRevoke => 'Revoke Delegation';

  @override
  String get delRevokeSuccess => 'Delegation revoked successfully!';

  @override
  String get delCreateSuccess => 'Delegation established successfully!';

  @override
  String get delRunning => 'Running';

  @override
  String get requestTypeOnDuty => 'On Duty';

  @override
  String get requestTypeBusinessTrip => 'Business Trip';

  @override
  String get requestTypeShiftSwap => 'Shift Swap';

  @override
  String get onDutyTitle => 'Apply On Duty';

  @override
  String get onDutySubtitle =>
      'Short off-site errand or client visit during shift';

  @override
  String get onDutyFromTime => 'From Time';

  @override
  String get onDutyToTime => 'To Time';

  @override
  String get onDutyLocation => 'Destination / Location';

  @override
  String get onDutyDescription => 'Work Description';

  @override
  String get onDutyShiftConstraintWarning =>
      'On duty hours must fall within your scheduled shift';

  @override
  String get onDutySubmitSuccess => 'On Duty request submitted successfully!';

  @override
  String get businessTripTitle => 'Apply Business Trip';

  @override
  String get businessTripSubtitle =>
      'Multi-day domestic or overseas business trip';

  @override
  String get businessTripDestination => 'Destination';

  @override
  String get businessTripColleagues => 'Accompanying Colleagues';

  @override
  String get businessTripPurpose => 'Trip Purpose';

  @override
  String get businessTripPlan => 'Schedule / Plan';

  @override
  String get businessTripSubmitSuccess =>
      'Business Trip request submitted successfully!';

  @override
  String get offSiteTimesheetLabel => 'Off-site';

  @override
  String get offSiteCreditDesc => 'Credited as full worked time';

  @override
  String get leaveBalanceBreakdownTitle => 'Leave Balance Breakdown';

  @override
  String get leaveTypeCompOff => 'Comp-off (from Overtime)';

  @override
  String get leaveTypeMaternity => 'Maternity Leave';

  @override
  String get leaveTypePaidPersonal => 'Paid Personal Leave';

  @override
  String get leaveBalanceEntitlement => 'Entitled';

  @override
  String get leaveBalanceUsed => 'Used';

  @override
  String get leaveBalancePending => 'Pending';

  @override
  String get leaveBalanceAvailable => 'Available';

  @override
  String get leaveHalfDayMorning => 'First Half (Morning)';

  @override
  String get leaveHalfDayAfternoon => 'Second Half (Afternoon)';

  @override
  String get leaveHandoverPerson => 'Handover Colleague';

  @override
  String get leaveAttachment => 'Supporting Document / Certificate';

  @override
  String leaveExceedBalanceWarning(String days) {
    return 'Requested days exceed available balance ($days days)!';
  }

  @override
  String get leaveExcludeWeekendHint =>
      'Weekends and public holidays are automatically excluded';

  @override
  String get leaveSaveDraftBtn => 'Save Draft';

  @override
  String get leaveDraftSaved => 'Draft saved successfully!';

  @override
  String get otRateWeekday => 'Weekday (150%)';

  @override
  String get otRateWeekend => 'Weekly Off (200%)';

  @override
  String get otRateHoliday => 'Holiday (300%)';

  @override
  String get otCompensationType => 'Compensation Type';

  @override
  String get otCompensationPay => 'Paid Overtime';

  @override
  String get otCompensationCompOff => 'Convert to Comp-off';

  @override
  String otMonthlyCapWarning(String current) {
    return 'Notice: You have accumulated ${current}h/40h monthly OT cap';
  }

  @override
  String get otMonthlyCapExceeded =>
      'Cannot submit: Total OT exceeds 40h/mo per Labour Code 2019!';

  @override
  String otMonthlyApprovedHeader(String hours) {
    return 'Total approved OT this month: ${hours}h';
  }

  @override
  String get extraHoursBalanceTitle => 'Extra Hours & Comp-off';

  @override
  String get extraHoursMonth => 'Month OT Hours';

  @override
  String get extraHoursQuarter => 'Quarter OT Hours';

  @override
  String get extraHoursPayable => 'Payable Hours';

  @override
  String get extraHoursConvertedCompOff => 'Converted to Comp-off';

  @override
  String get compOffConversionRule => 'Conversion: 8 OT hours = 1 comp-off day';

  @override
  String get shiftSwapEligibilityCheck => 'Shift Swap Eligibility Check';

  @override
  String shiftSwapBranchMismatch(String branch) {
    return 'Colleague is at a different branch ($branch)';
  }

  @override
  String get shiftSwapGradeMismatch => 'Job grade is not equivalent';

  @override
  String get shiftSwapOnLeaveConflict => 'Colleague is on leave on this date';

  @override
  String get shiftSwapSameShiftConflict =>
      'Both are currently on the same shift';

  @override
  String get shiftSwapRestConflict =>
      'Rest between shifts < 12 hours (Labour Code 2019 Art 109)';

  @override
  String get shiftSwapOvertimeExceed =>
      'Normal weekly hours would exceed 48 hours';

  @override
  String get shiftSwapConflictAlert => 'Swap Conflict Detected';

  @override
  String get shiftSwapApprovedTag => 'Swapped';

  @override
  String get shiftMonthUnpublished =>
      'Next month\'s schedule will be published on the 25th';

  @override
  String get shiftNetworkRetry => 'Retry Connection';

  @override
  String get registeredDeviceTitle => 'Registered Device';

  @override
  String get registeredDeviceSub =>
      'Attendance is permitted only on your registered device';

  @override
  String get deviceModelLabel => 'Device Model';

  @override
  String get deviceIdLabel => 'Device Identifier (UUID)';

  @override
  String get deviceRegisteredDate => 'Registration Date';

  @override
  String get deviceCheckRegistered => 'Valid Registered Device';

  @override
  String get deviceCheckNotRooted => 'No Root / Jailbreak Detected';

  @override
  String get deviceCheckNoMockGps => 'No Mock GPS Detected';

  @override
  String get deviceCheckIntegrity => 'App Package Integrity Verified';

  @override
  String get deviceBlockRootTitle => 'Device is Rooted / Jailbroken';

  @override
  String get deviceBlockRootMsg =>
      'For security reasons, check-in is blocked on modified OS devices. Please contact HR.';

  @override
  String get deviceBlockMockGpsTitle => 'Mock Location Detected';

  @override
  String get deviceBlockMockGpsMsg =>
      'Mock location provider detected. Please disable location spoofing apps and tap \'Re-check\'.';

  @override
  String get deviceRecheckBtn => 'Re-check';

  @override
  String get deviceDemoTogglesTitle => 'Security Simulation (Demo Sandbox)';

  @override
  String get deviceSimulateMockGps => 'Simulate Mock GPS Detection';

  @override
  String get deviceSimulateRoot => 'Simulate Rooted Device';

  @override
  String get punchResultOnTime => 'On Time';

  @override
  String get punchResultLate => 'Late';

  @override
  String get punchResultEarly => 'Early Leave';

  @override
  String get punchLateReasonPrompt => 'Late / Early explanation';

  @override
  String get faceThumbnailLabel => 'AI Face Verification Snapshot';

  @override
  String get approvalTypeFilterAll => 'All';

  @override
  String get approvalTypeFilterLeave => 'Leave';

  @override
  String get approvalTypeFilterOT => 'Overtime';

  @override
  String get approvalTypeFilterCorrection => 'Correction';

  @override
  String get approvalTypeFilterSwap => 'Shift Swap';

  @override
  String get approvalTypeFilterOffSite => 'Off-site';

  @override
  String get approvalAttendanceSnippet => 'Attendance on relevant date';

  @override
  String get approvalSwapBothSchedules => 'Both employees\' schedules';

  @override
  String get approvalInternalNoteLabel => 'Internal Note (Manager only)';

  @override
  String get approvalMandatoryRejectReason =>
      'Please provide a rejection reason (mandatory)';

  @override
  String get legendLateEarly => 'Late / Early Leave';

  @override
  String get dateLabel => 'Date';

  @override
  String get fillRequiredField => 'Please fill in this required field';

  @override
  String get submitButton => 'Submit Request';

  @override
  String annualLeaveRemaining(String days) {
    return '$days days remaining';
  }

  @override
  String availableDays(String days) {
    return '$days days available';
  }

  @override
  String get attendanceTitle => 'Attendance';

  @override
  String get loadingState => 'Loading data...';

  @override
  String get errorStateTitle => 'Unable to load data';

  @override
  String get networkError => 'Network connection error, please retry';

  @override
  String get currentMonthSchedule => 'Current month schedule';

  @override
  String get deviceGpsRecheckedValid => 'Rechecking GPS coordinates... Valid!';

  @override
  String get deviceContactHrSent => 'Support request sent to HR.';

  @override
  String get deviceContactHrBtn => 'Contact HR Department';

  @override
  String get deviceTestBlockCta => 'Test Block Check-in (Demo)';

  @override
  String get deviceCheckSafetyBtn => 'Check Device Safety';

  @override
  String get requestDetailTitle => 'Request Detail';

  @override
  String get requestCodeLabel => 'Request Code';

  @override
  String get requesterLabel => 'Requester';

  @override
  String get cancelRequestBtn => 'Cancel Request';

  @override
  String get cancelRequestConfirm =>
      'Are you sure you want to cancel this request?';

  @override
  String get requestCancelledSuccess =>
      'Request has been cancelled successfully';

  @override
  String get internalNoteHint =>
      'Enter internal note (visible to approvers only)...';

  @override
  String get approveRequestConfirm => 'Confirm approval of this request?';

  @override
  String get rejectRequestConfirm => 'Confirm rejection of this request?';

  @override
  String get approvalTimelineTitle => 'Approval Timeline (4 Tiers)';

  @override
  String get submittedFieldsTitle => 'Submitted Details';

  @override
  String get attachedFilesTitle => 'Attachments & Proof';

  @override
  String get shiftComparisonTitle => 'Both Employees\' Shift Schedules';

  @override
  String get attendanceLogComparisonTitle => 'Actual Card Swipe Log Comparison';

  @override
  String get disputeComparisonTitle => 'Disputed Line Item Comparison';

  @override
  String get disputedAmountDiff => 'Discrepancy Difference';

  @override
  String get leaveManageTitle => 'Leave Management';

  @override
  String get annualLeaveHeroTitle => 'Annual Leave Balance 2026';

  @override
  String get leaveStatusFilterAll => 'All';

  @override
  String get leaveStatusFilterPending => 'Pending';

  @override
  String get leaveStatusFilterApproved => 'Approved';

  @override
  String get leaveStatusFilterRejected => 'Rejected';

  @override
  String get createLeaveBtn => 'New Leave Request';

  @override
  String get overtimeManageTitle => 'Overtime Management';

  @override
  String get totalOvertimeHours => 'Total Overtime Hours';

  @override
  String get rateNormal150 => 'Regular 150%';

  @override
  String get rateWeekend200 => 'Weekend 200%';

  @override
  String get rateHoliday300 => 'Holiday 300%';

  @override
  String get createOvertimeBtn => 'Request Overtime';

  @override
  String get correctionManageTitle => 'Timesheet Correction Management';

  @override
  String get correctionQuotaTitle => 'Monthly Correction Quota';

  @override
  String correctionQuotaUsage(String used, String total) {
    return 'Used $used/$total times';
  }

  @override
  String get missingPunchesSectionTitle =>
      'Missing Punches Requiring Attention';

  @override
  String get fixPunchBtn => 'Fix Punch Now';

  @override
  String get noMissingPunches => 'No missing punches recorded';

  @override
  String get shiftSwapsManageTitle => 'Shift Swaps Management';

  @override
  String get swapsSentTab => 'Sent Requests';

  @override
  String get swapsReceivedTab => 'Received Requests';

  @override
  String get colleagueLabel => 'Colleague';

  @override
  String get swapStatusPending => 'Pending';

  @override
  String get swapStatusApproved => 'Swapped';

  @override
  String get swapStatusRejected => 'Rejected';

  @override
  String get requestSentTitle => 'Request Sent';

  @override
  String get requestSentSuccess =>
      'Your request has been submitted successfully!';

  @override
  String requestAssignedTo(String name) {
    return 'Assigned to: $name';
  }

  @override
  String get backToListBtn => 'Back to List';

  @override
  String get viewRequestDetailBtn => 'View Request Detail';

  @override
  String get payslipLockTitle => 'Security Verification';

  @override
  String get payslipLockSubtitle =>
      'Enter 6-digit PIN or use biometrics to view payslip';

  @override
  String payslipLockWrongPin(String remaining) {
    return 'Incorrect PIN. $remaining attempts remaining';
  }

  @override
  String get payslipLockLocked =>
      'Temporarily locked for 30 seconds due to too many failed attempts';

  @override
  String get payslipLockBiometricPrompt => 'Authenticate to unlock payslip';

  @override
  String get payslipLockForgotPin => 'Forgot PIN?';

  @override
  String get useBiometricsBtn => 'Use Biometrics';

  @override
  String get signPayslipBtn => 'Sign Electronic Payslip';

  @override
  String get signPadTitle => 'Electronic Signature';

  @override
  String get signPadSubtitle => 'Please sign your name in the box below';

  @override
  String get signPadClear => 'Clear Signature';

  @override
  String get signPadConfirm => 'Confirm Signature';

  @override
  String get signPadDisclaimer =>
      'I confirm that I have verified all income, deductions and work hours in accordance with the Labor Code.';

  @override
  String get signPadEmptyAlert => 'Please sign before confirming';

  @override
  String get payslipSignedBadge => 'Electronically Signed';

  @override
  String payslipSignedAt(String time) {
    return 'Signed at: $time';
  }

  @override
  String payslipSignedHash(String hash) {
    return 'Verification hash: $hash';
  }

  @override
  String payslipSignedSigner(String name) {
    return 'Signer: $name';
  }

  @override
  String get disputePayslipBtn => 'Dispute Payslip';

  @override
  String get disputeLineBtn => 'Dispute this item';

  @override
  String get disputeManageTitle => 'Salary Disputes Management';

  @override
  String get disputeNewTitle => 'Create Salary Dispute';

  @override
  String get disputeMonthLabel => 'Dispute Period';

  @override
  String get disputeItemLabel => 'Disputed Item';

  @override
  String get disputeCurrentAmountLabel => 'Payslip Amount (₫)';

  @override
  String get disputeExpectedAmountLabel => 'Expected Amount (₫)';

  @override
  String get disputeDifferenceLabel => 'Proposed Difference';

  @override
  String get disputeReasonLabel => 'Detailed Explanation';

  @override
  String get disputeReasonHint => 'Describe discrepancy cause, date, shift...';

  @override
  String get disputeAttachmentLabel => 'Evidence Attachments';

  @override
  String get submitDisputeBtn => 'Submit Dispute';

  @override
  String get disputeCreatedSuccess => 'Salary dispute submitted successfully';

  @override
  String get noDisputesFound => 'No salary disputes found';

  @override
  String get disputeStatusPending => 'Under Review';

  @override
  String get disputeStatusApproved => 'Approved for Adjustment';

  @override
  String get disputeStatusRejected => 'Dispute Declined';

  @override
  String get rewardsTabBonus => 'Bonus';

  @override
  String get rewardsTabCommission => 'Commission';

  @override
  String get rewardsTabTargets => 'Targets';

  @override
  String commissionTotalTitle(String month) {
    return 'Total Commission $month';
  }

  @override
  String get commissionFilterDay => 'Day';

  @override
  String get commissionFilterWeek => 'Week';

  @override
  String get commissionFilterMonth => 'Month';

  @override
  String get commissionSourceDirect => 'Direct Sales';

  @override
  String get commissionSourceTeam => 'Team Volume';

  @override
  String get commissionSourceRenewal => 'Contract Renewal';

  @override
  String commissionContractsCount(int count) {
    return '$count transactions';
  }

  @override
  String get targetPersonalTitle => 'Personal Monthly Target';

  @override
  String get targetTeamTitle => 'Branch Team Target';

  @override
  String get targetTiersTitle => 'Milestone Bonus Tiers';

  @override
  String get targetTierAchieved => 'Tier Achieved';

  @override
  String targetTierRemaining(String remaining) {
    return 'Remaining $remaining';
  }

  @override
  String get targetTierNext => 'Next Target';

  @override
  String get referCandidateBtn => 'Refer Candidate';

  @override
  String get referralFormTitle => 'Refer a Candidate';

  @override
  String get candidateNameLabel => 'Candidate Full Name';

  @override
  String get candidatePhoneLabel => 'Phone Number';

  @override
  String get candidateEmailLabel => 'Email Address';

  @override
  String get candidatePositionLabel => 'Position';

  @override
  String get candidateBranchLabel => 'Desired Branch';

  @override
  String get candidateCvLabel => 'Upload CV (PDF, DOCX)';

  @override
  String candidateCvSelected(String fileName) {
    return 'CV Attached: $fileName';
  }

  @override
  String get candidateDuplicateError =>
      'Candidate already has a profile within the last 6 months';

  @override
  String get submitReferralBtn => 'Submit Referral';

  @override
  String get referralSuccessTitle => 'Referral Submitted Successfully';

  @override
  String get referralSuccessMsg =>
      'Candidate profile has been forwarded directly to Talent Acquisition';

  @override
  String get referralCodeLabel => 'Referral Tracking Code';

  @override
  String get referralBonusNotice =>
      'Referral Bonus: 3,000,000 ₫ (after passing probation)';

  @override
  String get viewMyReferralsBtn => 'View My Referrals';

  @override
  String get myReferralsTitle => 'My Referred Candidates';

  @override
  String get myReferralLinkTitle => 'Your Referral Link & QR Code';

  @override
  String get copyLinkBtn => 'Copy link';

  @override
  String get shareQrBtn => 'Share QR';

  @override
  String get linkCopiedSnackbar => 'Referral link copied to clipboard';

  @override
  String get stageReceived => 'Application Received';

  @override
  String get stageInterview => 'Interview';

  @override
  String get stageProbation => 'Probation';

  @override
  String get stageHired => 'Hired & Bonus Paid';

  @override
  String get noReferralsFound => 'No referred candidates found';

  @override
  String get profileEditTitle => 'Edit Profile';

  @override
  String get profileEditHeader => 'Personal & Account Information';

  @override
  String get freeEditSection => 'Contact Information (Instant Update)';

  @override
  String get sensitiveEditSection =>
      'Identification & Bank Account (Requires HR Approval)';

  @override
  String get sensitiveEditNotice =>
      'Modifications to Citizen ID and Bank Account require approval from Human Resources before taking official effect.';

  @override
  String get phoneEditLabel => 'Phone Number';

  @override
  String get emailEditLabel => 'Personal Email';

  @override
  String get addressEditLabel => 'Current Address';

  @override
  String get emergencyNameLabel => 'Emergency Contact Name';

  @override
  String get emergencyPhoneLabel => 'Emergency Contact Phone';

  @override
  String get bankNameEditLabel => 'Beneficiary Bank';

  @override
  String get bankAccountEditLabel => 'Account Number';

  @override
  String get bankHolderEditLabel => 'Account Holder Name';

  @override
  String get cccdEditLabel => 'Citizen ID / Passport Number';

  @override
  String get cccdIssueDateLabel => 'Issue Date';

  @override
  String get cccdIssuePlaceLabel => 'Place of Issue';

  @override
  String get permanentAddressLabel => 'Permanent Address (per ID)';

  @override
  String get saveChangesBtn => 'Save Changes';

  @override
  String get profileEditSuccess => 'Profile updated successfully';

  @override
  String profilePendingHrAlert(String code) {
    return 'Sensitive profile update request submitted to HR (Tracking Code: $code)';
  }

  @override
  String get statusPendingHr => 'Pending HR Approval';

  @override
  String get documentManagementTitle => 'Documents & Records';

  @override
  String get expiringDocAlertTitle => 'Expiring Document Alert';

  @override
  String expiringDocAlertMsg(int days, String date) {
    return 'Periodic health certificate expires in $days days ($date). Please submit an updated document.';
  }

  @override
  String get legalDocSectionTitle => 'Legal Documents & Certifications';

  @override
  String get viewContractBtn => 'View Contract';

  @override
  String get contractViewerTitle => 'Digital Labor Contract';

  @override
  String contractWatermark(String employeeCode, String name, String date) {
    return 'DIGITAL COPY - $employeeCode - $name - $date';
  }

  @override
  String get uploadNewDocBtn => 'Upload New Document';

  @override
  String get downloadDocBtn => 'Download PDF';

  @override
  String get dependantsManageTitle => 'Dependants';

  @override
  String get dependantsTaxReliefTitle => 'Family Circumstance Tax Relief (PIT)';

  @override
  String dependantsCountLabel(int count) {
    return 'Number of dependants: $count';
  }

  @override
  String dependantsTotalReliefLabel(String amount) {
    return 'Total monthly tax deduction: $amount ₫/month';
  }

  @override
  String get dependantPolicyNotice =>
      'Family circumstance deduction of 4,400,000 ₫/person/month pursuant to Standing Committee of the National Assembly resolution.';

  @override
  String get addDependantBtn => 'Register New Dependant';

  @override
  String get dependantNewTitle => 'Register Dependant';

  @override
  String get dependantFullNameLabel => 'Dependant Full Name';

  @override
  String get dependantRelationshipLabel => 'Relationship';

  @override
  String get dependantDobLabel => 'Date of Birth';

  @override
  String get dependantTaxIdLabel => 'Tax ID / Citizen ID / Birth Cert No.';

  @override
  String get dependantStartMonthLabel => 'Effective Deduction Start Month';

  @override
  String get dependantProofUploadLabel =>
      'Supporting Document (Birth Cert / ID)';

  @override
  String get dependantDisclaimer =>
      'I declare that all submitted dependant details are true, correct, and I assume full legal responsibility.';

  @override
  String get submitDependantBtn => 'Submit Dependant Registration';

  @override
  String get dependantCreatedSuccess =>
      'Dependant registration submitted to Human Resources successfully';

  @override
  String get noDependantsFound => 'No registered dependants found';

  @override
  String get onboardingHomeTitle => 'Onboarding Journey';

  @override
  String get onboardingWelcomeMsg => 'Welcome to VSTECH!';

  @override
  String onboardingCountdownDays(int days, String date) {
    return '$days days left until Day One ($date)';
  }

  @override
  String onboardingProgressSummary(int completed, int total) {
    return 'Preparation progress: $completed/$total steps';
  }

  @override
  String get offerLetterTitle => 'Job Offer Letter';

  @override
  String get offerAcceptBtn => 'Accept Offer Letter';

  @override
  String get offerAcceptedBadge => 'Offer Accepted';

  @override
  String offerSalaryProbation(String amount) {
    return 'Probation Salary (85%): $amount ₫';
  }

  @override
  String get orgIntroTitle => 'Team & Buddy Introduction';

  @override
  String get buddyCardTitle => 'Your Assigned Onboarding Buddy';

  @override
  String get uploadDocsTitle => 'Submit HR Documents';

  @override
  String uploadDocsProgress(int uploaded, int total) {
    return 'Submitted $uploaded/$total documents';
  }

  @override
  String get capturePhotoTitle => 'Employee Badge Photo';

  @override
  String get capturePhotoGuide =>
      'Take a 3x4 portrait against a plain background, looking straight at the camera';

  @override
  String get capturePhotoBtn => 'Take Photo';

  @override
  String get confirmPhotoBtn => 'Confirm & Use This Photo';

  @override
  String get ocrVerificationTitle => 'Identity Verification (Citizen ID OCR)';

  @override
  String get ocrScanBtn => 'Scan Citizen ID Front';

  @override
  String get ocrVerifiedBadge => '100% Identity Match Verified';

  @override
  String get probationContractTitle => 'Digital Probation Contract';

  @override
  String get signContractBtn => 'Sign Digital Contract';

  @override
  String get contractSignedSuccess =>
      'Digital probation contract signed successfully';

  @override
  String get dayOneGuideTitle => 'Day One Survival Guide';

  @override
  String get dayOneChecklistTitle => 'Essential Notes for Day One';

  @override
  String get startNextStepBtn => 'Continue Next Step';
}
