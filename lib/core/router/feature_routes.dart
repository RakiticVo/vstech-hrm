import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/screens/state_showcase_screen.dart';
import 'package:vstech_hrm/features/announcements/domain/entities/announcement_entity.dart';
import 'package:vstech_hrm/features/announcements/presentation/cubit/announcements_cubit.dart';
import 'package:vstech_hrm/features/announcements/presentation/screens/announcement_detail_screen.dart';
import 'package:vstech_hrm/features/announcements/presentation/screens/announcements_screen.dart';
import 'package:vstech_hrm/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:vstech_hrm/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:vstech_hrm/features/attendance/presentation/cubit/offline_queue_cubit.dart';
import 'package:vstech_hrm/features/attendance/presentation/screens/device_block_screen.dart';
import 'package:vstech_hrm/features/attendance/presentation/screens/face_scan_screen.dart';
import 'package:vstech_hrm/features/attendance/presentation/screens/offline_queue_screen.dart';
import 'package:vstech_hrm/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:vstech_hrm/features/compliance/presentation/cubits/delegation_cubit.dart';
import 'package:vstech_hrm/features/compliance/presentation/cubits/risk_alerts_cubit.dart';
import 'package:vstech_hrm/features/compliance/presentation/screens/delegation_center_screen.dart';
import 'package:vstech_hrm/features/compliance/presentation/screens/risk_compliance_screen.dart';
import 'package:vstech_hrm/features/executive/presentation/cubit/executive_cubit.dart';
import 'package:vstech_hrm/features/executive/presentation/cubit/final_approval_cubit.dart';
import 'package:vstech_hrm/features/executive/presentation/screens/executive_dashboard_screen.dart';
import 'package:vstech_hrm/features/executive/presentation/screens/final_approval_screen.dart';
import 'package:vstech_hrm/features/holidays/presentation/screens/holidays_screen.dart';
import 'package:vstech_hrm/features/labor_profile/presentation/cubit/labor_profile_cubit.dart';
import 'package:vstech_hrm/features/labor_profile/presentation/screens/labor_profile_screen.dart';
import 'package:vstech_hrm/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:vstech_hrm/features/payroll/presentation/screens/extra_hours_screen.dart';
import 'package:vstech_hrm/features/payroll/presentation/screens/payslip_detail_screen.dart';
import 'package:vstech_hrm/features/payroll/presentation/screens/payslip_lock_screen.dart';
import 'package:vstech_hrm/features/payroll/presentation/screens/salary_dispute_new_screen.dart';
import 'package:vstech_hrm/features/payroll/presentation/screens/salary_dispute_screen.dart';
import 'package:vstech_hrm/features/qr_auth/presentation/cubit/qr_scanner_cubit.dart';
import 'package:vstech_hrm/features/qr_auth/presentation/screens/qr_scanner_screen.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/capture_photo_screen.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/day_one_guide_screen.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/digital_contract_sign_screen.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/document_upload_screen.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/ocr_verification_screen.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/offer_letter_screen.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/onboarding_home_screen.dart';
import 'package:vstech_hrm/features/onboarding/presentation/screens/org_chart_intro_screen.dart';
import 'package:vstech_hrm/features/profile/presentation/screens/dependant_new_screen.dart';
import 'package:vstech_hrm/features/profile/presentation/screens/dependants_screen.dart';
import 'package:vstech_hrm/features/profile/presentation/screens/document_management_screen.dart';
import 'package:vstech_hrm/features/profile/presentation/screens/profile_edit_screen.dart';
import 'package:vstech_hrm/features/recruitment/presentation/screens/internal_recruitment_screen.dart';
import 'package:vstech_hrm/features/recruitment/presentation/screens/job_detail_screen.dart';
import 'package:vstech_hrm/features/recruitment/presentation/screens/my_referrals_screen.dart';
import 'package:vstech_hrm/features/recruitment/presentation/screens/referral_form_screen.dart';
import 'package:vstech_hrm/features/recruitment/presentation/screens/referral_success_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/attendance_correction_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/business_trip_request_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/correction_manage_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/leave_balance_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/leave_manage_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/leave_request_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/on_duty_request_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/overtime_manage_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/overtime_request_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/request_detail_screen.dart';
import 'package:vstech_hrm/features/requests/presentation/screens/request_sent_screen.dart';
import 'package:vstech_hrm/features/rewards/presentation/screens/rewards_screen.dart';
import 'package:vstech_hrm/features/schedule/presentation/screens/shift_schedule_screen.dart';
import 'package:vstech_hrm/features/schedule/presentation/screens/shift_swaps_screen.dart';
import 'package:vstech_hrm/features/services/presentation/screens/all_services_screen.dart';
import 'package:vstech_hrm/features/settings/presentation/screens/registered_device_screen.dart';
import 'package:vstech_hrm/features/settings/presentation/screens/settings_screen.dart';

/// Standalone feature routes definitions.
List<RouteBase> getStandaloneFeatureRoutes() => [
  GoRoute(
    path: AppRoutes.checkInCamera,
    builder: (context, state) {
      final type = state.extra is AttendanceType ? state.extra! as AttendanceType : AttendanceType.checkIn;
      return BlocProvider(create: (_) => sl<AttendanceBloc>(), child: FaceScanScreen(type: type));
    },
  ),
  GoRoute(path: AppRoutes.services, builder: (context, state) => const AllServicesScreen()),
  GoRoute(path: AppRoutes.calendar, builder: (context, state) => const CalendarScreen()),
  GoRoute(path: AppRoutes.holidays, builder: (context, state) => const HolidaysScreen()),
  GoRoute(path: AppRoutes.leaveCreate, builder: (context, state) => const LeaveRequestScreen()),
  GoRoute(path: AppRoutes.leaveBalance, builder: (context, state) => const LeaveBalanceScreen()),
  GoRoute(path: AppRoutes.overtimeCreate, builder: (context, state) => const OvertimeRequestScreen()),
  GoRoute(path: AppRoutes.attendanceCorrection, builder: (context, state) => const AttendanceCorrectionScreen()),
  GoRoute(path: AppRoutes.onDutyCreate, builder: (context, state) => const OnDutyRequestScreen()),
  GoRoute(path: AppRoutes.businessTripCreate, builder: (context, state) => const BusinessTripRequestScreen()),
  GoRoute(path: AppRoutes.payslipDetail, builder: (context, state) => const PayslipDetailScreen()),
  GoRoute(path: AppRoutes.extraHours, builder: (context, state) => const ExtraHoursScreen()),
  GoRoute(path: AppRoutes.rewards, builder: (context, state) => const RewardsScreen()),
  GoRoute(path: AppRoutes.jobRecruitment, builder: (context, state) => const InternalRecruitmentScreen()),
  GoRoute(path: AppRoutes.jobDetail, builder: (context, state) => const JobDetailScreen()),
  GoRoute(path: AppRoutes.notifications, builder: (context, state) => const NotificationsScreen()),
  GoRoute(path: AppRoutes.settings, builder: (context, state) => const SettingsScreen()),
  GoRoute(path: AppRoutes.registeredDevice, builder: (context, state) => const RegisteredDeviceScreen()),
  GoRoute(
    path: AppRoutes.deviceBlock,
    builder: (context, state) => DeviceBlockScreen(securityType: state.extra as String? ?? 'mock'),
  ),
  GoRoute(path: AppRoutes.shiftSchedule, builder: (context, state) => const ShiftScheduleScreen()),
  GoRoute(path: AppRoutes.stateShowcase, builder: (context, state) => const StateShowcaseScreen()),
  GoRoute(
    path: AppRoutes.announcements,
    builder: (context, state) => BlocProvider(create: (_) => sl<AnnouncementsCubit>(), child: const AnnouncementsScreen()),
  ),
  GoRoute(
    path: AppRoutes.announcementDetail,
    builder: (context, state) {
      final item = state.extra is AnnouncementEntity ? state.extra! as AnnouncementEntity : null;
      if (item == null) {
        return BlocProvider(create: (_) => sl<AnnouncementsCubit>(), child: const AnnouncementsScreen());
      }
      return BlocProvider(create: (_) => sl<AnnouncementsCubit>(), child: AnnouncementDetailScreen(announcement: item));
    },
  ),
  GoRoute(
    path: AppRoutes.laborProfile,
    builder: (context, state) => BlocProvider(create: (_) => sl<LaborProfileCubit>(), child: const LaborProfileScreen()),
  ),
  GoRoute(
    path: AppRoutes.offlineQueue,
    builder: (context, state) => BlocProvider(create: (_) => sl<OfflineQueueCubit>(), child: const OfflineQueueScreen()),
  ),
  GoRoute(
    path: AppRoutes.qrScanner,
    builder: (context, state) => BlocProvider(create: (_) => sl<QrScannerCubit>(), child: const QrScannerScreen()),
  ),
  GoRoute(
    path: AppRoutes.executiveDashboard,
    builder: (context, state) => BlocProvider(create: (_) => sl<ExecutiveCubit>(), child: const ExecutiveDashboardScreen()),
  ),
  GoRoute(
    path: AppRoutes.finalApproval,
    builder: (context, state) => BlocProvider(create: (_) => sl<FinalApprovalCubit>(), child: const FinalApprovalScreen()),
  ),
  GoRoute(
    path: AppRoutes.riskCompliance,
    builder: (context, state) => BlocProvider(create: (_) => sl<RiskAlertsCubit>(), child: const RiskComplianceScreen()),
  ),
  GoRoute(
    path: AppRoutes.delegationCenter,
    builder: (context, state) => BlocProvider(create: (_) => sl<DelegationCubit>(), child: const DelegationCenterScreen()),
  ),
  GoRoute(
    path: AppRoutes.requestDetail,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      if (extra != null) {
        return RequestDetailScreen(
          requestCode: extra['code'] as String? ?? 'RQ-2026-0934',
          title: extra['title'] as String? ?? 'Nghỉ phép năm',
          category: extra['category'] as String? ?? 'leave',
          requesterName: extra['requesterName'] as String? ?? 'Nguyễn Minh Tuấn (NV-04821)',
          department: extra['department'] as String? ?? 'Vận hành · Chi nhánh 01',
          initialStatus: extra['initialStatus'] as String? ?? 'pending',
          isApprover: extra['isApprover'] as bool? ?? false,
          swapComparison: extra['swapComparison'] as String?,
          attendanceSnippet: extra['attendanceSnippet'] as String?,
          disputePayslipValue: extra['disputePayslipValue'] as String?,
          disputeExpectedValue: extra['disputeExpectedValue'] as String?,
          disputeDifference: extra['disputeDifference'] as String?,
          fields: extra['fields'] as List<(String, String)>? ?? const [
            ('Loại yêu cầu', 'Nghỉ phép năm (Phép hưởng 100% lương)'),
            ('Thời gian', '24/09/2026 (08:00 — 17:00)'),
            ('Số ngày nghỉ', '1.0 ngày'),
            ('Người bàn giao', 'Lê Văn Tùng (NV-0142)'),
            ('Lý do', 'Việc cá nhân giải quyết thủ tục hành chính.'),
          ],
        );
      }
      return const RequestDetailScreen();
    },
  ),
  GoRoute(path: AppRoutes.leaveManage, builder: (context, state) => const LeaveManageScreen()),
  GoRoute(path: AppRoutes.overtimeManage, builder: (context, state) => const OvertimeManageScreen()),
  GoRoute(path: AppRoutes.correctionManage, builder: (context, state) => const CorrectionManageScreen()),
  GoRoute(path: AppRoutes.shiftSwaps, builder: (context, state) => const ShiftSwapsScreen()),
  GoRoute(
    path: AppRoutes.requestSent,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      return RequestSentScreen(
        requestCode: extra?['code'] as String? ?? 'RQ-2026-0935',
        requestTitle: extra?['title'] as String? ?? 'Nghỉ phép năm · 1 ngày',
        assignedTo: extra?['assignedTo'] as String? ?? 'Lê Minh Quân (Quản lý trực tiếp)',
      );
    },
  ),
  GoRoute(
    path: AppRoutes.payslipLock,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final target = extra?['targetRoute'] as String? ?? AppRoutes.payslipDetail;
      return PayslipLockScreen(targetRoute: target);
    },
  ),
  GoRoute(path: AppRoutes.salaryDisputes, builder: (context, state) => const SalaryDisputeScreen()),
  GoRoute(
    path: AppRoutes.salaryDisputeNew,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      return SalaryDisputeNewScreen(
        prefilledItem: extra?['item'] as String? ?? 'Lương tăng ca 150%',
        prefilledCurrentAmount: extra?['amount'] as int? ?? 1800000,
        periodMonth: extra?['period'] as String? ?? '09/2026',
      );
    },
  ),
  GoRoute(
    path: AppRoutes.referralForm,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      return ReferralFormScreen(
        prefilledPosition: extra?['position'] as String? ?? 'Quản lý cửa hàng',
      );
    },
  ),
  GoRoute(
    path: AppRoutes.referralSuccess,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      return ReferralSuccessScreen(
        trackingCode: extra?['trackingCode'] as String? ?? 'REF-2026-0812',
        candidateName: extra?['candidateName'] as String? ?? 'Trần Anh Khoa',
        position: extra?['position'] as String? ?? 'Quản lý cửa hàng',
      );
    },
  ),
  GoRoute(path: AppRoutes.myReferrals, builder: (context, state) => const MyReferralsScreen()),
  GoRoute(path: AppRoutes.profileEdit, builder: (context, state) => const ProfileEditScreen()),
  GoRoute(path: AppRoutes.documentManagement, builder: (context, state) => const DocumentManagementScreen()),
  GoRoute(path: AppRoutes.dependants, builder: (context, state) => const DependantsScreen()),
  GoRoute(path: AppRoutes.dependantNew, builder: (context, state) => const DependantNewScreen()),
  GoRoute(path: AppRoutes.onboardingHome, builder: (context, state) => const OnboardingHomeScreen()),
  GoRoute(path: AppRoutes.onboardingOffer, builder: (context, state) => const OfferLetterScreen()),
  GoRoute(path: AppRoutes.onboardingOrg, builder: (context, state) => const OrgChartIntroScreen()),
  GoRoute(path: AppRoutes.onboardingDocs, builder: (context, state) => const DocumentUploadScreen()),
  GoRoute(path: AppRoutes.onboardingCapture, builder: (context, state) => const CapturePhotoScreen()),
  GoRoute(path: AppRoutes.onboardingOcr, builder: (context, state) => const OcrVerificationScreen()),
  GoRoute(path: AppRoutes.onboardingSign, builder: (context, state) => const DigitalContractSignScreen()),
  GoRoute(path: AppRoutes.onboardingDayOne, builder: (context, state) => const DayOneGuideScreen()),
];
