// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'VSTech HRM';

  @override
  String get login => 'Đăng nhập';

  @override
  String get employeeCode => 'Mã nhân viên';

  @override
  String get password => 'Mật khẩu';

  @override
  String get checkIn => 'Chấm công';

  @override
  String get checkOut => 'Tan ca';

  @override
  String get home => 'Trang chủ';

  @override
  String get attendance => 'Chấm công';

  @override
  String get requests => 'Yêu cầu';

  @override
  String get approvals => 'Phê duyệt';

  @override
  String get payroll => 'Bảng lương';

  @override
  String get profile => 'Cá nhân';

  @override
  String get errorOccurred => 'Đã có lỗi xảy ra';

  @override
  String get retry => 'Thử lại';

  @override
  String get contactHr => 'Liên hệ HR';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get cancel => 'Hủy bỏ';

  @override
  String get save => 'Lưu lại';

  @override
  String get close => 'Đóng';

  @override
  String get viewAll => 'Tất cả';

  @override
  String get back => 'Quay lại';

  @override
  String get details => 'Chi tiết';

  @override
  String get syncNow => 'Đồng bộ ngay';

  @override
  String get loginSubtitle => 'Giải pháp Quản trị Nhân sự Thông minh';

  @override
  String get loginInstruction => 'Nhập mã nhân viên và mật khẩu của bạn';

  @override
  String get loginButton => 'ĐĂNG NHẬP HỆ THỐNG';

  @override
  String get biometricLogin => 'Đăng nhập bằng Face ID / Vân tay';

  @override
  String get demoQuickLogin => 'Đăng nhập nhanh (Chế độ Demo)';

  @override
  String get demoEmployee => 'Nhân viên (NV)';

  @override
  String get demoManager => 'Quản lý (QL)';

  @override
  String get greetingMorning => 'Chào buổi sáng';

  @override
  String get greetingAfternoon => 'Chào buổi chiều';

  @override
  String get greetingEvening => 'Chào buổi tối';

  @override
  String get greetingDefault => 'Xin chào';

  @override
  String get todayWorkedHours => 'GIỜ ĐÃ LÀM HÔM NAY';

  @override
  String get todayShiftLabel => 'Ca hôm nay';

  @override
  String get clockInCta => 'CHẤM CÔNG VÀO';

  @override
  String get clockOutCta => 'CHẤM CÔNG RA';

  @override
  String get timeIn => 'Giờ vào';

  @override
  String get timeOut => 'Giờ ra';

  @override
  String get lateMinutes => 'Đi muộn';

  @override
  String get overtimeLabel => 'Tăng ca';

  @override
  String get locationVerified => 'Đã xác thực vị trí';

  @override
  String get managerApprovalPending => 'yêu cầu đang chờ bạn phê duyệt';

  @override
  String get managerApprovalAction => 'Duyệt ngay';

  @override
  String get metricWorkdays => 'Ngày công';

  @override
  String get metricLeaveBalance => 'Phép còn lại';

  @override
  String get metricOvertime => 'Giờ tăng ca';

  @override
  String get metricPending => 'Chờ duyệt';

  @override
  String get quickActionLeave => 'Nghỉ phép';

  @override
  String get quickActionOvertime => 'Tăng ca';

  @override
  String get quickActionCorrection => 'Sửa công';

  @override
  String get quickActionPayroll => 'Bảng lương';

  @override
  String get quickActionAll => 'Tất cả';

  @override
  String get salarySummaryTitle => 'Thu nhập tháng 9/2026';

  @override
  String get salaryNetPay => 'Thực nhận';

  @override
  String get announcementsTitle => 'Thông báo nội bộ';

  @override
  String get roleSwitcherTitle => 'Chuyển đổi vai trò Demo';

  @override
  String get shiftCheckInLabel => 'VÀO LÀM';

  @override
  String get shiftCheckOutLabel => 'RA VỀ';

  @override
  String get shiftDoneCta => 'XONG CA';

  @override
  String get shiftCheckOutCta => 'CHẤM RA';

  @override
  String get todayShiftDefault => 'Ca hôm nay 08:00 — 17:00';

  @override
  String get metricLateEarly => 'MUỘN / SỚM';

  @override
  String get daysUnit => 'ngày';

  @override
  String get hoursUnit => 'h';

  @override
  String get monthlyNetSalaryLabel => 'LƯƠNG THỰC NHẬN THÁNG NÀY';

  @override
  String get salaryMasked => '•••••••• ₫';

  @override
  String get salaryHintRevealed => 'Gồm thưởng KPI 2.500.000 ₫ · Xem chi tiết';

  @override
  String get salaryHintHidden => 'Bấm vào mắt để xem · Xem phiếu lương';

  @override
  String get latestUpdatesTitle => 'Cập nhật mới';

  @override
  String get demoLeaveApprovedAnnouncement =>
      'Yêu cầu nghỉ phép 21–23/09 đã được phê duyệt.';

  @override
  String get demoSalaryAnnouncement =>
      'Phiếu lương tháng 9 đã có. Thực nhận 25.500.000 ₫.';

  @override
  String get twoHoursAgo => '2 giờ trước';

  @override
  String get oneDayAgo => '1 ngày trước';

  @override
  String get managerPendingApprovalTitle => 'Chờ bạn phê duyệt';

  @override
  String switchToRole(String role) {
    return 'Đổi sang $role';
  }

  @override
  String get shiftScheduleNav => 'Lịch ca';

  @override
  String get shiftScheduleTitle => 'Lịch ca làm việc';

  @override
  String get workCalendarTooltip => 'Lịch công';

  @override
  String attendanceMonthSummaryTitle(int month) {
    return 'Tổng hợp tháng $month';
  }

  @override
  String get sendCorrectionRequest => 'Gửi yêu cầu sửa công';

  @override
  String get statusCheckedIn => 'Đã chấm công vào';

  @override
  String get statusNotCheckedIn => 'Chưa chấm công';

  @override
  String get shiftPromptArrive =>
      'Ca của bạn bắt đầu 08:00. Chấm công khi bạn đến.';

  @override
  String get hcmOfficeVerified => 'Văn phòng HCM - đã xác thực vị trí';

  @override
  String get zeroMinutes => '0 phút';

  @override
  String get offlineAttendanceModeLabel =>
      'Chấm công Ngoại tuyến (Vector ≥ 85%)';

  @override
  String get onlineAttendanceModeLabel => 'Chế độ Trực tuyến (Online)';

  @override
  String get faceScanCheckInTitle => 'Chấm công Giờ vào';

  @override
  String get faceScanCheckOutTitle => 'Chấm công Giờ ra';

  @override
  String get faceScanCaptureCheckInCta => 'Chụp ảnh & Chấm công Vào';

  @override
  String get faceScanCaptureCheckOutCta => 'Chụp ảnh & Chấm công Ra';

  @override
  String get offlineLocationLabel => 'Văn phòng HCM (Đối soát GPS cục bộ)';

  @override
  String offlineMatchSuccess(String pct) {
    return 'Độ khớp khuôn mặt $pct% (≥ 85%). Đã lưu hàng đợi offline.';
  }

  @override
  String get offlineMatchFailed =>
      'Khuôn mặt chưa đạt ngưỡng khớp 85%. Vui lòng căn chỉnh lại góc mặt.';

  @override
  String offlineQueueCount(int count) {
    return '$count lượt chấm công ngoại tuyến';
  }

  @override
  String get offlineQueueDesc => 'Đã lưu cục bộ an toàn, sẵn sàng đồng bộ.';

  @override
  String offlineSyncSuccess(int count) {
    return 'Đã đồng bộ thành công $count lượt chấm công lên hệ thống!';
  }

  @override
  String get syncButtonLabel => 'Đồng bộ';

  @override
  String get attendanceFailed => 'Chấm công thất bại';

  @override
  String get viewMonthTooltip => 'Xem cả tháng';

  @override
  String get viewMonth => 'Xem tháng';

  @override
  String weekStatsTitle(String week, String range) {
    return 'Tuần $week ($range)';
  }

  @override
  String weekStatsSummary(int shifts, int hours, int daysOff) {
    return '$shifts ca làm · $hours giờ công · $daysOff ngày nghỉ';
  }

  @override
  String shiftDetailHeader(String dayOfWeek, String date) {
    return 'Chi tiết ca ngày $dayOfWeek, $date';
  }

  @override
  String get shiftStatusActive => 'Đang diễn ra';

  @override
  String get shiftStatusCompleted => 'Đã hoàn thành';

  @override
  String get shiftStatusUpcoming => 'Sắp diễn ra';

  @override
  String get shiftStatusDayOff => 'Nghỉ tuần';

  @override
  String get dayOffTitle => 'Hôm nay là Ngày nghỉ tuần';

  @override
  String get dayOffDescription =>
      'Không có ca làm việc được phân công. Hãy nghỉ ngơi, nạp năng lượng chuẩn bị cho tuần mới!';

  @override
  String get registerOvertimeCta => 'Đăng ký làm thêm (OT)';

  @override
  String get shiftLabelTime => 'Thời gian:';

  @override
  String get shiftLabelBreak => 'Nghỉ giữa ca:';

  @override
  String get shiftLabelLocation => 'Địa điểm:';

  @override
  String get shiftLabelManager => 'Quản lý ca:';

  @override
  String get shiftLabelNotes => 'Ghi chú:';

  @override
  String get shiftSwapButton => 'Đổi ca';

  @override
  String get shiftOvertimeButton => 'Báo tăng ca';

  @override
  String swapRequestSent(String colleague) {
    return 'Đã gửi yêu cầu đổi ca cho $colleague!';
  }

  @override
  String get swapShiftProposalTitle => 'Đề xuất đổi ca làm việc';

  @override
  String get selectColleagueLabel => 'Chọn đồng nghiệp muốn đổi ca:';

  @override
  String get swapReasonLabel => 'Lý do đổi ca:';

  @override
  String get swapReasonHint => 'Nhập lý do đổi ca cụ thể...';

  @override
  String get submitSwapRequestButton => 'Gửi yêu cầu đổi ca';

  @override
  String shiftCalendarMonthTitle(int month, int year) {
    return 'Lịch ca Tháng $month/$year';
  }

  @override
  String get dayMon => 'T2';

  @override
  String get dayTue => 'T3';

  @override
  String get dayWed => 'T4';

  @override
  String get dayThu => 'T5';

  @override
  String get dayFri => 'T6';

  @override
  String get daySat => 'T7';

  @override
  String get daySun => 'CN';

  @override
  String get shiftMorning => 'Sáng';

  @override
  String get shiftAfternoon => 'Chiều';

  @override
  String get shiftSplit => 'Gãy';

  @override
  String get shiftNight => 'Đêm';

  @override
  String get shiftOff => 'Nghỉ';

  @override
  String get tabAll => 'Tất cả';

  @override
  String get tabPending => 'Chờ duyệt';

  @override
  String get tabApproved => 'Đã duyệt';

  @override
  String get tabRejected => 'Từ chối';

  @override
  String get createNewRequestTitle => 'Tạo yêu cầu mới';

  @override
  String get requestTypeLeave => 'Xin nghỉ phép';

  @override
  String get requestTypeOvertime => 'Đăng ký tăng ca';

  @override
  String get requestTypeCorrection => 'Sửa công';

  @override
  String get requestsCenterTitle => 'Trung tâm yêu cầu';

  @override
  String get requestsCenterSubtitle => 'Nghỉ phép · Tăng ca · Sửa công';

  @override
  String get monthlyRequestsTitle => 'Yêu cầu theo tháng';

  @override
  String get selectMonthToView => 'Chọn tháng xem dữ liệu';

  @override
  String noRequestsInMonth(String month) {
    return 'Không có yêu cầu nào trong $month';
  }

  @override
  String get roleIndicatorEmployee => 'Xem vai trò Quản lý:';

  @override
  String get roleIndicatorSwitchToManager => 'Đổi sang QL (mục Duyệt)';

  @override
  String managerPendingApprovalsBanner(int count) {
    return 'Bạn có $count yêu cầu chờ phê duyệt';
  }

  @override
  String get openApprovalsLink => 'Mở mục Duyệt >';

  @override
  String get submitRequestButton => 'Gửi yêu cầu';

  @override
  String get leaveRemainingStat => 'Phép năm còn';

  @override
  String get leaveUsedStat => 'Đã sử dụng';

  @override
  String get newLeaveRequestSection => 'Đơn nghỉ phép mới';

  @override
  String get leaveTypeLabel => 'Loại nghỉ';

  @override
  String get timeRangeLabel => 'Thời gian';

  @override
  String get totalLabel => 'Tổng cộng';

  @override
  String get leaveHistorySection => 'Lịch sử đơn nghỉ phép';

  @override
  String noLeaveRequestsInMonth(String month) {
    return 'Không có đơn nghỉ phép nào trong $month';
  }

  @override
  String get leaveRequestSubmittedTitle => 'Đã gửi đơn xin nghỉ phép!';

  @override
  String leaveRequestSubmittedMsg(
    String type,
    String start,
    String end,
    String total,
  ) {
    return 'Đơn $type từ $start đến $end ($total) đã được gửi tới Quản lý phê duyệt.';
  }

  @override
  String get thisMonthStat => 'Tháng này';

  @override
  String get paidStat => 'Đã thanh toán';

  @override
  String get needsActionStat => 'Cần xử lý';

  @override
  String get newOvertimeRequestSection => 'Tăng ca mới';

  @override
  String get newCorrectionRequestSection => 'Sửa công mới';

  @override
  String get overtimeHistorySection => 'Lịch sử tăng ca';

  @override
  String get correctionHistorySection => 'Lịch sử sửa công';

  @override
  String get approvalsCenterTitle => 'Trung tâm phê duyệt';

  @override
  String get awaitingYourAction => 'Chờ bạn xử lý';

  @override
  String get noPendingApprovals => 'Không có yêu cầu nào đang chờ duyệt';

  @override
  String requestApprovedSuccess(String name) {
    return 'Đã phê duyệt yêu cầu của $name';
  }

  @override
  String requestRejectedSuccess(String name) {
    return 'Đã từ chối yêu cầu của $name';
  }

  @override
  String get statusPending => 'Chờ duyệt';

  @override
  String get actionReject => 'Từ chối';

  @override
  String get actionApprove => 'Duyệt';

  @override
  String get statusApproved => 'Đã duyệt';

  @override
  String get statusRejected => 'Từ chối';

  @override
  String get statusNeedsAction => 'Cần bổ sung';

  @override
  String get stagePendingManager => 'Chờ quản lý';

  @override
  String get stagePendingHr => 'Chờ HR';

  @override
  String get stagePendingDirector => 'Chờ giám đốc';

  @override
  String get stageCompleted => 'Hoàn tất';

  @override
  String get stageRejected => 'Từ chối';

  @override
  String get leaveTypeAnnual => 'Phép năm';

  @override
  String get leaveTypeSick => 'Nghỉ ốm (BHXH)';

  @override
  String get leaveTypeUnpaid => 'Nghỉ không lương';

  @override
  String get leaveTypeSpecial => 'Phép đặc biệt';

  @override
  String get leaveTypePersonal => 'Việc riêng';

  @override
  String get createLeaveRequestTitle => 'Tạo đơn xin nghỉ phép';

  @override
  String get leaveTypeSelectorTitle => 'Loại nghỉ phép';

  @override
  String get fromDateLabel => 'Từ ngày';

  @override
  String get toDateLabel => 'Đến ngày';

  @override
  String get reasonLabel => 'Lý do';

  @override
  String get addAttachmentOptional => 'Thêm tệp đính kèm (không bắt buộc)';

  @override
  String attachmentSelected(String fileName, String size) {
    return 'Đã chọn tệp đính kèm: $fileName ($size)';
  }

  @override
  String get confirmSendLeaveRequest => 'Xác nhận gửi đơn';

  @override
  String get overtimeModalTitle => 'Nhập thông tin tăng ca';

  @override
  String get overtimeDateLabel => 'Ngày tăng ca';

  @override
  String get overtimeTimeRangeLabel => 'Khung giờ làm thêm';

  @override
  String get startTimeLabel => 'Bắt đầu';

  @override
  String get endTimeLabel => 'Kết thúc';

  @override
  String overtimeEstimateCalc(int hours, String rate, String type) {
    return 'Tổng cộng: $hours giờ · Hệ số $rate ($type)';
  }

  @override
  String get overtimeDayTypeNormal => 'Ngày thường';

  @override
  String get overtimeReasonLabel => 'Lý do tăng ca';

  @override
  String get confirmSendOvertime => 'Xác nhận gửi';

  @override
  String get overtimeSubmittedTitle => 'Đã gửi đăng ký tăng ca!';

  @override
  String overtimeSubmittedMsg(String date, String time) {
    return 'Yêu cầu làm thêm giờ ngày $date ($time) đã được gửi cho Quản lý phê duyệt.';
  }

  @override
  String noOvertimeInMonth(String month) {
    return 'Không có dữ liệu tăng ca trong $month';
  }

  @override
  String get createCorrectionTitle => 'Tạo yêu cầu sửa công';

  @override
  String get correctionDateLabel => 'Ngày sửa';

  @override
  String get correctionTimeLabel => 'Sửa thành giờ';

  @override
  String get correctionIssueLabel => 'Vấn đề phát sinh';

  @override
  String get issueMissingCheckout => 'Thiếu giờ ra';

  @override
  String get issueMissingCheckin => 'Thiếu giờ vào';

  @override
  String get issueWrongShift => 'Sai ca làm';

  @override
  String get issueScannerError => 'Lỗi máy quét';

  @override
  String get explanationDetailLabel => 'Giải trình chi tiết';

  @override
  String get addProofOptional => 'Đính kèm ảnh/minh chứng (không bắt buộc)';

  @override
  String proofSelected(String fileName, String size) {
    return 'Đã chọn minh chứng: $fileName ($size)';
  }

  @override
  String get confirmSendCorrection => 'Xác nhận gửi yêu cầu';

  @override
  String get correctionSubmittedTitle => 'Đã gửi yêu cầu sửa công!';

  @override
  String correctionSubmittedMsg(String issue, String date, String time) {
    return 'Yêu cầu $issue ngày $date ($time) đã được chuyển tới HR & Quản lý duyệt.';
  }

  @override
  String noCorrectionsInMonth(String month) {
    return 'Không có phiếu sửa công nào trong $month';
  }

  @override
  String get correctionWarningBanner =>
      'Ngày 15/09/2026 chưa có giờ ra. Ngày này bị tính thiếu công cho đến khi được duyệt sửa.';

  @override
  String get correctionIssueTitle => 'Vấn đề';

  @override
  String get correctionChangeTo => 'Sửa thành';

  @override
  String get payrollTitle => 'Lương & Thu nhập';

  @override
  String payrollPeriodSubtitle(String month, String year) {
    return 'Kỳ lương Tháng $month/$year';
  }

  @override
  String get rewardsAction => 'Thưởng';

  @override
  String get payrollNetSalaryTitle => 'LƯƠNG THỰC NHẬN (NET)';

  @override
  String payrollPayDate(String date) {
    return 'VND · Trả ngày $date';
  }

  @override
  String get viewPayslipButton => 'Xem phiếu lương';

  @override
  String get incomeAndDeductionBreakdown => 'Chi tiết thu nhập & khấu trừ';

  @override
  String get salaryHistoryTitle => 'Lịch sử kỳ lương';

  @override
  String get payslipTitle => 'Phiếu lương';

  @override
  String get downloadingPdfSnackbar => 'Đang tải về phiếu lương PDF...';

  @override
  String salaryTransferredTo(String bank, String date) {
    return 'Đã chuyển $bank · $date';
  }

  @override
  String get basicSalaryLabel => 'Lương cơ bản';

  @override
  String get lunchAndTransportAllowance => 'Phụ cấp ăn trưa & đi lại';

  @override
  String kpiQuarterBonus(int quarter) {
    return 'Thưởng KPI quý $quarter';
  }

  @override
  String get socialInsuranceDeduction => 'BHXH, BHYT, BHTN (10.5%)';

  @override
  String get personalIncomeTaxDeduction => 'Thuế TNCN tạm tính';

  @override
  String get unionFeeDeduction => 'Phí đoàn thể';

  @override
  String get incomeSectionTitle => 'Thu nhập';

  @override
  String get deductionSectionTitle => 'Khoản trừ';

  @override
  String get netSalaryLabel => 'Lương thực nhận';

  @override
  String get overtimePayLabel => 'Tăng ca 12h (x1.5)';

  @override
  String payslipNetSalaryMonth(String month, String year) {
    return 'Lương thực nhận: Tháng $month $year';
  }

  @override
  String get profileTitle => 'Cá nhân';

  @override
  String get personalInfoSection => 'Thông tin cá nhân';

  @override
  String get workInfoSection => 'Thông tin công việc';

  @override
  String get bankAccountSection => 'Tài khoản ngân hàng';

  @override
  String get fullNameLabel => 'Họ và tên';

  @override
  String get dateOfBirthLabel => 'Ngày sinh';

  @override
  String get phoneLabel => 'Điện thoại';

  @override
  String get emailLabel => 'Email';

  @override
  String get addressLabel => 'Địa chỉ';

  @override
  String get departmentLabel => 'Bộ phận';

  @override
  String get jobTitleLabel => 'Chức danh';

  @override
  String get directManagerLabel => 'Quản lý';

  @override
  String get joinDateLabel => 'Ngày vào';

  @override
  String get employmentStatusLabel => 'Trạng thái';

  @override
  String get officialStatus => 'Chính thức';

  @override
  String get bankNameLabel => 'Ngân hàng';

  @override
  String get accountNumberLabel => 'Số tài khoản';

  @override
  String get emergencyContactLink => 'Liên hệ khẩn cấp';

  @override
  String get documentsAndRecordsLink => 'Hồ sơ & tài liệu';

  @override
  String get internalRecruitmentLink => 'Tuyển dụng nội bộ';

  @override
  String get settingsLink => 'Cài đặt';

  @override
  String get logoutButton => 'Đăng xuất';

  @override
  String get logoutConfirmTitle => 'Xác nhận đăng xuất';

  @override
  String get logoutConfirmMsg =>
      'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng VSTech HRM không?';

  @override
  String get cancelButton => 'Hủy';

  @override
  String get roleBadgeManager => 'QL';

  @override
  String get roleBadgeEmployee => 'NV';

  @override
  String get readyToUploadAvatarSnackbar =>
      'Đã sẵn sàng tải lên ảnh đại diện mới';

  @override
  String get languageSettingTitle => 'CÀI ĐẶT NGÔN NGỮ';

  @override
  String get chooseLanguageTitle => 'Chọn ngôn ngữ hiển thị';

  @override
  String get languageDesc =>
      'Giao diện và thông báo sẽ được chuyển đổi ngay lập tức sang ngôn ngữ bạn chọn.';

  @override
  String get vietnameseLanguage => 'Tiếng Việt';

  @override
  String get vietnameseDesc => 'Ngôn ngữ mặc định của ứng dụng.';

  @override
  String get englishLanguage => 'English';

  @override
  String get englishDesc => 'English display for global workplace standards.';

  @override
  String get confirmButton => 'Xác nhận';

  @override
  String get closeButton => 'Đóng';

  @override
  String get themeSettingTitle => 'CÀI ĐẶT GIAO DIỆN';

  @override
  String get chooseThemeTitle => 'Chọn chế độ hiển thị';

  @override
  String get themeDesc =>
      'Giao diện thay đổi ngay lập tức và tự động ghi nhớ cho các lần mở ứng dụng tiếp theo.';

  @override
  String get themeSystem => 'Theo hệ thống';

  @override
  String get themeSystemDesc =>
      'Tự động đồng bộ với cài đặt Sáng / Tối của điện thoại.';

  @override
  String get themeLight => 'Giao diện sáng';

  @override
  String get themeLightDesc =>
      'Tông kem ấm & hoạ văn gạch bông Sài Gòn đặc trưng.';

  @override
  String get themeDark => 'Giao diện tối';

  @override
  String get themeDarkDesc => 'Tông xanh đen sâu, dịu mắt khi sử dụng ban đêm.';

  @override
  String get appLockSettingTitle => 'BẢO VỆ DỮ LIỆU';

  @override
  String get appLockTitle => 'Khóa ứng dụng & Mã PIN';

  @override
  String get appLockDesc =>
      'Tự động khóa ứng dụng khi rời màn hình để bảo vệ thông tin lương và hồ sơ nhân viên.';

  @override
  String get enableAppLock => 'Bật khóa ứng dụng';

  @override
  String get autoLockAfter => 'TỰ ĐỘNG KHÓA SAU';

  @override
  String get lockImmediately => 'Ngay lập tức khi rời app';

  @override
  String get lockAfter1Min => 'Sau 1 phút';

  @override
  String get lockAfter5Mins => 'Sau 5 phút';

  @override
  String get saveSettingsButton => 'Lưu thiết lập';

  @override
  String get appLockUpdatedSnackbar =>
      'Đã cập nhật cấu hình khóa ứng dụng thành công';

  @override
  String get biometricSecurityTitle => 'BẢO MẬT SINH TRẮC HỌC';

  @override
  String get biometricAuthTitle => 'Xác thực Vân tay / Khuôn mặt';

  @override
  String get biometricDesc =>
      'Dùng sinh trắc học thiết bị để mở khoá ứng dụng nhanh chóng và bảo vệ xem phiếu lương.';

  @override
  String get enableBiometrics => 'Kích hoạt sinh trắc học';

  @override
  String get hardwareSupportLabel => 'Hỗ trợ phần cứng:';

  @override
  String get hardwareAvailable => 'Khả dụng';

  @override
  String get hardwareNotSupported => 'Không hỗ trợ';

  @override
  String get biometricSensorLabel => 'Cảm biến sinh trắc:';

  @override
  String get sensorConfigured => 'Đã cài đặt trên máy';

  @override
  String get sensorNotConfigured => 'Chưa thiết lập';

  @override
  String get testBiometricNow => 'Kiểm tra cảm biến ngay';

  @override
  String get deviceSecurityTitle => 'Bảo mật thiết bị';

  @override
  String get linkedDeviceTitle => 'Thiết bị liên kết';

  @override
  String get deviceSecurityDesc =>
      'Quy định bảo mật ràng buộc tài khoản với 1 thiết bị duy nhất để chấm công và xem phiếu lương.';

  @override
  String get officialDeviceRegistered => 'Thiết bị chính thức • Đã đăng ký';

  @override
  String get physicalDeviceLabel => 'Thiết bị thực tế';

  @override
  String get physicalDeviceValid => 'Hợp lệ (Physical)';

  @override
  String get physicalDeviceWarning => 'Cảnh báo (Simulator)';

  @override
  String get jailbreakLabel => 'Root / Jailbreak';

  @override
  String get jailbreakSafe => 'An toàn (Chưa Root)';

  @override
  String get jailbreakDetected => 'Phát hiện can thiệp!';

  @override
  String get mockGpsLabel => 'Giả lập vị trí (Mock GPS)';

  @override
  String get mockGpsNotDetected => 'Không phát hiện';

  @override
  String get mockGpsDetected => 'Phát hiện vị trí ảo!';

  @override
  String get developerModeLabel => 'Chế độ nhà phát triển';

  @override
  String get devModeOn => 'Đang bật (Dev Mode)';

  @override
  String get devModeOff => 'Tắt';

  @override
  String get systemInfoTitle => 'THÔNG TIN HỆ THỐNG';

  @override
  String get systemDesc =>
      'Hệ thống quản trị nguồn nhân lực B2B SaaS • Phân hệ Nhân viên & Quản lý.';

  @override
  String get appVersionLabel => 'Phiên bản ứng dụng';

  @override
  String get runtimeEnvLabel => 'Môi trường kết nối';

  @override
  String get dataEngineLabel => 'Động cơ dữ liệu';

  @override
  String get uiFontLabel => 'Ngôn ngữ UI & Font';

  @override
  String get checkUpdatesButton => 'Kiểm tra cập nhật';

  @override
  String get appUpToDateSnackbar =>
      'Ứng dụng đang ở phiên bản mới nhất (v1.0.0)!';

  @override
  String get roleSwitchDemoTitle => 'CHUYỂN ĐỔI VAI TRÒ (DEMO)';

  @override
  String get chooseRoleTitle => 'Chọn vai trò trải nghiệm';

  @override
  String get roleSwitchDesc =>
      'Chế độ Demo độc lập cho phép hoán đổi giao diện và luồng duyệt giữa Nhân viên và Quản lý tức thì.';

  @override
  String get roleEmployeeTitle => 'Nhân viên (NV / ESS)';

  @override
  String get roleEmployeeDesc =>
      'Nguyễn Văn An • NV0142\nChấm công, gửi đơn nghỉ phép, xem phiếu lương.';

  @override
  String get roleManagerTitle => 'Quản lý trực tiếp (QL / MSS)';

  @override
  String get roleManagerDesc =>
      'Trần Thị Mai • NV0089\nXem dải chờ duyệt, duyệt cấp 1 các đơn từ nhân viên.';

  @override
  String switchedToRoleSnackbar(String role) {
    return 'Đã chuyển sang vai trò: $role';
  }

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get notificationsSection => 'Thông báo';

  @override
  String get pushNotifications => 'Thông báo đẩy';

  @override
  String get pushNotificationsDesc => 'Nhận thông báo phê duyệt và ca làm';

  @override
  String get emailReport => 'Email báo cáo';

  @override
  String get emailReportDesc => 'Gửi bản tóm tắt công & lương qua email';

  @override
  String get punchReminder => 'Nhắc nhở chấm công';

  @override
  String get punchReminderDesc => 'Thông báo trước ca làm 15 phút';

  @override
  String get systemPermissionsSection => 'Quyền truy cập hệ thống';

  @override
  String get manageDevicePermissions => 'Quản lý quyền thiết bị';

  @override
  String get permissionsSubtext => 'Máy ảnh, Vị trí GPS, Tệp & ảnh, Thông báo';

  @override
  String get securityAndPrivacySection => 'Bảo mật & Quyền riêng tư';

  @override
  String get biometricUnlock => 'Mở khoá sinh trắc học';

  @override
  String get biometricUnlockDesc => 'Dùng Face ID hoặc vân tay để mở app';

  @override
  String get autoLock => 'Tự động khoá';

  @override
  String get autoLockDesc => 'Khoá app ngay khi chuyển sang ứng dụng khác';

  @override
  String get designAndSystemSection => 'Thiết kế & Hệ thống';

  @override
  String get uiStateShowcase =>
      'Minh họa 4 Trạng thái (Empty, Shimmer, Error, Success)';

  @override
  String get uiStateShowcaseDesc =>
      'Kiểm thử giao diện Rỗng, Đăng tải, Báo lỗi & Thành công';

  @override
  String get clearCache => 'Xoá bộ nhớ đệm (Cache)';

  @override
  String get cacheClearedSnackbar => 'Đã dọn dẹp bộ nhớ đệm thành công';

  @override
  String get enableNotificationInSettings =>
      'Vui lòng bật quyền Thông báo trong Cài đặt hệ thống';

  @override
  String get allServicesTitle => 'Tất cả dịch vụ';

  @override
  String get categoryAttendanceTime => 'Chấm công & Thời gian';

  @override
  String get categoryRequests => 'Đơn từ';

  @override
  String get categoryPayrollRewards => 'Lương & thưởng';

  @override
  String get categoryCareerProfile => 'Nghề nghiệp & hồ sơ';

  @override
  String get categoryGovernance => 'Quản trị & Điều hành';

  @override
  String get serviceCheckInOut => 'Chấm công vào/ra';

  @override
  String get serviceShiftSchedule => 'Lịch ca làm việc';

  @override
  String get serviceMonthlyTimesheet => 'Lịch công tháng';

  @override
  String get serviceHolidays => 'Ngày lễ trong năm';

  @override
  String get serviceLeave => 'Xin nghỉ phép';

  @override
  String get serviceOvertime => 'Đăng ký tăng ca';

  @override
  String get serviceCorrection => 'Sửa công';

  @override
  String get serviceTrackRequests => 'Theo dõi yêu cầu';

  @override
  String get serviceSalaryTable => 'Bảng lương tháng';

  @override
  String get servicePayslip => 'Phiếu lương';

  @override
  String get serviceRewards => 'Thưởng & ghi nhận';

  @override
  String get serviceAllowance => 'Phụ cấp';

  @override
  String get serviceInternalJobs => 'Tuyển dụng nội bộ';

  @override
  String get serviceProfile => 'Hồ sơ cá nhân';

  @override
  String get serviceSettings => 'Cài đặt';

  @override
  String get serviceApprovals => 'Phê duyệt';

  @override
  String get notificationsTitle => 'Thông báo';

  @override
  String get markAllRead => 'Đọc tất cả';

  @override
  String get allNotificationsReadSnackbar => 'Đã đánh dấu tất cả là đã đọc';

  @override
  String get notificationCatLeave => 'Phép';

  @override
  String get notificationCatSalary => 'Lương';

  @override
  String get notificationCatAttendance => 'Chấm công';

  @override
  String get notificationCatReward => 'Thưởng';

  @override
  String get notificationCatRecruitment => 'Tuyển dụng';

  @override
  String get notificationCatSystem => 'Hệ thống';

  @override
  String get calendarScreenTitle => 'Lịch & Ca làm việc';

  @override
  String get calendarSubtitle => 'Tháng 09/2026 · 22 ngày công chuẩn';

  @override
  String get monthSummaryTitle => 'Tổng hợp tháng 9';

  @override
  String get payableWorkdays => 'Ngày công tính lương';

  @override
  String get totalWorkHours => 'Tổng giờ làm việc';

  @override
  String get cumulativeOvertime => 'Tăng ca lũy kế';

  @override
  String get paidLeaveDays => 'Nghỉ phép có hưởng lương';

  @override
  String get lateEarlyArrivals => 'Đi muộn / Về sớm';

  @override
  String get legendFullWork => 'Đủ công';

  @override
  String get legendLeave => 'Nghỉ phép';

  @override
  String get legendMissingTime => 'Thiếu giờ';

  @override
  String get legendHoliday => 'Ngày lễ';

  @override
  String get holidaysTitle => 'Ngày lễ';

  @override
  String get year2026 => 'Năm 2026';

  @override
  String get nationalHolidaysStat => 'Ngày lễ';

  @override
  String get compensatoryLeaveStat => 'Nghỉ bù';

  @override
  String get optionalHolidaysStat => 'Tự chọn';

  @override
  String get rewardsTitle => 'Thưởng & ghi nhận';

  @override
  String get rewardMonthHeader => 'Thưởng tháng 9';

  @override
  String get paidWithMonthSalary => 'VND · trả cùng lương tháng 9';

  @override
  String get monthlyBonusStat => 'Thưởng tháng';

  @override
  String get kpiBonusStat => 'Thưởng KPI';

  @override
  String get yearTotalBonusStat => 'Tổng năm 2026';

  @override
  String get internalRecognitionStat => 'Ghi nhận nội bộ';

  @override
  String get whyReceivedBonus => 'Vì sao bạn nhận thưởng';

  @override
  String get bonusHistoryTitle => 'Lịch sử thưởng';

  @override
  String get internalRecruitmentTitle => 'Tuyển dụng nội bộ';

  @override
  String get searchJobPlaceholder => 'Tìm vị trí, bộ phận...';

  @override
  String openPositionsCount(int count) {
    return '$count vị trí mở cho ứng viên nội bộ';
  }

  @override
  String get tagNew => 'MỚI';

  @override
  String get jobDetailTitle => 'Chi tiết vị trí';

  @override
  String get applyButton => 'Ứng tuyển';

  @override
  String get jobDescriptionSection => 'Mô tả công việc';

  @override
  String get jobRequirementsSection => 'Yêu cầu';

  @override
  String get jobBenefitsSection => 'Phúc lợi';

  @override
  String get applySuccessTitle => 'Ứng tuyển thành công!';

  @override
  String get applySuccessMsg =>
      'Hồ sơ nội bộ của bạn đã được chuyển tới Bộ phận Nhân sự & Quản lý tuyển dụng.';

  @override
  String get emptyDataMessage => 'Hiện chưa có dữ liệu nào để hiển thị';

  @override
  String get errorOccurredTitle => 'Đã xảy ra sự cố';

  @override
  String get errorOccurredMessage =>
      'Không thể tải dữ liệu lúc này. Vui lòng kiểm tra lại kết nối mạng.';

  @override
  String get successDialogTitle => 'Thao tác thành công!';

  @override
  String get successDialogMessage =>
      'Yêu cầu của bạn đã được ghi nhận và chuyển cho cấp trên xử lý.';

  @override
  String get doneButton => 'Xong';

  @override
  String get filterAll => 'Tất cả';

  @override
  String get forgotPasswordShort => 'Quên mật khẩu?';

  @override
  String get forgotPasswordTitle => 'Quên mật khẩu?';

  @override
  String get forgotPasswordSubtitle =>
      'Vì lý do bảo mật, mật khẩu chỉ được cấp lại bởi bộ phận IT. Vui lòng liên hệ IT và cung cấp mã nhân viên để được hỗ trợ.';

  @override
  String get itHotlineLabel => 'Tổng đài IT · máy lẻ 1234';

  @override
  String get itHotlineNumber => '028 3930 1234';

  @override
  String get itEmailLabel => 'Email';

  @override
  String get itEmailValue => 'it.helpdesk@vstech.vn';

  @override
  String get itSupportHoursLabel => 'Giờ hỗ trợ';

  @override
  String get itSupportHoursValue => 'T2 – T7 · 07:30 – 18:00';

  @override
  String get itSecurityDisclaimer =>
      'IT sẽ xác minh danh tính qua quản lý trực tiếp trước khi cấp mật khẩu tạm. Đổi mật khẩu ngay sau lần đăng nhập đầu tiên.';

  @override
  String get callItDepartmentBtn => 'Gọi bộ phận IT';

  @override
  String get backToLoginBtn => 'Quay lại đăng nhập';

  @override
  String get loginWithFaceId => 'Đăng nhập bằng Face ID';

  @override
  String get loginWithFingerprint => 'Đăng nhập bằng vân tay';

  @override
  String get faceIdAuthReason => 'Xác thực Face ID để đăng nhập';

  @override
  String get fingerprintAuthReason => 'Quét vân tay để đăng nhập';

  @override
  String get orDivider => 'hoặc';

  @override
  String get faceIdLoginTitle => 'Đăng nhập bằng Face ID';

  @override
  String get faceIdLoginSubtitle => 'Nhận diện khuôn mặt bảo mật thông minh';

  @override
  String get faceDetecting => 'Đang nhận diện khuôn mặt...';

  @override
  String get faceAligning => 'Đang căn chỉnh góc mặt...';

  @override
  String get faceMatching => 'Đối soát dữ liệu sinh trắc học...';

  @override
  String faceAuthSuccessGreeting(String name) {
    return 'Nhận diện thành công! Chào $name';
  }

  @override
  String get systemBiometricAuthButton => 'Xác thực vân tay / Face ID hệ thống';

  @override
  String get loginWithCredentialsButton =>
      'Đăng nhập bằng mã nhân viên / mật khẩu';

  @override
  String get biometricAuthReason =>
      'Xác thực sinh trắc học để đăng nhập vào vstech-hrm';

  @override
  String get punchSuccessTitle => 'Chấm công thành công!';

  @override
  String get checkInRecorded => 'Ghi nhận Giờ vào (Check-in)';

  @override
  String get checkOutRecorded => 'Ghi nhận Giờ ra (Check-out)';

  @override
  String get timeLabel => 'Thời gian';

  @override
  String get classificationLabel => 'Phân loại';

  @override
  String get locationLabel => 'Địa điểm';

  @override
  String get methodLabel => 'Phương thức';

  @override
  String get methodFaceGps => 'Nhận diện khuôn mặt + GPS';

  @override
  String get completeAndHomeCta => 'Hoàn tất & Về trang chủ';

  @override
  String get dailyLogSectionTitle => 'Nhật ký từng ngày';

  @override
  String get holidaysLink => 'Ngày lễ';

  @override
  String get statusWorking => 'Đang làm';

  @override
  String get statusMissingCheckOut => 'Thiếu giờ ra';

  @override
  String get statusFullWork => 'Đủ công';

  @override
  String get statusWeeklyOff => 'Nghỉ tuần';

  @override
  String statusFullWorkOt(String hours) {
    return 'Đủ công · TC ${hours}h';
  }

  @override
  String statusLateMinutes(String minutes) {
    return 'Đi muộn $minutes phút';
  }

  @override
  String get noShiftAssigned => 'Không có ca';

  @override
  String get monthlyWorkdaysUnit => 'ngày công';

  @override
  String daysCountUnit(int count) {
    return '$count ngày';
  }

  @override
  String get faceScanSuccessTitle => 'Xác thực thành công!';

  @override
  String get faceScanSuccessSubtitle =>
      'Hệ thống đã lưu nhận diện khuôn mặt và vị trí';

  @override
  String get faceScanningTitle => 'Đang nhận diện...';

  @override
  String get faceScanningSubtitle =>
      'Đang gửi ảnh quét mặt và toạ độ GPS về máy chủ';

  @override
  String get faceAlignPromptTitle => 'Căn chỉnh khuôn mặt';

  @override
  String get faceAlignPromptSubtitle =>
      'Giữ thẳng đầu và nhìn trực diện vào camera';

  @override
  String get emergencyContactInfo =>
      'Liên hệ khẩn cấp: 0908 221 470 (Người thân)';

  @override
  String get documentsAndRecordsInfo => 'Hồ sơ nhân viên & Hợp đồng lao động';

  @override
  String get annualLeaveCardTitle => 'Số phép năm';

  @override
  String leaveRatio(String used, String total) {
    return '$used / $total ngày';
  }

  @override
  String usedDaysCount(String count) {
    return 'Đã dùng $count';
  }

  @override
  String remainingDaysCount(String count) {
    return 'Còn lại $count';
  }

  @override
  String get announcementsSubtitle =>
      'Thông tin chính thức từ HR & Ban Giám Đốc';

  @override
  String get announcementScopeAll => 'Tất cả';

  @override
  String get announcementScopeCompany => 'Toàn công ty';

  @override
  String get announcementScopeOffice => 'Khối văn phòng';

  @override
  String get announcementScopeFactory => 'Phân xưởng & Tổ';

  @override
  String get announcementScopeDept => 'Phòng ban';

  @override
  String announcementTargetScope(String scope) {
    return 'Phạm vi: $scope';
  }

  @override
  String announcementAuthor(String author) {
    return 'Người gửi: $author';
  }

  @override
  String announcementPublishDate(String date) {
    return 'Đăng lúc: $date';
  }

  @override
  String get announcementUnreadBadge => 'MỚI';

  @override
  String get announcementMarkAllRead => 'Đã đọc tất cả';

  @override
  String get announcementEmpty => 'Chưa có thông báo nào trong mục này';

  @override
  String get announcementDetailTitle => 'Chi tiết thông báo';

  @override
  String get announcementReadConfirmed => 'Đã đánh dấu đã đọc';

  @override
  String get laborProfileTitle => 'Hồ sơ lao động & Hợp đồng';

  @override
  String get contractSectionTitle => 'Hợp đồng lao động & Phụ lục';

  @override
  String get contractNumberLabel => 'Số hợp đồng';

  @override
  String get contractTypeLabel => 'Loại hợp đồng';

  @override
  String get contractSigningDateLabel => 'Ngày ký';

  @override
  String get contractEffectiveDateLabel => 'Ngày hiệu lực';

  @override
  String get contractExpirationDateLabel => 'Ngày hết hạn';

  @override
  String get contractStatusLabel => 'Tình trạng HĐ';

  @override
  String get contractStatusActive => 'Đang có hiệu lực';

  @override
  String get salaryAndBenefitsSection => 'Mức lương & Chế độ thoả thuận';

  @override
  String get agreedBaseSalary => 'Lương cơ bản thoả thuận';

  @override
  String get responsibilityAllowance => 'Phụ cấp trách nhiệm';

  @override
  String get mealAllowance => 'Phụ cấp cơm trưa';

  @override
  String get overtimeRateDescription =>
      'Hệ số tăng ca: 150% (ngày thường), 200% (nghỉ tuần), 300% (lễ tết)';

  @override
  String get socialInsuranceSection => 'Bảo hiểm xã hội & Y tế';

  @override
  String get socialInsuranceNumber => 'Mã số BHXH';

  @override
  String get hospitalRegistered => 'Nơi đăng ký KCB ban đầu';

  @override
  String get insuranceSalaryLevel => 'Mức lương đóng BHXH';

  @override
  String get insuranceStatus => 'Trạng thái sổ BHXH';

  @override
  String get insuranceStatusActive => 'Đang đóng đầy đủ';

  @override
  String get contractAttachmentsSection => 'Tệp đính kèm & Bản scan HĐLĐ';

  @override
  String get downloadAttachmentButton => 'Tải về';

  @override
  String get previewAttachmentButton => 'Xem trước';

  @override
  String get laborProfileHrNotice =>
      'Thông tin hợp đồng và chế độ lao động do Phòng Nhân sự quản lý. Người lao động không thể tự chỉnh sửa trên ứng dụng di động. Mọi thắc mắc xin liên hệ HR.';

  @override
  String get offlineQueueTitle => 'Hàng đợi chấm công ngoại tuyến';

  @override
  String get offlineQueueSubtitle =>
      'Dữ liệu chấm công lưu trên máy khi mất mạng';

  @override
  String get statusRecorded => 'Đã ghi nhận';

  @override
  String get statusPendingSync => 'Chờ đồng bộ';

  @override
  String get statusSyncing => 'Đang đồng bộ...';

  @override
  String get statusSynced => 'Đã đồng bộ';

  @override
  String get statusSyncFailed => 'Đồng bộ thất bại';

  @override
  String get syncAllButton => 'Đồng bộ tất cả';

  @override
  String get syncRetryButton => 'Thử lại';

  @override
  String persistentQueueWarning(int count) {
    return 'CẢNH BÁO: Còn $count lượt chấm công chưa gửi lên máy chủ! Hãy đồng bộ để không bị mất công.';
  }

  @override
  String get factoryRemindersTitle => 'Nhắc nhở ca kíp nhà máy';

  @override
  String get factoryRemindersSubtitle =>
      'Nhắc nhở giờ vào ca & ăn trưa (do không được mang điện thoại vào xưởng)';

  @override
  String get reminderMorningShift => 'Vào ca sáng (07:45)';

  @override
  String get reminderLunchBreak => 'Nghỉ ăn trưa (11:45)';

  @override
  String get reminderAfternoonShift => 'Vào ca chiều (12:45)';

  @override
  String get reminderShiftEnd => 'Tan ca về (17:00)';

  @override
  String get reminderSavedSuccess =>
      'Đã lưu cài đặt nhắc nhở ca kíp thành công!';

  @override
  String geofenceDistanceLabel(int meters) {
    return 'Khoảng cách toạ độ: ${meters}m so với tâm nhà máy';
  }

  @override
  String get geofenceWithinRange => 'Trong bán kính hợp lệ (≤ 50m)';

  @override
  String get geofenceOutOfRange => 'Ngoài bán kính nhà máy (> 50m)';

  @override
  String get checkInGpsSuccess => 'Đã ghi nhận Check-in GPS thành công!';

  @override
  String get checkOutGpsSuccess => 'Đã ghi nhận Check-out GPS thành công!';

  @override
  String get qrScannerTitle => 'Quét mã QR đăng nhập';

  @override
  String get qrScannerSubtitle =>
      'Hướng camera vào mã QR trên màn hình Cổng thông tin Web';

  @override
  String get qrTorchToggle => 'Bật/Tắt đèn Flash';

  @override
  String get qrSamplePayloadsButton => 'Mã QR mẫu để thử nghiệm';

  @override
  String get qrConfirmTitle => 'Xác nhận đăng nhập Web';

  @override
  String get qrConfirmPrompt =>
      'Bạn có đang đăng nhập vào Cổng thông tin VSTech không?';

  @override
  String get qrBrowserLabel => 'Trình duyệt';

  @override
  String get qrDeviceLabel => 'Thiết bị / Máy tính trạm';

  @override
  String get qrLocationLabel => 'Vị trí đăng nhập';

  @override
  String get qrRequestTimeLabel => 'Thời gian yêu cầu';

  @override
  String get qrIpAddressLabel => 'Địa chỉ IP';

  @override
  String get qrApproveButton => 'Xác nhận đăng nhập';

  @override
  String get qrRejectButton => 'Từ chối';

  @override
  String get qrBiometricPromptReason =>
      'Xác thực sinh trắc học để phê duyệt đăng nhập trên Web';

  @override
  String get qrLoginApprovedSuccess =>
      'Đăng nhập thành công! Phiên làm việc trên máy tính đã được kích hoạt.';

  @override
  String get qrLoginRejectedMsg => 'Bạn đã từ chối yêu cầu đăng nhập này.';

  @override
  String get qrExpiredWarning =>
      'Mã QR này đã hết hạn. Vui lòng làm mới trang web để lấy mã mới.';

  @override
  String get qrInvalidWarning =>
      'Mã QR không hợp lệ hoặc không thuộc hệ thống VSTech.';

  @override
  String get qrUsedWarning => 'Mã QR này đã được sử dụng trước đó.';

  @override
  String get qrCancelledWarning =>
      'Yêu cầu đăng nhập này đã bị huỷ bởi máy tính trạm.';

  @override
  String get execDashboardTitle => 'Bảng điều hành Ban Giám Đốc';

  @override
  String get execRoleTag => 'TỔNG GIÁM ĐỐC / CEO';

  @override
  String get execGreeting => 'Chào anh Lê Hoàng';

  @override
  String get execWaitingBadge => 'ĐƠN CHỜ PHÊ DUYỆT CUỐI';

  @override
  String get execWaitingSub => 'Cần ý kiến phê duyệt của Giám đốc';

  @override
  String get execOldestWaiting => 'Đơn cũ nhất: 18h trước';

  @override
  String get execCompanyNow => 'TÌNH HÌNH DOANH NGHIỆP HÔM NAY';

  @override
  String get execHeadcount => 'Tổng nhân sự';

  @override
  String get execAttendanceRate => 'Tỷ lệ đi làm';

  @override
  String get execMonthlyPayroll => 'Quỹ lương tháng';

  @override
  String get execOvertimeHours => 'Giờ tăng ca tháng';

  @override
  String get execTurnoverRate => 'Tỷ lệ nghỉ việc';

  @override
  String get execNeedAttention => 'Rủi ro & Tuân thủ cần chú ý';

  @override
  String get execSeeAllAlerts => 'Xem tất cả cảnh báo';

  @override
  String get execAttendanceByDept => 'Tỷ lệ đi làm theo khối/xưởng';

  @override
  String get finalApprovalTitle => 'Phê duyệt cuối';

  @override
  String get finalApprovalCaption =>
      'Cấp thẩm quyền cao nhất · Chu trình kết thúc';

  @override
  String get finalApprovalDelegateBtn => 'Ủy quyền';

  @override
  String get finalApprovalBatchHint =>
      'Phê duyệt nhanh các đơn đã qua kiểm tra của HR & Kế toán';

  @override
  String get finalApprovalApproveAll => 'Duyệt tất cả';

  @override
  String get finalApprovalFinancialImpact => 'TÁC ĐỘNG TÀI CHÍNH';

  @override
  String get finalApprovalBudget => 'NGÂN SÁCH DỰ PHÒNG';

  @override
  String get finalApprovalApproveBtn => 'Phê duyệt cuối';

  @override
  String get finalApprovalRejectBtn => 'Từ chối';

  @override
  String get finalApprovalSuccess =>
      'Đã phê duyệt cuối thành công. HR sẽ tiến hành thực thi.';

  @override
  String get finalApprovalRejected => 'Đã từ chối đơn đề xuất.';

  @override
  String get riskTitle => 'Cảnh báo Rủi ro & Tuân thủ';

  @override
  String get riskCaption =>
      'Cảnh báo qua 3 phân tầng · Giao việc trực tiếp cho HR';

  @override
  String get riskTierCritical => 'Nghiêm trọng';

  @override
  String get riskTierHigh => 'Cảnh báo cao';

  @override
  String get riskTierMedium => 'Theo dõi';

  @override
  String get riskAssignHr => 'Giao việc cho HR';

  @override
  String get riskAssignedSuccess => 'Đã giao việc cho bộ phận HR xử lý!';

  @override
  String get delTitle => 'Trung tâm Ủy quyền';

  @override
  String get delCaption =>
      'Chuyển giao quyền phê duyệt khi vắng mặt hoặc đi công tác';

  @override
  String get delSelectPerson => 'Người nhận ủy quyền';

  @override
  String get delPeriod => 'Thời gian ủy quyền';

  @override
  String get delFromDate => 'Từ ngày';

  @override
  String get delToDate => 'Đến ngày';

  @override
  String get delTotalDays => 'Tổng cộng';

  @override
  String get delScope => 'Phạm vi thẩm quyền';

  @override
  String get delAllScope => 'Toàn bộ thẩm quyền';

  @override
  String get delPartialScope => 'Theo từng loại đơn';

  @override
  String get delLimit => 'Hạn mức duyệt tối đa';

  @override
  String get delLimitHint =>
      'Các đơn vượt hạn mức này vẫn sẽ chuyển trực tiếp cho bạn khi online';

  @override
  String get delUnlimited => 'Không giới hạn';

  @override
  String get delSubmit => 'Xác nhận thiết lập ủy quyền';

  @override
  String get delActiveList => 'Ủy quyền đang hiệu lực';

  @override
  String get delRevoke => 'Hủy ủy quyền';

  @override
  String get delRevokeSuccess => 'Đã hủy ủy quyền thành công!';

  @override
  String get delCreateSuccess => 'Thiết lập ủy quyền phê duyệt thành công!';

  @override
  String get delRunning => 'Đang chạy';

  @override
  String get requestTypeOnDuty => 'Đi việc ngoài';

  @override
  String get requestTypeBusinessTrip => 'Công tác';

  @override
  String get requestTypeShiftSwap => 'Đổi ca';

  @override
  String get onDutyTitle => 'Đăng ký Đi việc ngoài';

  @override
  String get onDutySubtitle =>
      'Công tác ngắn hạn trong ngày (gặp khách hàng, cơ quan, việc gấp)';

  @override
  String get onDutyFromTime => 'Từ giờ';

  @override
  String get onDutyToTime => 'Đến giờ';

  @override
  String get onDutyLocation => 'Địa điểm đến';

  @override
  String get onDutyDescription => 'Nội dung công việc';

  @override
  String get onDutyShiftConstraintWarning =>
      'Giờ đi việc ngoài phải nằm trong ca làm việc hôm nay';

  @override
  String get onDutySubmitSuccess => 'Đã gửi đơn Đi việc ngoài thành công!';

  @override
  String get businessTripTitle => 'Đăng ký Công tác';

  @override
  String get businessTripSubtitle =>
      'Chuyến công tác nhiều ngày trong nước hoặc nước ngoài';

  @override
  String get businessTripDestination => 'Nơi đến / Địa điểm';

  @override
  String get businessTripColleagues => 'Đồng nghiệp cùng đi';

  @override
  String get businessTripPurpose => 'Mục đích công tác';

  @override
  String get businessTripPlan => 'Kế hoạch / Lịch trình';

  @override
  String get businessTripSubmitSuccess => 'Đã gửi đơn Công tác thành công!';

  @override
  String get offSiteTimesheetLabel => 'Công tác';

  @override
  String get offSiteCreditDesc =>
      'Đã ghi nhận đủ công (không tính muộn/về sớm)';

  @override
  String get leaveBalanceBreakdownTitle => 'Chi tiết quỹ nghỉ phép';

  @override
  String get leaveTypeCompOff => 'Nghỉ bù (từ tăng ca)';

  @override
  String get leaveTypeMaternity => 'Nghỉ thai sản';

  @override
  String get leaveTypePaidPersonal => 'Việc riêng có lương';

  @override
  String get leaveBalanceEntitlement => 'Tiêu chuẩn';

  @override
  String get leaveBalanceUsed => 'Đã dùng';

  @override
  String get leaveBalancePending => 'Đang chờ duyệt';

  @override
  String get leaveBalanceAvailable => 'Khả dụng';

  @override
  String get leaveHalfDayMorning => 'Nửa ca sáng';

  @override
  String get leaveHalfDayAfternoon => 'Nửa ca chiều';

  @override
  String get leaveHandoverPerson => 'Người bàn giao / thay thế';

  @override
  String get leaveAttachment => 'Giấy tờ / Chứng từ đính kèm';

  @override
  String leaveExceedBalanceWarning(String days) {
    return 'Số ngày nghỉ vượt quá số phép khả dụng ($days ngày)!';
  }

  @override
  String get leaveExcludeWeekendHint =>
      'Đã tự động trừ ngày nghỉ cuối tuần và ngày lễ';

  @override
  String get leaveSaveDraftBtn => 'Lưu nháp';

  @override
  String get leaveDraftSaved => 'Đã lưu bản nháp thành công!';

  @override
  String get otRateWeekday => 'Ngày thường (150%)';

  @override
  String get otRateWeekend => 'Nghỉ tuần (200%)';

  @override
  String get otRateHoliday => 'Ngày lễ (300%)';

  @override
  String get otCompensationType => 'Hình thức tính bù';

  @override
  String get otCompensationPay => 'Hưởng tiền lương tăng ca';

  @override
  String get otCompensationCompOff => 'Quy đổi nghỉ bù (Comp-off)';

  @override
  String otMonthlyCapWarning(String current) {
    return 'Chú ý: Bạn đã tích lũy ${current}h/40h trần tăng ca tháng này';
  }

  @override
  String get otMonthlyCapExceeded =>
      'Không thể gửi đơn: Tổng giờ tăng ca vượt quá 40h/tháng theo BLLĐ 2019!';

  @override
  String otMonthlyApprovedHeader(String hours) {
    return 'Tổng giờ tăng ca đã duyệt: ${hours}h';
  }

  @override
  String get extraHoursBalanceTitle => 'Quỹ giờ làm thêm & Nghỉ bù';

  @override
  String get extraHoursMonth => 'Giờ OT tháng này';

  @override
  String get extraHoursQuarter => 'Giờ OT quý này';

  @override
  String get extraHoursPayable => 'Giờ hưởng lương';

  @override
  String get extraHoursConvertedCompOff => 'Giờ đã đổi nghỉ bù';

  @override
  String get compOffConversionRule => 'Quy đổi: 8 giờ tăng ca = 1 ngày nghỉ bù';

  @override
  String get shiftSwapEligibilityCheck => 'Kiểm tra điều kiện đổi ca';

  @override
  String shiftSwapBranchMismatch(String branch) {
    return 'Đồng nghiệp khác chi nhánh ($branch)';
  }

  @override
  String get shiftSwapGradeMismatch => 'Cấp bậc công việc không tương đương';

  @override
  String get shiftSwapOnLeaveConflict =>
      'Đồng nghiệp đang nghỉ phép vào ngày này';

  @override
  String get shiftSwapSameShiftConflict =>
      'Hai người đang cùng một ca làm việc';

  @override
  String get shiftSwapRestConflict =>
      'Khoảng cách giữa hai ca < 12 giờ (Điều 109 BLLĐ 2019)';

  @override
  String get shiftSwapOvertimeExceed => 'Tổng giờ tuần sẽ vượt quá 48 giờ';

  @override
  String get shiftSwapConflictAlert => 'Không đủ điều kiện đổi ca';

  @override
  String get shiftSwapApprovedTag => 'Đã đổi ca';

  @override
  String get shiftMonthUnpublished =>
      'Lịch tháng sau sẽ được công bố vào ngày 25';

  @override
  String get shiftNetworkRetry => 'Thử lại kết nối';

  @override
  String get registeredDeviceTitle => 'Thiết bị đã đăng ký';

  @override
  String get registeredDeviceSub =>
      'Chỉ chấm công trên thiết bị định danh duy nhất của bạn';

  @override
  String get deviceModelLabel => 'Dòng máy / Thiết bị';

  @override
  String get deviceIdLabel => 'Mã định danh (UUID)';

  @override
  String get deviceRegisteredDate => 'Ngày đăng ký';

  @override
  String get deviceCheckRegistered => 'Thiết bị chính chủ hợp lệ';

  @override
  String get deviceCheckNotRooted => 'Không phát hiện Root / Jailbreak';

  @override
  String get deviceCheckNoMockGps => 'Không dùng định vị giả (Mock GPS)';

  @override
  String get deviceCheckIntegrity => 'Tính toàn vẹn ứng dụng chuẩn';

  @override
  String get deviceBlockRootTitle => 'Thiết bị đã bị can thiệp (Root)';

  @override
  String get deviceBlockRootMsg =>
      'Vì lý do an toàn, tài khoản không thể chấm công trên thiết bị đã can thiệp hệ điều hành. Vui lòng liên hệ HR.';

  @override
  String get deviceBlockMockGpsTitle => 'Phát hiện vị trí giả lập (Mock GPS)';

  @override
  String get deviceBlockMockGpsMsg =>
      'Hệ thống phát hiện bạn đang bật ứng dụng giả lập toạ độ. Vui lòng tắt ứng dụng giả lập vị trí và bấm \'Kiểm tra lại\'.';

  @override
  String get deviceRecheckBtn => 'Kiểm tra lại';

  @override
  String get deviceDemoTogglesTitle => 'Mô phỏng vi phạm (Demo Sandbox)';

  @override
  String get deviceSimulateMockGps => 'Mô phỏng phát hiện Mock GPS';

  @override
  String get deviceSimulateRoot => 'Mô phỏng thiết bị Root';

  @override
  String get punchResultOnTime => 'Đúng giờ';

  @override
  String get punchResultLate => 'Đi muộn';

  @override
  String get punchResultEarly => 'Về sớm';

  @override
  String get punchLateReasonPrompt => 'Lý do đi muộn / về sớm';

  @override
  String get faceThumbnailLabel => 'Ảnh chụp đối chiếu AI';

  @override
  String get approvalTypeFilterAll => 'Tất cả';

  @override
  String get approvalTypeFilterLeave => 'Nghỉ phép';

  @override
  String get approvalTypeFilterOT => 'Tăng ca';

  @override
  String get approvalTypeFilterCorrection => 'Sửa công';

  @override
  String get approvalTypeFilterSwap => 'Đổi ca';

  @override
  String get approvalTypeFilterOffSite => 'Đi việc ngoài';

  @override
  String get approvalAttendanceSnippet => 'Chấm công ngày liên quan';

  @override
  String get approvalSwapBothSchedules => 'Lịch làm việc hai nhân viên';

  @override
  String get approvalInternalNoteLabel => 'Ghi chú nội bộ (chỉ quản lý thấy)';

  @override
  String get approvalMandatoryRejectReason =>
      'Vui lòng nhập lý do từ chối (bắt buộc)';

  @override
  String get legendLateEarly => 'Đi muộn / Về sớm';

  @override
  String get dateLabel => 'Ngày';

  @override
  String get fillRequiredField => 'Vui lòng nhập thông tin này';

  @override
  String get submitButton => 'Gửi yêu cầu';

  @override
  String annualLeaveRemaining(String days) {
    return 'Còn $days ngày';
  }

  @override
  String availableDays(String days) {
    return '$days ngày khả dụng';
  }

  @override
  String get attendanceTitle => 'Chấm công';

  @override
  String get loadingState => 'Đang tải dữ liệu...';

  @override
  String get errorStateTitle => 'Không thể tải dữ liệu';

  @override
  String get networkError => 'Lỗi kết nối mạng, vui lòng thử lại';

  @override
  String get currentMonthSchedule => 'Lịch ca tháng này';

  @override
  String get deviceGpsRecheckedValid =>
      'Đang kiểm tra lại toạ độ GPS... Hợp lệ!';

  @override
  String get deviceContactHrSent =>
      'Đã gửi yêu cầu hỗ trợ kiểm tra thiết bị tới HR.';

  @override
  String get deviceContactHrBtn => 'Liên hệ phòng Nhân sự (HR)';

  @override
  String get deviceTestBlockCta => 'Thử nghiệm Chặn Chấm công (Demo)';

  @override
  String get deviceCheckSafetyBtn => 'Kiểm tra an toàn';

  @override
  String get requestDetailTitle => 'Chi tiết yêu cầu';

  @override
  String get requestCodeLabel => 'Mã yêu cầu';

  @override
  String get requesterLabel => 'Người gửi';

  @override
  String get cancelRequestBtn => 'Hủy yêu cầu';

  @override
  String get cancelRequestConfirm => 'Bạn có chắc chắn muốn hủy yêu cầu này?';

  @override
  String get requestCancelledSuccess => 'Yêu cầu đã được hủy thành công';

  @override
  String get internalNoteHint =>
      'Nhập ghi chú nội bộ (chỉ người duyệt thấy)...';

  @override
  String get approveRequestConfirm => 'Xác nhận phê duyệt yêu cầu này?';

  @override
  String get rejectRequestConfirm => 'Xác nhận từ chối yêu cầu?';

  @override
  String get approvalTimelineTitle => 'Tiến trình phê duyệt (4 cấp)';

  @override
  String get submittedFieldsTitle => 'Thông tin chi tiết';

  @override
  String get attachedFilesTitle => 'Tệp đính kèm & Minh chứng';

  @override
  String get shiftComparisonTitle => 'So sánh ca làm việc hai nhân viên';

  @override
  String get attendanceLogComparisonTitle => 'Đối chiếu giờ quẹt thẻ thực tế';

  @override
  String get disputeComparisonTitle => 'Đối chiếu khoản mục khiếu nại';

  @override
  String get disputedAmountDiff => 'Mức chênh lệch';

  @override
  String get leaveManageTitle => 'Quản lý Nghỉ phép';

  @override
  String get annualLeaveHeroTitle => 'Quỹ phép năm 2026';

  @override
  String get leaveStatusFilterAll => 'Tất cả';

  @override
  String get leaveStatusFilterPending => 'Chờ duyệt';

  @override
  String get leaveStatusFilterApproved => 'Đã duyệt';

  @override
  String get leaveStatusFilterRejected => 'Từ chối';

  @override
  String get createLeaveBtn => 'Tạo đơn nghỉ phép';

  @override
  String get overtimeManageTitle => 'Quản lý Tăng ca';

  @override
  String get totalOvertimeHours => 'Tổng giờ tăng ca';

  @override
  String get rateNormal150 => 'Ngày thường 150%';

  @override
  String get rateWeekend200 => 'Cuối tuần 200%';

  @override
  String get rateHoliday300 => 'Ngày lễ 300%';

  @override
  String get createOvertimeBtn => 'Đăng ký tăng ca';

  @override
  String get correctionManageTitle => 'Quản lý Sửa công';

  @override
  String get correctionQuotaTitle => 'Hạn mức sửa công tháng này';

  @override
  String correctionQuotaUsage(String used, String total) {
    return 'Đã dùng $used/$total lần';
  }

  @override
  String get missingPunchesSectionTitle => 'Ngày thiếu chấm công cần xử lý';

  @override
  String get fixPunchBtn => 'Sửa công ngay';

  @override
  String get noMissingPunches => 'Không có ngày nào bị thiếu chấm công';

  @override
  String get shiftSwapsManageTitle => 'Quản lý Đổi ca';

  @override
  String get swapsSentTab => 'Đơn gửi đi';

  @override
  String get swapsReceivedTab => 'Đơn nhận được';

  @override
  String get colleagueLabel => 'Đồng nghiệp đổi ca';

  @override
  String get swapStatusPending => 'Chờ duyệt';

  @override
  String get swapStatusApproved => 'Đã đổi ca';

  @override
  String get swapStatusRejected => 'Từ chối';

  @override
  String get requestSentTitle => 'Gửi thành công';

  @override
  String get requestSentSuccess => 'Yêu cầu của bạn đã được gửi thành công!';

  @override
  String requestAssignedTo(String name) {
    return 'Người tiếp nhận: $name';
  }

  @override
  String get backToListBtn => 'Về danh sách';

  @override
  String get viewRequestDetailBtn => 'Xem chi tiết yêu cầu';

  @override
  String get payslipLockTitle => 'Xác thực bảo mật';

  @override
  String get payslipLockSubtitle =>
      'Nhập mã PIN 6 số hoặc xác thực sinh trắc học để xem phiếu lương';

  @override
  String payslipLockWrongPin(String remaining) {
    return 'Mã PIN không chính xác. Còn lại $remaining lần thử';
  }

  @override
  String get payslipLockLocked =>
      'Đã khóa tạm thời trong 30 giây do nhập sai nhiều lần';

  @override
  String get payslipLockBiometricPrompt => 'Xác thực để mở khóa phiếu lương';

  @override
  String get payslipLockForgotPin => 'Quên mã PIN?';

  @override
  String get useBiometricsBtn => 'Dùng sinh trắc học';

  @override
  String get signPayslipBtn => 'Ký xác nhận phiếu lương';

  @override
  String get signPadTitle => 'Ký xác nhận điện tử';

  @override
  String get signPadSubtitle => 'Vui lòng ký tên của bạn vào khung bên dưới';

  @override
  String get signPadClear => 'Xóa chữ ký';

  @override
  String get signPadConfirm => 'Xác nhận ký';

  @override
  String get signPadDisclaimer =>
      'Tôi xác nhận đã kiểm tra kỹ các thông tin thu nhập, khấu trừ và công chuẩn theo Bộ luật Lao động.';

  @override
  String get signPadEmptyAlert => 'Vui lòng ký tên trước khi xác nhận';

  @override
  String get payslipSignedBadge => 'Đã ký điện tử';

  @override
  String payslipSignedAt(String time) {
    return 'Thời gian ký: $time';
  }

  @override
  String payslipSignedHash(String hash) {
    return 'Mã băm xác thực: $hash';
  }

  @override
  String payslipSignedSigner(String name) {
    return 'Người ký: $name';
  }

  @override
  String get disputePayslipBtn => 'Khiếu nại bảng lương';

  @override
  String get disputeLineBtn => 'Khiếu nại dòng này';

  @override
  String get disputeManageTitle => 'Quản lý Khiếu nại lương';

  @override
  String get disputeNewTitle => 'Tạo khiếu nại lương';

  @override
  String get disputeMonthLabel => 'Tháng khiếu nại';

  @override
  String get disputeItemLabel => 'Khoản mục sai lệch';

  @override
  String get disputeCurrentAmountLabel => 'Số tiền trên phiếu lương (₫)';

  @override
  String get disputeExpectedAmountLabel => 'Số tiền đề xuất đúng (₫)';

  @override
  String get disputeDifferenceLabel => 'Chênh lệch đề xuất';

  @override
  String get disputeReasonLabel => 'Lý do & giải trình chi tiết';

  @override
  String get disputeReasonHint =>
      'Nêu rõ nguyên nhân chênh lệch, ngày phát sinh, ca làm việc...';

  @override
  String get disputeAttachmentLabel =>
      'Minh chứng (bảng công, ảnh chụp phân ca...)';

  @override
  String get submitDisputeBtn => 'Gửi khiếu nại';

  @override
  String get disputeCreatedSuccess => 'Đã gửi khiếu nại lương thành công';

  @override
  String get noDisputesFound => 'Không có khiếu nại nào';

  @override
  String get disputeStatusPending => 'Đang đối soát';

  @override
  String get disputeStatusApproved => 'Đã duyệt bù';

  @override
  String get disputeStatusRejected => 'Không chấp thuận';

  @override
  String get rewardsTabBonus => 'Thưởng';

  @override
  String get rewardsTabCommission => 'Hoa hồng';

  @override
  String get rewardsTabTargets => 'Chỉ tiêu';

  @override
  String commissionTotalTitle(String month) {
    return 'Tổng hoa hồng tháng $month';
  }

  @override
  String get commissionFilterDay => 'Ngày';

  @override
  String get commissionFilterWeek => 'Tuần';

  @override
  String get commissionFilterMonth => 'Tháng';

  @override
  String get commissionSourceDirect => 'Bán hàng trực tiếp';

  @override
  String get commissionSourceTeam => 'Doanh số nhóm';

  @override
  String get commissionSourceRenewal => 'Tái tục hợp đồng';

  @override
  String commissionContractsCount(int count) {
    return '$count giao dịch';
  }

  @override
  String get targetPersonalTitle => 'Chỉ tiêu cá nhân tháng này';

  @override
  String get targetTeamTitle => 'Chỉ tiêu đội nhóm chi nhánh';

  @override
  String get targetTiersTitle => 'Các mốc thưởng bậc thang';

  @override
  String get targetTierAchieved => 'Đã đạt mốc';

  @override
  String targetTierRemaining(String remaining) {
    return 'Còn thiếu $remaining';
  }

  @override
  String get targetTierNext => 'Mục tiêu kế tiếp';

  @override
  String get referCandidateBtn => 'Giới thiệu ứng viên';

  @override
  String get referralFormTitle => 'Giới thiệu ứng viên';

  @override
  String get candidateNameLabel => 'Họ và tên ứng viên';

  @override
  String get candidatePhoneLabel => 'Số điện thoại';

  @override
  String get candidateEmailLabel => 'Email liên hệ';

  @override
  String get candidatePositionLabel => 'Vị trí ứng tuyển';

  @override
  String get candidateBranchLabel => 'Chi nhánh mong muốn';

  @override
  String get candidateCvLabel => 'Tải lên CV (PDF, DOCX)';

  @override
  String candidateCvSelected(String fileName) {
    return 'Đã đính kèm CV: $fileName';
  }

  @override
  String get candidateDuplicateError =>
      'Ứng viên này đã có hồ sơ trong hệ thống trong vòng 6 tháng qua';

  @override
  String get submitReferralBtn => 'Gửi hồ sơ giới thiệu';

  @override
  String get referralSuccessTitle => 'Gửi giới thiệu thành công';

  @override
  String get referralSuccessMsg =>
      'Hồ sơ ứng viên đã được chuyển trực tiếp đến bộ phận Tuyển dụng';

  @override
  String get referralCodeLabel => 'Mã theo dõi giới thiệu';

  @override
  String get referralBonusNotice =>
      'Thưởng giới thiệu: 3.000.000 ₫ (khi ứng viên qua thử việc)';

  @override
  String get viewMyReferralsBtn => 'Xem ứng viên tôi đã giới thiệu';

  @override
  String get myReferralsTitle => 'Ứng viên tôi đã giới thiệu';

  @override
  String get myReferralLinkTitle => 'Link & Mã QR giới thiệu của bạn';

  @override
  String get copyLinkBtn => 'Sao chép link';

  @override
  String get shareQrBtn => 'Chia sẻ QR';

  @override
  String get linkCopiedSnackbar => 'Đã sao chép link giới thiệu vào clipboard';

  @override
  String get stageReceived => 'Tiếp nhận hồ sơ';

  @override
  String get stageInterview => 'Phỏng vấn';

  @override
  String get stageProbation => 'Thử việc';

  @override
  String get stageHired => 'Đã nhận việc & Thưởng';

  @override
  String get noReferralsFound => 'Chưa có ứng viên nào được giới thiệu';

  @override
  String get profileEditTitle => 'Chỉnh sửa hồ sơ';

  @override
  String get profileEditHeader => 'Thông tin cá nhân & Tài khoản';

  @override
  String get freeEditSection => 'Thông tin liên hệ (Cập nhật ngay)';

  @override
  String get sensitiveEditSection =>
      'Thông tin định danh & Ngân hàng (Cần HR duyệt)';

  @override
  String get sensitiveEditNotice =>
      'Các thay đổi về CCCD/Hộ chiếu và Tài khoản ngân hàng cần được phòng Nhân sự phê duyệt trước khi áp dụng chính thức.';

  @override
  String get phoneEditLabel => 'Số điện thoại';

  @override
  String get emailEditLabel => 'Email cá nhân';

  @override
  String get addressEditLabel => 'Địa chỉ hiện tại';

  @override
  String get emergencyNameLabel => 'Người liên hệ khẩn cấp';

  @override
  String get emergencyPhoneLabel => 'SĐT khẩn cấp';

  @override
  String get bankNameEditLabel => 'Ngân hàng thụ hưởng';

  @override
  String get bankAccountEditLabel => 'Số tài khoản';

  @override
  String get bankHolderEditLabel => 'Tên chủ tài khoản';

  @override
  String get cccdEditLabel => 'Số CCCD / Hộ chiếu';

  @override
  String get cccdIssueDateLabel => 'Ngày cấp';

  @override
  String get cccdIssuePlaceLabel => 'Nơi cấp';

  @override
  String get permanentAddressLabel => 'Địa chỉ thường trú (theo CCCD)';

  @override
  String get saveChangesBtn => 'Lưu thay đổi';

  @override
  String get profileEditSuccess => 'Đã cập nhật thông tin thành công';

  @override
  String profilePendingHrAlert(String code) {
    return 'Yêu cầu thay đổi thông tin định danh/ngân hàng đã được gửi đến HR (Mã: $code)';
  }

  @override
  String get statusPendingHr => 'Chờ HR duyệt';

  @override
  String get documentManagementTitle => 'Tài liệu & Hồ sơ';

  @override
  String get expiringDocAlertTitle => 'Cảnh báo giấy tờ sắp hết hạn';

  @override
  String expiringDocAlertMsg(int days, String date) {
    return 'Giấy khám sức khỏe định kỳ sẽ hết hạn sau $days ngày ($date). Vui lòng cập nhật minh chứng mới.';
  }

  @override
  String get legalDocSectionTitle => 'Hồ sơ pháp lý & Bằng cấp';

  @override
  String get viewContractBtn => 'Xem hợp đồng';

  @override
  String get contractViewerTitle => 'Hợp đồng lao động điện tử';

  @override
  String contractWatermark(String employeeCode, String name, String date) {
    return 'BẢN SAO ĐIỆN TỬ - $employeeCode - $name - $date';
  }

  @override
  String get uploadNewDocBtn => 'Tải lên tài liệu mới';

  @override
  String get downloadDocBtn => 'Tải về PDF';

  @override
  String get dependantsManageTitle => 'Người phụ thuộc';

  @override
  String get dependantsTaxReliefTitle => 'Giảm trừ gia cảnh (TNCN)';

  @override
  String dependantsCountLabel(int count) {
    return 'Số người phụ thuộc: $count người';
  }

  @override
  String dependantsTotalReliefLabel(String amount) {
    return 'Tổng mức giảm trừ: $amount ₫/tháng';
  }

  @override
  String get dependantPolicyNotice =>
      'Mức giảm trừ gia cảnh 4.400.000 ₫/người/tháng theo Nghị quyết của Ủy ban Thường vụ Quốc hội.';

  @override
  String get addDependantBtn => 'Đăng ký người phụ thuộc mới';

  @override
  String get dependantNewTitle => 'Đăng ký người phụ thuộc';

  @override
  String get dependantFullNameLabel => 'Họ và tên người phụ thuộc';

  @override
  String get dependantRelationshipLabel => 'Mối quan hệ';

  @override
  String get dependantDobLabel => 'Ngày tháng năm sinh';

  @override
  String get dependantTaxIdLabel => 'Mã số thuế / CCCD / Giấy khai sinh';

  @override
  String get dependantStartMonthLabel => 'Tháng bắt đầu tính giảm trừ';

  @override
  String get dependantProofUploadLabel => 'Minh chứng (Giấy khai sinh / CCCD)';

  @override
  String get dependantDisclaimer =>
      'Tôi cam đoan các thông tin kê khai về người phụ thuộc trên là hoàn toàn chính xác và chịu trách nhiệm trước pháp luật.';

  @override
  String get submitDependantBtn => 'Gửi hồ sơ đăng ký';

  @override
  String get dependantCreatedSuccess =>
      'Đã gửi hồ sơ đăng ký người phụ thuộc đến phòng Nhân sự';

  @override
  String get noDependantsFound => 'Chưa có người phụ thuộc nào được đăng ký';

  @override
  String get onboardingHomeTitle => 'Hành trình Hội nhập';

  @override
  String get onboardingWelcomeMsg => 'Chào mừng bạn gia nhập VSTECH!';

  @override
  String onboardingCountdownDays(int days, String date) {
    return 'Còn $days ngày nữa đến Ngày đầu tiên ($date)';
  }

  @override
  String onboardingProgressSummary(int completed, int total) {
    return 'Tiến độ chuẩn bị: $completed/$total bước';
  }

  @override
  String get offerLetterTitle => 'Thư mời nhận việc (Offer)';

  @override
  String get offerAcceptBtn => 'Xác nhận chấp thuận Offer';

  @override
  String get offerAcceptedBadge => 'Đã chấp thuận Offer';

  @override
  String offerSalaryProbation(String amount) {
    return 'Lương thử việc (85%): $amount ₫';
  }

  @override
  String get orgIntroTitle => 'Đội ngũ & Người đồng hành';

  @override
  String get buddyCardTitle => 'Người hướng dẫn (Buddy) của bạn';

  @override
  String get uploadDocsTitle => 'Nộp hồ sơ nhân sự';

  @override
  String uploadDocsProgress(int uploaded, int total) {
    return 'Đã nộp $uploaded/$total tài liệu';
  }

  @override
  String get capturePhotoTitle => 'Chụp ảnh thẻ nhân viên';

  @override
  String get capturePhotoGuide =>
      'Chụp ảnh chân dung 3x4 nền sáng, nhìn thẳng vào camera';

  @override
  String get capturePhotoBtn => 'Chụp ảnh';

  @override
  String get confirmPhotoBtn => 'Xác nhận dùng ảnh này';

  @override
  String get ocrVerificationTitle => 'Xác thực danh tính (OCR CCCD)';

  @override
  String get ocrScanBtn => 'Quét mặt trước CCCD';

  @override
  String get ocrVerifiedBadge => 'Đã xác thực trùng khớp 100%';

  @override
  String get probationContractTitle => 'Hợp đồng thử việc điện tử';

  @override
  String get signContractBtn => 'Xác nhận ký hợp đồng';

  @override
  String get contractSignedSuccess =>
      'Đã hoàn tất ký hợp đồng thử việc điện tử';

  @override
  String get dayOneGuideTitle => 'Cẩm nang Ngày đầu tiên';

  @override
  String get dayOneChecklistTitle => 'Những điều cần lưu ý cho Ngày 1';

  @override
  String get startNextStepBtn => 'Thực hiện bước tiếp theo';
}
