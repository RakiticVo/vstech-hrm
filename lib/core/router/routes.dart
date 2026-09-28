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

  // 4 Core MVP Additions
  static const String announcements = '/announcements';
  static const String announcementDetail = '/announcements/detail';
  static const String laborProfile = '/profile/labor-contract';
  static const String offlineQueue = '/attendance/offline-queue';
  static const String qrScanner = '/qr-scanner';

  // Executive & Governance Suite (Màn 21, 22, 28, 29)
  static const String executiveDashboard = '/executive';
  static const String finalApproval = '/executive/final-approval';
  static const String riskCompliance = '/compliance/risk';
  static const String delegationCenter = '/compliance/delegation';

  // Phase 0 Demo Scope Extensions
  static const String onDutyCreate = '/requests/on-duty-create';
  static const String businessTripCreate = '/requests/business-trip-create';
  static const String leaveBalance = '/requests/leave-balance';
  static const String extraHours = '/payroll/extra-hours';
  static const String registeredDevice = '/settings/registered-device';
  static const String deviceBlock = '/attendance/device-block';

  // Phase 1 Extended Management & Detail Routes
  static const String requestDetail = '/requests/detail';
  static const String leaveManage = '/requests/leave-manage';
  static const String overtimeManage = '/requests/overtime-manage';
  static const String correctionManage = '/requests/correction-manage';
  static const String shiftSwaps = '/schedule/swaps';
  static const String requestSent = '/requests/sent';

  // Phase 2 Payslip Security & Dispute Routes
  static const String payslipLock = '/payroll/lock';
  static const String salaryDisputes = '/payroll/disputes';
  static const String salaryDisputeNew = '/payroll/dispute-new';

  // Phase 4 Internal Recruitment & Referral Routes
  static const String referralForm = '/recruitment/refer';
  static const String referralSuccess = '/recruitment/refer-sent';
  static const String myReferrals = '/recruitment/my-referrals';

  // Phase 5 Profile Edit, Documents & Dependants Routes
  static const String profileEdit = '/profile/edit';
  static const String documentManagement = '/profile/documents';
  static const String dependants = '/profile/dependants';
  static const String dependantNew = '/profile/dependants/new';

  // Phase 6 Full Candidate Onboarding Experience (OB Suite)
  static const String onboardingHome = '/onboarding/home';
  static const String onboardingOffer = '/onboarding/offer';
  static const String onboardingOrg = '/onboarding/org';
  static const String onboardingDocs = '/onboarding/upload-docs';
  static const String onboardingCapture = '/onboarding/capture-photo';
  static const String onboardingOcr = '/onboarding/ocr';
  static const String onboardingSign = '/onboarding/sign-contract';
  static const String onboardingDayOne = '/onboarding/day-one';
}
