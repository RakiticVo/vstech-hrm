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
  String get leaveTypeSick => 'Nghỉ bệnh';

  @override
  String get leaveTypeUnpaid => 'Không lương';

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
  String get deviceSecurityTitle => 'THIẾT BỊ & AN TOÀN HỆ THỐNG';

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
  String get forgotPasswordShort => 'Quên?';

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
}
