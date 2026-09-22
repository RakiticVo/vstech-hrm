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
  String get leaveTypeSick => 'Sick Leave';

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
  String get deviceSecurityTitle => 'DEVICE & SYSTEM INTEGRITY';

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
}
