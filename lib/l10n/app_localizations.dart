import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'VSTech HRM'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @employeeCode.
  ///
  /// In vi, this message translates to:
  /// **'Mã nhân viên'**
  String get employeeCode;

  /// No description provided for @password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get password;

  /// No description provided for @checkIn.
  ///
  /// In vi, this message translates to:
  /// **'Chấm công'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In vi, this message translates to:
  /// **'Tan ca'**
  String get checkOut;

  /// No description provided for @home.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get home;

  /// No description provided for @attendance.
  ///
  /// In vi, this message translates to:
  /// **'Chấm công'**
  String get attendance;

  /// No description provided for @requests.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu'**
  String get requests;

  /// No description provided for @approvals.
  ///
  /// In vi, this message translates to:
  /// **'Phê duyệt'**
  String get approvals;

  /// No description provided for @payroll.
  ///
  /// In vi, this message translates to:
  /// **'Bảng lương'**
  String get payroll;

  /// No description provided for @profile.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get profile;

  /// No description provided for @errorOccurred.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra'**
  String get errorOccurred;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// No description provided for @contactHr.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ HR'**
  String get contactHr;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy bỏ'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu lại'**
  String get save;

  /// No description provided for @close.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get close;

  /// No description provided for @viewAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get viewAll;

  /// No description provided for @back.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get back;

  /// No description provided for @details.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết'**
  String get details;

  /// No description provided for @syncNow.
  ///
  /// In vi, this message translates to:
  /// **'Đồng bộ ngay'**
  String get syncNow;

  /// No description provided for @loginSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Giải pháp Quản trị Nhân sự Thông minh'**
  String get loginSubtitle;

  /// No description provided for @loginInstruction.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã nhân viên và mật khẩu của bạn'**
  String get loginInstruction;

  /// No description provided for @loginButton.
  ///
  /// In vi, this message translates to:
  /// **'ĐĂNG NHẬP HỆ THỐNG'**
  String get loginButton;

  /// No description provided for @biometricLogin.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập bằng Face ID / Vân tay'**
  String get biometricLogin;

  /// No description provided for @demoQuickLogin.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập nhanh (Chế độ Demo)'**
  String get demoQuickLogin;

  /// No description provided for @demoEmployee.
  ///
  /// In vi, this message translates to:
  /// **'Nhân viên (NV)'**
  String get demoEmployee;

  /// No description provided for @demoManager.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý (QL)'**
  String get demoManager;

  /// No description provided for @greetingMorning.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi sáng'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi chiều'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi tối'**
  String get greetingEvening;

  /// No description provided for @greetingDefault.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào'**
  String get greetingDefault;

  /// No description provided for @todayWorkedHours.
  ///
  /// In vi, this message translates to:
  /// **'GIỜ ĐÃ LÀM HÔM NAY'**
  String get todayWorkedHours;

  /// No description provided for @todayShiftLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ca hôm nay'**
  String get todayShiftLabel;

  /// No description provided for @clockInCta.
  ///
  /// In vi, this message translates to:
  /// **'CHẤM CÔNG VÀO'**
  String get clockInCta;

  /// No description provided for @clockOutCta.
  ///
  /// In vi, this message translates to:
  /// **'CHẤM CÔNG RA'**
  String get clockOutCta;

  /// No description provided for @timeIn.
  ///
  /// In vi, this message translates to:
  /// **'Giờ vào'**
  String get timeIn;

  /// No description provided for @timeOut.
  ///
  /// In vi, this message translates to:
  /// **'Giờ ra'**
  String get timeOut;

  /// No description provided for @lateMinutes.
  ///
  /// In vi, this message translates to:
  /// **'Đi muộn'**
  String get lateMinutes;

  /// No description provided for @overtimeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tăng ca'**
  String get overtimeLabel;

  /// No description provided for @locationVerified.
  ///
  /// In vi, this message translates to:
  /// **'Đã xác thực vị trí'**
  String get locationVerified;

  /// No description provided for @managerApprovalPending.
  ///
  /// In vi, this message translates to:
  /// **'yêu cầu đang chờ bạn phê duyệt'**
  String get managerApprovalPending;

  /// No description provided for @managerApprovalAction.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt ngay'**
  String get managerApprovalAction;

  /// No description provided for @metricWorkdays.
  ///
  /// In vi, this message translates to:
  /// **'Ngày công'**
  String get metricWorkdays;

  /// No description provided for @metricLeaveBalance.
  ///
  /// In vi, this message translates to:
  /// **'Phép còn lại'**
  String get metricLeaveBalance;

  /// No description provided for @metricOvertime.
  ///
  /// In vi, this message translates to:
  /// **'Giờ tăng ca'**
  String get metricOvertime;

  /// No description provided for @metricPending.
  ///
  /// In vi, this message translates to:
  /// **'Chờ duyệt'**
  String get metricPending;

  /// No description provided for @quickActionLeave.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ phép'**
  String get quickActionLeave;

  /// No description provided for @quickActionOvertime.
  ///
  /// In vi, this message translates to:
  /// **'Tăng ca'**
  String get quickActionOvertime;

  /// No description provided for @quickActionCorrection.
  ///
  /// In vi, this message translates to:
  /// **'Sửa công'**
  String get quickActionCorrection;

  /// No description provided for @quickActionPayroll.
  ///
  /// In vi, this message translates to:
  /// **'Bảng lương'**
  String get quickActionPayroll;

  /// No description provided for @quickActionAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get quickActionAll;

  /// No description provided for @salarySummaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập tháng 9/2026'**
  String get salarySummaryTitle;

  /// No description provided for @salaryNetPay.
  ///
  /// In vi, this message translates to:
  /// **'Thực nhận'**
  String get salaryNetPay;

  /// No description provided for @announcementsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo nội bộ'**
  String get announcementsTitle;

  /// No description provided for @roleSwitcherTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển đổi vai trò Demo'**
  String get roleSwitcherTitle;

  /// No description provided for @shiftCheckInLabel.
  ///
  /// In vi, this message translates to:
  /// **'VÀO LÀM'**
  String get shiftCheckInLabel;

  /// No description provided for @shiftCheckOutLabel.
  ///
  /// In vi, this message translates to:
  /// **'RA VỀ'**
  String get shiftCheckOutLabel;

  /// No description provided for @shiftDoneCta.
  ///
  /// In vi, this message translates to:
  /// **'XONG CA'**
  String get shiftDoneCta;

  /// No description provided for @shiftCheckOutCta.
  ///
  /// In vi, this message translates to:
  /// **'CHẤM RA'**
  String get shiftCheckOutCta;

  /// No description provided for @todayShiftDefault.
  ///
  /// In vi, this message translates to:
  /// **'Ca hôm nay 08:00 — 17:00'**
  String get todayShiftDefault;

  /// No description provided for @metricLateEarly.
  ///
  /// In vi, this message translates to:
  /// **'MUỘN / SỚM'**
  String get metricLateEarly;

  /// No description provided for @daysUnit.
  ///
  /// In vi, this message translates to:
  /// **'ngày'**
  String get daysUnit;

  /// No description provided for @hoursUnit.
  ///
  /// In vi, this message translates to:
  /// **'h'**
  String get hoursUnit;

  /// No description provided for @monthlyNetSalaryLabel.
  ///
  /// In vi, this message translates to:
  /// **'LƯƠNG THỰC NHẬN THÁNG NÀY'**
  String get monthlyNetSalaryLabel;

  /// No description provided for @salaryMasked.
  ///
  /// In vi, this message translates to:
  /// **'•••••••• ₫'**
  String get salaryMasked;

  /// No description provided for @salaryHintRevealed.
  ///
  /// In vi, this message translates to:
  /// **'Gồm thưởng KPI 2.500.000 ₫ · Xem chi tiết'**
  String get salaryHintRevealed;

  /// No description provided for @salaryHintHidden.
  ///
  /// In vi, this message translates to:
  /// **'Bấm vào mắt để xem · Xem phiếu lương'**
  String get salaryHintHidden;

  /// No description provided for @latestUpdatesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật mới'**
  String get latestUpdatesTitle;

  /// No description provided for @demoLeaveApprovedAnnouncement.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu nghỉ phép 21–23/09 đã được phê duyệt.'**
  String get demoLeaveApprovedAnnouncement;

  /// No description provided for @demoSalaryAnnouncement.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu lương tháng 9 đã có. Thực nhận 25.500.000 ₫.'**
  String get demoSalaryAnnouncement;

  /// No description provided for @twoHoursAgo.
  ///
  /// In vi, this message translates to:
  /// **'2 giờ trước'**
  String get twoHoursAgo;

  /// No description provided for @oneDayAgo.
  ///
  /// In vi, this message translates to:
  /// **'1 ngày trước'**
  String get oneDayAgo;

  /// No description provided for @managerPendingApprovalTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chờ bạn phê duyệt'**
  String get managerPendingApprovalTitle;

  /// No description provided for @switchToRole.
  ///
  /// In vi, this message translates to:
  /// **'Đổi sang {role}'**
  String switchToRole(String role);

  /// No description provided for @shiftScheduleNav.
  ///
  /// In vi, this message translates to:
  /// **'Lịch ca'**
  String get shiftScheduleNav;

  /// No description provided for @shiftScheduleTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch ca làm việc'**
  String get shiftScheduleTitle;

  /// No description provided for @workCalendarTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Lịch công'**
  String get workCalendarTooltip;

  /// No description provided for @attendanceMonthSummaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tổng hợp tháng {month}'**
  String attendanceMonthSummaryTitle(int month);

  /// No description provided for @sendCorrectionRequest.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu sửa công'**
  String get sendCorrectionRequest;

  /// No description provided for @statusCheckedIn.
  ///
  /// In vi, this message translates to:
  /// **'Đã chấm công vào'**
  String get statusCheckedIn;

  /// No description provided for @statusNotCheckedIn.
  ///
  /// In vi, this message translates to:
  /// **'Chưa chấm công'**
  String get statusNotCheckedIn;

  /// No description provided for @shiftPromptArrive.
  ///
  /// In vi, this message translates to:
  /// **'Ca của bạn bắt đầu 08:00. Chấm công khi bạn đến.'**
  String get shiftPromptArrive;

  /// No description provided for @hcmOfficeVerified.
  ///
  /// In vi, this message translates to:
  /// **'Văn phòng HCM - đã xác thực vị trí'**
  String get hcmOfficeVerified;

  /// No description provided for @zeroMinutes.
  ///
  /// In vi, this message translates to:
  /// **'0 phút'**
  String get zeroMinutes;

  /// No description provided for @offlineAttendanceModeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chấm công Ngoại tuyến (Vector ≥ 85%)'**
  String get offlineAttendanceModeLabel;

  /// No description provided for @onlineAttendanceModeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ Trực tuyến (Online)'**
  String get onlineAttendanceModeLabel;

  /// No description provided for @faceScanCheckInTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chấm công Giờ vào'**
  String get faceScanCheckInTitle;

  /// No description provided for @faceScanCheckOutTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chấm công Giờ ra'**
  String get faceScanCheckOutTitle;

  /// No description provided for @faceScanCaptureCheckInCta.
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh & Chấm công Vào'**
  String get faceScanCaptureCheckInCta;

  /// No description provided for @faceScanCaptureCheckOutCta.
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh & Chấm công Ra'**
  String get faceScanCaptureCheckOutCta;

  /// No description provided for @offlineLocationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Văn phòng HCM (Đối soát GPS cục bộ)'**
  String get offlineLocationLabel;

  /// No description provided for @offlineMatchSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Độ khớp khuôn mặt {pct}% (≥ 85%). Đã lưu hàng đợi offline.'**
  String offlineMatchSuccess(String pct);

  /// No description provided for @offlineMatchFailed.
  ///
  /// In vi, this message translates to:
  /// **'Khuôn mặt chưa đạt ngưỡng khớp 85%. Vui lòng căn chỉnh lại góc mặt.'**
  String get offlineMatchFailed;

  /// No description provided for @offlineQueueCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} lượt chấm công ngoại tuyến'**
  String offlineQueueCount(int count);

  /// No description provided for @offlineQueueDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu cục bộ an toàn, sẵn sàng đồng bộ.'**
  String get offlineQueueDesc;

  /// No description provided for @offlineSyncSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã đồng bộ thành công {count} lượt chấm công lên hệ thống!'**
  String offlineSyncSuccess(int count);

  /// No description provided for @syncButtonLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đồng bộ'**
  String get syncButtonLabel;

  /// No description provided for @attendanceFailed.
  ///
  /// In vi, this message translates to:
  /// **'Chấm công thất bại'**
  String get attendanceFailed;

  /// No description provided for @viewMonthTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Xem cả tháng'**
  String get viewMonthTooltip;

  /// No description provided for @viewMonth.
  ///
  /// In vi, this message translates to:
  /// **'Xem tháng'**
  String get viewMonth;

  /// No description provided for @weekStatsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tuần {week} ({range})'**
  String weekStatsTitle(String week, String range);

  /// No description provided for @weekStatsSummary.
  ///
  /// In vi, this message translates to:
  /// **'{shifts} ca làm · {hours} giờ công · {daysOff} ngày nghỉ'**
  String weekStatsSummary(int shifts, int hours, int daysOff);

  /// No description provided for @shiftDetailHeader.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết ca ngày {dayOfWeek}, {date}'**
  String shiftDetailHeader(String dayOfWeek, String date);

  /// No description provided for @shiftStatusActive.
  ///
  /// In vi, this message translates to:
  /// **'Đang diễn ra'**
  String get shiftStatusActive;

  /// No description provided for @shiftStatusCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn thành'**
  String get shiftStatusCompleted;

  /// No description provided for @shiftStatusUpcoming.
  ///
  /// In vi, this message translates to:
  /// **'Sắp diễn ra'**
  String get shiftStatusUpcoming;

  /// No description provided for @shiftStatusDayOff.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ tuần'**
  String get shiftStatusDayOff;

  /// No description provided for @dayOffTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay là Ngày nghỉ tuần'**
  String get dayOffTitle;

  /// No description provided for @dayOffDescription.
  ///
  /// In vi, this message translates to:
  /// **'Không có ca làm việc được phân công. Hãy nghỉ ngơi, nạp năng lượng chuẩn bị cho tuần mới!'**
  String get dayOffDescription;

  /// No description provided for @registerOvertimeCta.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký làm thêm (OT)'**
  String get registerOvertimeCta;

  /// No description provided for @shiftLabelTime.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian:'**
  String get shiftLabelTime;

  /// No description provided for @shiftLabelBreak.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ giữa ca:'**
  String get shiftLabelBreak;

  /// No description provided for @shiftLabelLocation.
  ///
  /// In vi, this message translates to:
  /// **'Địa điểm:'**
  String get shiftLabelLocation;

  /// No description provided for @shiftLabelManager.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý ca:'**
  String get shiftLabelManager;

  /// No description provided for @shiftLabelNotes.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú:'**
  String get shiftLabelNotes;

  /// No description provided for @shiftSwapButton.
  ///
  /// In vi, this message translates to:
  /// **'Đổi ca'**
  String get shiftSwapButton;

  /// No description provided for @shiftOvertimeButton.
  ///
  /// In vi, this message translates to:
  /// **'Báo tăng ca'**
  String get shiftOvertimeButton;

  /// No description provided for @swapRequestSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu đổi ca cho {colleague}!'**
  String swapRequestSent(String colleague);

  /// No description provided for @swapShiftProposalTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đề xuất đổi ca làm việc'**
  String get swapShiftProposalTitle;

  /// No description provided for @selectColleagueLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chọn đồng nghiệp muốn đổi ca:'**
  String get selectColleagueLabel;

  /// No description provided for @swapReasonLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lý do đổi ca:'**
  String get swapReasonLabel;

  /// No description provided for @swapReasonHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lý do đổi ca cụ thể...'**
  String get swapReasonHint;

  /// No description provided for @submitSwapRequestButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu đổi ca'**
  String get submitSwapRequestButton;

  /// No description provided for @shiftCalendarMonthTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch ca Tháng {month}/{year}'**
  String shiftCalendarMonthTitle(int month, int year);

  /// No description provided for @dayMon.
  ///
  /// In vi, this message translates to:
  /// **'T2'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In vi, this message translates to:
  /// **'T3'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In vi, this message translates to:
  /// **'T4'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In vi, this message translates to:
  /// **'T5'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In vi, this message translates to:
  /// **'T6'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In vi, this message translates to:
  /// **'T7'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In vi, this message translates to:
  /// **'CN'**
  String get daySun;

  /// No description provided for @shiftMorning.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get shiftMorning;

  /// No description provided for @shiftAfternoon.
  ///
  /// In vi, this message translates to:
  /// **'Chiều'**
  String get shiftAfternoon;

  /// No description provided for @shiftSplit.
  ///
  /// In vi, this message translates to:
  /// **'Gãy'**
  String get shiftSplit;

  /// No description provided for @shiftNight.
  ///
  /// In vi, this message translates to:
  /// **'Đêm'**
  String get shiftNight;

  /// No description provided for @shiftOff.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ'**
  String get shiftOff;

  /// No description provided for @tabAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get tabAll;

  /// No description provided for @tabPending.
  ///
  /// In vi, this message translates to:
  /// **'Chờ duyệt'**
  String get tabPending;

  /// No description provided for @tabApproved.
  ///
  /// In vi, this message translates to:
  /// **'Đã duyệt'**
  String get tabApproved;

  /// No description provided for @tabRejected.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get tabRejected;

  /// No description provided for @createNewRequestTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo yêu cầu mới'**
  String get createNewRequestTitle;

  /// No description provided for @requestTypeLeave.
  ///
  /// In vi, this message translates to:
  /// **'Xin nghỉ phép'**
  String get requestTypeLeave;

  /// No description provided for @requestTypeOvertime.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký tăng ca'**
  String get requestTypeOvertime;

  /// No description provided for @requestTypeCorrection.
  ///
  /// In vi, this message translates to:
  /// **'Sửa công'**
  String get requestTypeCorrection;

  /// No description provided for @requestsCenterTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trung tâm yêu cầu'**
  String get requestsCenterTitle;

  /// No description provided for @requestsCenterSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ phép · Tăng ca · Sửa công'**
  String get requestsCenterSubtitle;

  /// No description provided for @monthlyRequestsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu theo tháng'**
  String get monthlyRequestsTitle;

  /// No description provided for @selectMonthToView.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tháng xem dữ liệu'**
  String get selectMonthToView;

  /// No description provided for @noRequestsInMonth.
  ///
  /// In vi, this message translates to:
  /// **'Không có yêu cầu nào trong {month}'**
  String noRequestsInMonth(String month);

  /// No description provided for @roleIndicatorEmployee.
  ///
  /// In vi, this message translates to:
  /// **'Xem vai trò Quản lý:'**
  String get roleIndicatorEmployee;

  /// No description provided for @roleIndicatorSwitchToManager.
  ///
  /// In vi, this message translates to:
  /// **'Đổi sang QL (mục Duyệt)'**
  String get roleIndicatorSwitchToManager;

  /// No description provided for @managerPendingApprovalsBanner.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có {count} yêu cầu chờ phê duyệt'**
  String managerPendingApprovalsBanner(int count);

  /// No description provided for @openApprovalsLink.
  ///
  /// In vi, this message translates to:
  /// **'Mở mục Duyệt >'**
  String get openApprovalsLink;

  /// No description provided for @submitRequestButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu'**
  String get submitRequestButton;

  /// No description provided for @leaveRemainingStat.
  ///
  /// In vi, this message translates to:
  /// **'Phép năm còn'**
  String get leaveRemainingStat;

  /// No description provided for @leaveUsedStat.
  ///
  /// In vi, this message translates to:
  /// **'Đã sử dụng'**
  String get leaveUsedStat;

  /// No description provided for @newLeaveRequestSection.
  ///
  /// In vi, this message translates to:
  /// **'Đơn nghỉ phép mới'**
  String get newLeaveRequestSection;

  /// No description provided for @leaveTypeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Loại nghỉ'**
  String get leaveTypeLabel;

  /// No description provided for @timeRangeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian'**
  String get timeRangeLabel;

  /// No description provided for @totalLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tổng cộng'**
  String get totalLabel;

  /// No description provided for @leaveHistorySection.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử đơn nghỉ phép'**
  String get leaveHistorySection;

  /// No description provided for @noLeaveRequestsInMonth.
  ///
  /// In vi, this message translates to:
  /// **'Không có đơn nghỉ phép nào trong {month}'**
  String noLeaveRequestsInMonth(String month);

  /// No description provided for @leaveRequestSubmittedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi đơn xin nghỉ phép!'**
  String get leaveRequestSubmittedTitle;

  /// No description provided for @leaveRequestSubmittedMsg.
  ///
  /// In vi, this message translates to:
  /// **'Đơn {type} từ {start} đến {end} ({total}) đã được gửi tới Quản lý phê duyệt.'**
  String leaveRequestSubmittedMsg(
    String type,
    String start,
    String end,
    String total,
  );

  /// No description provided for @thisMonthStat.
  ///
  /// In vi, this message translates to:
  /// **'Tháng này'**
  String get thisMonthStat;

  /// No description provided for @paidStat.
  ///
  /// In vi, this message translates to:
  /// **'Đã thanh toán'**
  String get paidStat;

  /// No description provided for @needsActionStat.
  ///
  /// In vi, this message translates to:
  /// **'Cần xử lý'**
  String get needsActionStat;

  /// No description provided for @newOvertimeRequestSection.
  ///
  /// In vi, this message translates to:
  /// **'Tăng ca mới'**
  String get newOvertimeRequestSection;

  /// No description provided for @newCorrectionRequestSection.
  ///
  /// In vi, this message translates to:
  /// **'Sửa công mới'**
  String get newCorrectionRequestSection;

  /// No description provided for @overtimeHistorySection.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử tăng ca'**
  String get overtimeHistorySection;

  /// No description provided for @correctionHistorySection.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử sửa công'**
  String get correctionHistorySection;

  /// No description provided for @approvalsCenterTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trung tâm phê duyệt'**
  String get approvalsCenterTitle;

  /// No description provided for @awaitingYourAction.
  ///
  /// In vi, this message translates to:
  /// **'Chờ bạn xử lý'**
  String get awaitingYourAction;

  /// No description provided for @noPendingApprovals.
  ///
  /// In vi, this message translates to:
  /// **'Không có yêu cầu nào đang chờ duyệt'**
  String get noPendingApprovals;

  /// No description provided for @requestApprovedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã phê duyệt yêu cầu của {name}'**
  String requestApprovedSuccess(String name);

  /// No description provided for @requestRejectedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối yêu cầu của {name}'**
  String requestRejectedSuccess(String name);

  /// No description provided for @statusPending.
  ///
  /// In vi, this message translates to:
  /// **'Chờ duyệt'**
  String get statusPending;

  /// No description provided for @actionReject.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get actionReject;

  /// No description provided for @actionApprove.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt'**
  String get actionApprove;

  /// No description provided for @statusApproved.
  ///
  /// In vi, this message translates to:
  /// **'Đã duyệt'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get statusRejected;

  /// No description provided for @statusNeedsAction.
  ///
  /// In vi, this message translates to:
  /// **'Cần bổ sung'**
  String get statusNeedsAction;

  /// No description provided for @stagePendingManager.
  ///
  /// In vi, this message translates to:
  /// **'Chờ quản lý'**
  String get stagePendingManager;

  /// No description provided for @stagePendingHr.
  ///
  /// In vi, this message translates to:
  /// **'Chờ HR'**
  String get stagePendingHr;

  /// No description provided for @stagePendingDirector.
  ///
  /// In vi, this message translates to:
  /// **'Chờ giám đốc'**
  String get stagePendingDirector;

  /// No description provided for @stageCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất'**
  String get stageCompleted;

  /// No description provided for @stageRejected.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get stageRejected;

  /// No description provided for @leaveTypeAnnual.
  ///
  /// In vi, this message translates to:
  /// **'Phép năm'**
  String get leaveTypeAnnual;

  /// No description provided for @leaveTypeSick.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ ốm (BHXH)'**
  String get leaveTypeSick;

  /// No description provided for @leaveTypeUnpaid.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ không lương'**
  String get leaveTypeUnpaid;

  /// No description provided for @leaveTypeSpecial.
  ///
  /// In vi, this message translates to:
  /// **'Phép đặc biệt'**
  String get leaveTypeSpecial;

  /// No description provided for @leaveTypePersonal.
  ///
  /// In vi, this message translates to:
  /// **'Việc riêng'**
  String get leaveTypePersonal;

  /// No description provided for @createLeaveRequestTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo đơn xin nghỉ phép'**
  String get createLeaveRequestTitle;

  /// No description provided for @leaveTypeSelectorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Loại nghỉ phép'**
  String get leaveTypeSelectorTitle;

  /// No description provided for @fromDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Từ ngày'**
  String get fromDateLabel;

  /// No description provided for @toDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đến ngày'**
  String get toDateLabel;

  /// No description provided for @reasonLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lý do'**
  String get reasonLabel;

  /// No description provided for @addAttachmentOptional.
  ///
  /// In vi, this message translates to:
  /// **'Thêm tệp đính kèm (không bắt buộc)'**
  String get addAttachmentOptional;

  /// No description provided for @attachmentSelected.
  ///
  /// In vi, this message translates to:
  /// **'Đã chọn tệp đính kèm: {fileName} ({size})'**
  String attachmentSelected(String fileName, String size);

  /// No description provided for @confirmSendLeaveRequest.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận gửi đơn'**
  String get confirmSendLeaveRequest;

  /// No description provided for @overtimeModalTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập thông tin tăng ca'**
  String get overtimeModalTitle;

  /// No description provided for @overtimeDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày tăng ca'**
  String get overtimeDateLabel;

  /// No description provided for @overtimeTimeRangeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khung giờ làm thêm'**
  String get overtimeTimeRangeLabel;

  /// No description provided for @startTimeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get startTimeLabel;

  /// No description provided for @endTimeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Kết thúc'**
  String get endTimeLabel;

  /// No description provided for @overtimeEstimateCalc.
  ///
  /// In vi, this message translates to:
  /// **'Tổng cộng: {hours} giờ · Hệ số {rate} ({type})'**
  String overtimeEstimateCalc(int hours, String rate, String type);

  /// No description provided for @overtimeDayTypeNormal.
  ///
  /// In vi, this message translates to:
  /// **'Ngày thường'**
  String get overtimeDayTypeNormal;

  /// No description provided for @overtimeReasonLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lý do tăng ca'**
  String get overtimeReasonLabel;

  /// No description provided for @confirmSendOvertime.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận gửi'**
  String get confirmSendOvertime;

  /// No description provided for @overtimeSubmittedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi đăng ký tăng ca!'**
  String get overtimeSubmittedTitle;

  /// No description provided for @overtimeSubmittedMsg.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu làm thêm giờ ngày {date} ({time}) đã được gửi cho Quản lý phê duyệt.'**
  String overtimeSubmittedMsg(String date, String time);

  /// No description provided for @noOvertimeInMonth.
  ///
  /// In vi, this message translates to:
  /// **'Không có dữ liệu tăng ca trong {month}'**
  String noOvertimeInMonth(String month);

  /// No description provided for @createCorrectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo yêu cầu sửa công'**
  String get createCorrectionTitle;

  /// No description provided for @correctionDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày sửa'**
  String get correctionDateLabel;

  /// No description provided for @correctionTimeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Sửa thành giờ'**
  String get correctionTimeLabel;

  /// No description provided for @correctionIssueLabel.
  ///
  /// In vi, this message translates to:
  /// **'Vấn đề phát sinh'**
  String get correctionIssueLabel;

  /// No description provided for @issueMissingCheckout.
  ///
  /// In vi, this message translates to:
  /// **'Thiếu giờ ra'**
  String get issueMissingCheckout;

  /// No description provided for @issueMissingCheckin.
  ///
  /// In vi, this message translates to:
  /// **'Thiếu giờ vào'**
  String get issueMissingCheckin;

  /// No description provided for @issueWrongShift.
  ///
  /// In vi, this message translates to:
  /// **'Sai ca làm'**
  String get issueWrongShift;

  /// No description provided for @issueScannerError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi máy quét'**
  String get issueScannerError;

  /// No description provided for @explanationDetailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giải trình chi tiết'**
  String get explanationDetailLabel;

  /// No description provided for @addProofOptional.
  ///
  /// In vi, this message translates to:
  /// **'Đính kèm ảnh/minh chứng (không bắt buộc)'**
  String get addProofOptional;

  /// No description provided for @proofSelected.
  ///
  /// In vi, this message translates to:
  /// **'Đã chọn minh chứng: {fileName} ({size})'**
  String proofSelected(String fileName, String size);

  /// No description provided for @confirmSendCorrection.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận gửi yêu cầu'**
  String get confirmSendCorrection;

  /// No description provided for @correctionSubmittedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu sửa công!'**
  String get correctionSubmittedTitle;

  /// No description provided for @correctionSubmittedMsg.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu {issue} ngày {date} ({time}) đã được chuyển tới HR & Quản lý duyệt.'**
  String correctionSubmittedMsg(String issue, String date, String time);

  /// No description provided for @noCorrectionsInMonth.
  ///
  /// In vi, this message translates to:
  /// **'Không có phiếu sửa công nào trong {month}'**
  String noCorrectionsInMonth(String month);

  /// No description provided for @correctionWarningBanner.
  ///
  /// In vi, this message translates to:
  /// **'Ngày 15/09/2026 chưa có giờ ra. Ngày này bị tính thiếu công cho đến khi được duyệt sửa.'**
  String get correctionWarningBanner;

  /// No description provided for @correctionIssueTitle.
  ///
  /// In vi, this message translates to:
  /// **'Vấn đề'**
  String get correctionIssueTitle;

  /// No description provided for @correctionChangeTo.
  ///
  /// In vi, this message translates to:
  /// **'Sửa thành'**
  String get correctionChangeTo;

  /// No description provided for @payrollTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lương & Thu nhập'**
  String get payrollTitle;

  /// No description provided for @payrollPeriodSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ lương Tháng {month}/{year}'**
  String payrollPeriodSubtitle(String month, String year);

  /// No description provided for @rewardsAction.
  ///
  /// In vi, this message translates to:
  /// **'Thưởng'**
  String get rewardsAction;

  /// No description provided for @payrollNetSalaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'LƯƠNG THỰC NHẬN (NET)'**
  String get payrollNetSalaryTitle;

  /// No description provided for @payrollPayDate.
  ///
  /// In vi, this message translates to:
  /// **'VND · Trả ngày {date}'**
  String payrollPayDate(String date);

  /// No description provided for @viewPayslipButton.
  ///
  /// In vi, this message translates to:
  /// **'Xem phiếu lương'**
  String get viewPayslipButton;

  /// No description provided for @incomeAndDeductionBreakdown.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết thu nhập & khấu trừ'**
  String get incomeAndDeductionBreakdown;

  /// No description provided for @salaryHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử kỳ lương'**
  String get salaryHistoryTitle;

  /// No description provided for @payslipTitle.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu lương'**
  String get payslipTitle;

  /// No description provided for @downloadingPdfSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải về phiếu lương PDF...'**
  String get downloadingPdfSnackbar;

  /// No description provided for @salaryTransferredTo.
  ///
  /// In vi, this message translates to:
  /// **'Đã chuyển {bank} · {date}'**
  String salaryTransferredTo(String bank, String date);

  /// No description provided for @basicSalaryLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lương cơ bản'**
  String get basicSalaryLabel;

  /// No description provided for @lunchAndTransportAllowance.
  ///
  /// In vi, this message translates to:
  /// **'Phụ cấp ăn trưa & đi lại'**
  String get lunchAndTransportAllowance;

  /// No description provided for @kpiQuarterBonus.
  ///
  /// In vi, this message translates to:
  /// **'Thưởng KPI quý {quarter}'**
  String kpiQuarterBonus(int quarter);

  /// No description provided for @socialInsuranceDeduction.
  ///
  /// In vi, this message translates to:
  /// **'BHXH, BHYT, BHTN (10.5%)'**
  String get socialInsuranceDeduction;

  /// No description provided for @personalIncomeTaxDeduction.
  ///
  /// In vi, this message translates to:
  /// **'Thuế TNCN tạm tính'**
  String get personalIncomeTaxDeduction;

  /// No description provided for @unionFeeDeduction.
  ///
  /// In vi, this message translates to:
  /// **'Phí đoàn thể'**
  String get unionFeeDeduction;

  /// No description provided for @incomeSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập'**
  String get incomeSectionTitle;

  /// No description provided for @deductionSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khoản trừ'**
  String get deductionSectionTitle;

  /// No description provided for @netSalaryLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lương thực nhận'**
  String get netSalaryLabel;

  /// No description provided for @overtimePayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tăng ca 12h (x1.5)'**
  String get overtimePayLabel;

  /// No description provided for @payslipNetSalaryMonth.
  ///
  /// In vi, this message translates to:
  /// **'Lương thực nhận: Tháng {month} {year}'**
  String payslipNetSalaryMonth(String month, String year);

  /// No description provided for @profileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get profileTitle;

  /// No description provided for @personalInfoSection.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cá nhân'**
  String get personalInfoSection;

  /// No description provided for @workInfoSection.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin công việc'**
  String get workInfoSection;

  /// No description provided for @bankAccountSection.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản ngân hàng'**
  String get bankAccountSection;

  /// No description provided for @fullNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get fullNameLabel;

  /// No description provided for @dateOfBirthLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh'**
  String get dateOfBirthLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In vi, this message translates to:
  /// **'Điện thoại'**
  String get phoneLabel;

  /// No description provided for @emailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @addressLabel.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ'**
  String get addressLabel;

  /// No description provided for @departmentLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bộ phận'**
  String get departmentLabel;

  /// No description provided for @jobTitleLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chức danh'**
  String get jobTitleLabel;

  /// No description provided for @directManagerLabel.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý'**
  String get directManagerLabel;

  /// No description provided for @joinDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày vào'**
  String get joinDateLabel;

  /// No description provided for @employmentStatusLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái'**
  String get employmentStatusLabel;

  /// No description provided for @officialStatus.
  ///
  /// In vi, this message translates to:
  /// **'Chính thức'**
  String get officialStatus;

  /// No description provided for @bankNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngân hàng'**
  String get bankNameLabel;

  /// No description provided for @accountNumberLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số tài khoản'**
  String get accountNumberLabel;

  /// No description provided for @emergencyContactLink.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ khẩn cấp'**
  String get emergencyContactLink;

  /// No description provided for @documentsAndRecordsLink.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ & tài liệu'**
  String get documentsAndRecordsLink;

  /// No description provided for @internalRecruitmentLink.
  ///
  /// In vi, this message translates to:
  /// **'Tuyển dụng nội bộ'**
  String get internalRecruitmentLink;

  /// No description provided for @settingsLink.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settingsLink;

  /// No description provided for @logoutButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logoutButton;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận đăng xuất'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMsg.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng VSTech HRM không?'**
  String get logoutConfirmMsg;

  /// No description provided for @cancelButton.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancelButton;

  /// No description provided for @roleBadgeManager.
  ///
  /// In vi, this message translates to:
  /// **'QL'**
  String get roleBadgeManager;

  /// No description provided for @roleBadgeEmployee.
  ///
  /// In vi, this message translates to:
  /// **'NV'**
  String get roleBadgeEmployee;

  /// No description provided for @readyToUploadAvatarSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã sẵn sàng tải lên ảnh đại diện mới'**
  String get readyToUploadAvatarSnackbar;

  /// No description provided for @languageSettingTitle.
  ///
  /// In vi, this message translates to:
  /// **'CÀI ĐẶT NGÔN NGỮ'**
  String get languageSettingTitle;

  /// No description provided for @chooseLanguageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ hiển thị'**
  String get chooseLanguageTitle;

  /// No description provided for @languageDesc.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện và thông báo sẽ được chuyển đổi ngay lập tức sang ngôn ngữ bạn chọn.'**
  String get languageDesc;

  /// No description provided for @vietnameseLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnameseLanguage;

  /// No description provided for @vietnameseDesc.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ mặc định của ứng dụng.'**
  String get vietnameseDesc;

  /// No description provided for @englishLanguage.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @englishDesc.
  ///
  /// In vi, this message translates to:
  /// **'English display for global workplace standards.'**
  String get englishDesc;

  /// No description provided for @confirmButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirmButton;

  /// No description provided for @closeButton.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get closeButton;

  /// No description provided for @themeSettingTitle.
  ///
  /// In vi, this message translates to:
  /// **'CÀI ĐẶT GIAO DIỆN'**
  String get themeSettingTitle;

  /// No description provided for @chooseThemeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn chế độ hiển thị'**
  String get chooseThemeTitle;

  /// No description provided for @themeDesc.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện thay đổi ngay lập tức và tự động ghi nhớ cho các lần mở ứng dụng tiếp theo.'**
  String get themeDesc;

  /// No description provided for @themeSystem.
  ///
  /// In vi, this message translates to:
  /// **'Theo hệ thống'**
  String get themeSystem;

  /// No description provided for @themeSystemDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tự động đồng bộ với cài đặt Sáng / Tối của điện thoại.'**
  String get themeSystemDesc;

  /// No description provided for @themeLight.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện sáng'**
  String get themeLight;

  /// No description provided for @themeLightDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tông kem ấm & hoạ văn gạch bông Sài Gòn đặc trưng.'**
  String get themeLightDesc;

  /// No description provided for @themeDark.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện tối'**
  String get themeDark;

  /// No description provided for @themeDarkDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tông xanh đen sâu, dịu mắt khi sử dụng ban đêm.'**
  String get themeDarkDesc;

  /// No description provided for @appLockSettingTitle.
  ///
  /// In vi, this message translates to:
  /// **'BẢO VỆ DỮ LIỆU'**
  String get appLockSettingTitle;

  /// No description provided for @appLockTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khóa ứng dụng & Mã PIN'**
  String get appLockTitle;

  /// No description provided for @appLockDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tự động khóa ứng dụng khi rời màn hình để bảo vệ thông tin lương và hồ sơ nhân viên.'**
  String get appLockDesc;

  /// No description provided for @enableAppLock.
  ///
  /// In vi, this message translates to:
  /// **'Bật khóa ứng dụng'**
  String get enableAppLock;

  /// No description provided for @autoLockAfter.
  ///
  /// In vi, this message translates to:
  /// **'TỰ ĐỘNG KHÓA SAU'**
  String get autoLockAfter;

  /// No description provided for @lockImmediately.
  ///
  /// In vi, this message translates to:
  /// **'Ngay lập tức khi rời app'**
  String get lockImmediately;

  /// No description provided for @lockAfter1Min.
  ///
  /// In vi, this message translates to:
  /// **'Sau 1 phút'**
  String get lockAfter1Min;

  /// No description provided for @lockAfter5Mins.
  ///
  /// In vi, this message translates to:
  /// **'Sau 5 phút'**
  String get lockAfter5Mins;

  /// No description provided for @saveSettingsButton.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thiết lập'**
  String get saveSettingsButton;

  /// No description provided for @appLockUpdatedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật cấu hình khóa ứng dụng thành công'**
  String get appLockUpdatedSnackbar;

  /// No description provided for @biometricSecurityTitle.
  ///
  /// In vi, this message translates to:
  /// **'BẢO MẬT SINH TRẮC HỌC'**
  String get biometricSecurityTitle;

  /// No description provided for @biometricAuthTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực Vân tay / Khuôn mặt'**
  String get biometricAuthTitle;

  /// No description provided for @biometricDesc.
  ///
  /// In vi, this message translates to:
  /// **'Dùng sinh trắc học thiết bị để mở khoá ứng dụng nhanh chóng và bảo vệ xem phiếu lương.'**
  String get biometricDesc;

  /// No description provided for @enableBiometrics.
  ///
  /// In vi, this message translates to:
  /// **'Kích hoạt sinh trắc học'**
  String get enableBiometrics;

  /// No description provided for @hardwareSupportLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hỗ trợ phần cứng:'**
  String get hardwareSupportLabel;

  /// No description provided for @hardwareAvailable.
  ///
  /// In vi, this message translates to:
  /// **'Khả dụng'**
  String get hardwareAvailable;

  /// No description provided for @hardwareNotSupported.
  ///
  /// In vi, this message translates to:
  /// **'Không hỗ trợ'**
  String get hardwareNotSupported;

  /// No description provided for @biometricSensorLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cảm biến sinh trắc:'**
  String get biometricSensorLabel;

  /// No description provided for @sensorConfigured.
  ///
  /// In vi, this message translates to:
  /// **'Đã cài đặt trên máy'**
  String get sensorConfigured;

  /// No description provided for @sensorNotConfigured.
  ///
  /// In vi, this message translates to:
  /// **'Chưa thiết lập'**
  String get sensorNotConfigured;

  /// No description provided for @testBiometricNow.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra cảm biến ngay'**
  String get testBiometricNow;

  /// No description provided for @deviceSecurityTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật thiết bị'**
  String get deviceSecurityTitle;

  /// No description provided for @linkedDeviceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị liên kết'**
  String get linkedDeviceTitle;

  /// No description provided for @deviceSecurityDesc.
  ///
  /// In vi, this message translates to:
  /// **'Quy định bảo mật ràng buộc tài khoản với 1 thiết bị duy nhất để chấm công và xem phiếu lương.'**
  String get deviceSecurityDesc;

  /// No description provided for @officialDeviceRegistered.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị chính thức • Đã đăng ký'**
  String get officialDeviceRegistered;

  /// No description provided for @physicalDeviceLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị thực tế'**
  String get physicalDeviceLabel;

  /// No description provided for @physicalDeviceValid.
  ///
  /// In vi, this message translates to:
  /// **'Hợp lệ (Physical)'**
  String get physicalDeviceValid;

  /// No description provided for @physicalDeviceWarning.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo (Simulator)'**
  String get physicalDeviceWarning;

  /// No description provided for @jailbreakLabel.
  ///
  /// In vi, this message translates to:
  /// **'Root / Jailbreak'**
  String get jailbreakLabel;

  /// No description provided for @jailbreakSafe.
  ///
  /// In vi, this message translates to:
  /// **'An toàn (Chưa Root)'**
  String get jailbreakSafe;

  /// No description provided for @jailbreakDetected.
  ///
  /// In vi, this message translates to:
  /// **'Phát hiện can thiệp!'**
  String get jailbreakDetected;

  /// No description provided for @mockGpsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giả lập vị trí (Mock GPS)'**
  String get mockGpsLabel;

  /// No description provided for @mockGpsNotDetected.
  ///
  /// In vi, this message translates to:
  /// **'Không phát hiện'**
  String get mockGpsNotDetected;

  /// No description provided for @mockGpsDetected.
  ///
  /// In vi, this message translates to:
  /// **'Phát hiện vị trí ảo!'**
  String get mockGpsDetected;

  /// No description provided for @developerModeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ nhà phát triển'**
  String get developerModeLabel;

  /// No description provided for @devModeOn.
  ///
  /// In vi, this message translates to:
  /// **'Đang bật (Dev Mode)'**
  String get devModeOn;

  /// No description provided for @devModeOff.
  ///
  /// In vi, this message translates to:
  /// **'Tắt'**
  String get devModeOff;

  /// No description provided for @systemInfoTitle.
  ///
  /// In vi, this message translates to:
  /// **'THÔNG TIN HỆ THỐNG'**
  String get systemInfoTitle;

  /// No description provided for @systemDesc.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống quản trị nguồn nhân lực B2B SaaS • Phân hệ Nhân viên & Quản lý.'**
  String get systemDesc;

  /// No description provided for @appVersionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản ứng dụng'**
  String get appVersionLabel;

  /// No description provided for @runtimeEnvLabel.
  ///
  /// In vi, this message translates to:
  /// **'Môi trường kết nối'**
  String get runtimeEnvLabel;

  /// No description provided for @dataEngineLabel.
  ///
  /// In vi, this message translates to:
  /// **'Động cơ dữ liệu'**
  String get dataEngineLabel;

  /// No description provided for @uiFontLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ UI & Font'**
  String get uiFontLabel;

  /// No description provided for @checkUpdatesButton.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra cập nhật'**
  String get checkUpdatesButton;

  /// No description provided for @appUpToDateSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng đang ở phiên bản mới nhất (v1.0.0)!'**
  String get appUpToDateSnackbar;

  /// No description provided for @roleSwitchDemoTitle.
  ///
  /// In vi, this message translates to:
  /// **'CHUYỂN ĐỔI VAI TRÒ (DEMO)'**
  String get roleSwitchDemoTitle;

  /// No description provided for @chooseRoleTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn vai trò trải nghiệm'**
  String get chooseRoleTitle;

  /// No description provided for @roleSwitchDesc.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ Demo độc lập cho phép hoán đổi giao diện và luồng duyệt giữa Nhân viên và Quản lý tức thì.'**
  String get roleSwitchDesc;

  /// No description provided for @roleEmployeeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhân viên (NV / ESS)'**
  String get roleEmployeeTitle;

  /// No description provided for @roleEmployeeDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nguyễn Văn An • NV0142\nChấm công, gửi đơn nghỉ phép, xem phiếu lương.'**
  String get roleEmployeeDesc;

  /// No description provided for @roleManagerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý trực tiếp (QL / MSS)'**
  String get roleManagerTitle;

  /// No description provided for @roleManagerDesc.
  ///
  /// In vi, this message translates to:
  /// **'Trần Thị Mai • NV0089\nXem dải chờ duyệt, duyệt cấp 1 các đơn từ nhân viên.'**
  String get roleManagerDesc;

  /// No description provided for @switchedToRoleSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã chuyển sang vai trò: {role}'**
  String switchedToRoleSnackbar(String role);

  /// No description provided for @settingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settingsTitle;

  /// No description provided for @notificationsSection.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notificationsSection;

  /// No description provided for @pushNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo đẩy'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhận thông báo phê duyệt và ca làm'**
  String get pushNotificationsDesc;

  /// No description provided for @emailReport.
  ///
  /// In vi, this message translates to:
  /// **'Email báo cáo'**
  String get emailReport;

  /// No description provided for @emailReportDesc.
  ///
  /// In vi, this message translates to:
  /// **'Gửi bản tóm tắt công & lương qua email'**
  String get emailReportDesc;

  /// No description provided for @punchReminder.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở chấm công'**
  String get punchReminder;

  /// No description provided for @punchReminderDesc.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo trước ca làm 15 phút'**
  String get punchReminderDesc;

  /// No description provided for @systemPermissionsSection.
  ///
  /// In vi, this message translates to:
  /// **'Quyền truy cập hệ thống'**
  String get systemPermissionsSection;

  /// No description provided for @manageDevicePermissions.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý quyền thiết bị'**
  String get manageDevicePermissions;

  /// No description provided for @permissionsSubtext.
  ///
  /// In vi, this message translates to:
  /// **'Máy ảnh, Vị trí GPS, Tệp & ảnh, Thông báo'**
  String get permissionsSubtext;

  /// No description provided for @securityAndPrivacySection.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật & Quyền riêng tư'**
  String get securityAndPrivacySection;

  /// No description provided for @biometricUnlock.
  ///
  /// In vi, this message translates to:
  /// **'Mở khoá sinh trắc học'**
  String get biometricUnlock;

  /// No description provided for @biometricUnlockDesc.
  ///
  /// In vi, this message translates to:
  /// **'Dùng Face ID hoặc vân tay để mở app'**
  String get biometricUnlockDesc;

  /// No description provided for @autoLock.
  ///
  /// In vi, this message translates to:
  /// **'Tự động khoá'**
  String get autoLock;

  /// No description provided for @autoLockDesc.
  ///
  /// In vi, this message translates to:
  /// **'Khoá app ngay khi chuyển sang ứng dụng khác'**
  String get autoLockDesc;

  /// No description provided for @designAndSystemSection.
  ///
  /// In vi, this message translates to:
  /// **'Thiết kế & Hệ thống'**
  String get designAndSystemSection;

  /// No description provided for @uiStateShowcase.
  ///
  /// In vi, this message translates to:
  /// **'Minh họa 4 Trạng thái (Empty, Shimmer, Error, Success)'**
  String get uiStateShowcase;

  /// No description provided for @uiStateShowcaseDesc.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm thử giao diện Rỗng, Đăng tải, Báo lỗi & Thành công'**
  String get uiStateShowcaseDesc;

  /// No description provided for @clearCache.
  ///
  /// In vi, this message translates to:
  /// **'Xoá bộ nhớ đệm (Cache)'**
  String get clearCache;

  /// No description provided for @cacheClearedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã dọn dẹp bộ nhớ đệm thành công'**
  String get cacheClearedSnackbar;

  /// No description provided for @enableNotificationInSettings.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng bật quyền Thông báo trong Cài đặt hệ thống'**
  String get enableNotificationInSettings;

  /// No description provided for @allServicesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả dịch vụ'**
  String get allServicesTitle;

  /// No description provided for @categoryAttendanceTime.
  ///
  /// In vi, this message translates to:
  /// **'Chấm công & Thời gian'**
  String get categoryAttendanceTime;

  /// No description provided for @categoryRequests.
  ///
  /// In vi, this message translates to:
  /// **'Đơn từ'**
  String get categoryRequests;

  /// No description provided for @categoryPayrollRewards.
  ///
  /// In vi, this message translates to:
  /// **'Lương & thưởng'**
  String get categoryPayrollRewards;

  /// No description provided for @categoryCareerProfile.
  ///
  /// In vi, this message translates to:
  /// **'Nghề nghiệp & hồ sơ'**
  String get categoryCareerProfile;

  /// No description provided for @categoryGovernance.
  ///
  /// In vi, this message translates to:
  /// **'Quản trị & Điều hành'**
  String get categoryGovernance;

  /// No description provided for @serviceCheckInOut.
  ///
  /// In vi, this message translates to:
  /// **'Chấm công vào/ra'**
  String get serviceCheckInOut;

  /// No description provided for @serviceShiftSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch ca làm việc'**
  String get serviceShiftSchedule;

  /// No description provided for @serviceMonthlyTimesheet.
  ///
  /// In vi, this message translates to:
  /// **'Lịch công tháng'**
  String get serviceMonthlyTimesheet;

  /// No description provided for @serviceHolidays.
  ///
  /// In vi, this message translates to:
  /// **'Ngày lễ trong năm'**
  String get serviceHolidays;

  /// No description provided for @serviceLeave.
  ///
  /// In vi, this message translates to:
  /// **'Xin nghỉ phép'**
  String get serviceLeave;

  /// No description provided for @serviceOvertime.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký tăng ca'**
  String get serviceOvertime;

  /// No description provided for @serviceCorrection.
  ///
  /// In vi, this message translates to:
  /// **'Sửa công'**
  String get serviceCorrection;

  /// No description provided for @serviceTrackRequests.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi yêu cầu'**
  String get serviceTrackRequests;

  /// No description provided for @serviceSalaryTable.
  ///
  /// In vi, this message translates to:
  /// **'Bảng lương tháng'**
  String get serviceSalaryTable;

  /// No description provided for @servicePayslip.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu lương'**
  String get servicePayslip;

  /// No description provided for @serviceRewards.
  ///
  /// In vi, this message translates to:
  /// **'Thưởng & ghi nhận'**
  String get serviceRewards;

  /// No description provided for @serviceAllowance.
  ///
  /// In vi, this message translates to:
  /// **'Phụ cấp'**
  String get serviceAllowance;

  /// No description provided for @serviceInternalJobs.
  ///
  /// In vi, this message translates to:
  /// **'Tuyển dụng nội bộ'**
  String get serviceInternalJobs;

  /// No description provided for @serviceProfile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ cá nhân'**
  String get serviceProfile;

  /// No description provided for @serviceSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get serviceSettings;

  /// No description provided for @serviceApprovals.
  ///
  /// In vi, this message translates to:
  /// **'Phê duyệt'**
  String get serviceApprovals;

  /// No description provided for @notificationsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notificationsTitle;

  /// No description provided for @markAllRead.
  ///
  /// In vi, this message translates to:
  /// **'Đọc tất cả'**
  String get markAllRead;

  /// No description provided for @allNotificationsReadSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã đánh dấu tất cả là đã đọc'**
  String get allNotificationsReadSnackbar;

  /// No description provided for @notificationCatLeave.
  ///
  /// In vi, this message translates to:
  /// **'Phép'**
  String get notificationCatLeave;

  /// No description provided for @notificationCatSalary.
  ///
  /// In vi, this message translates to:
  /// **'Lương'**
  String get notificationCatSalary;

  /// No description provided for @notificationCatAttendance.
  ///
  /// In vi, this message translates to:
  /// **'Chấm công'**
  String get notificationCatAttendance;

  /// No description provided for @notificationCatReward.
  ///
  /// In vi, this message translates to:
  /// **'Thưởng'**
  String get notificationCatReward;

  /// No description provided for @notificationCatRecruitment.
  ///
  /// In vi, this message translates to:
  /// **'Tuyển dụng'**
  String get notificationCatRecruitment;

  /// No description provided for @notificationCatSystem.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống'**
  String get notificationCatSystem;

  /// No description provided for @calendarScreenTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch & Ca làm việc'**
  String get calendarScreenTitle;

  /// No description provided for @calendarSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tháng 09/2026 · 22 ngày công chuẩn'**
  String get calendarSubtitle;

  /// No description provided for @monthSummaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tổng hợp tháng 9'**
  String get monthSummaryTitle;

  /// No description provided for @payableWorkdays.
  ///
  /// In vi, this message translates to:
  /// **'Ngày công tính lương'**
  String get payableWorkdays;

  /// No description provided for @totalWorkHours.
  ///
  /// In vi, this message translates to:
  /// **'Tổng giờ làm việc'**
  String get totalWorkHours;

  /// No description provided for @cumulativeOvertime.
  ///
  /// In vi, this message translates to:
  /// **'Tăng ca lũy kế'**
  String get cumulativeOvertime;

  /// No description provided for @paidLeaveDays.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ phép có hưởng lương'**
  String get paidLeaveDays;

  /// No description provided for @lateEarlyArrivals.
  ///
  /// In vi, this message translates to:
  /// **'Đi muộn / Về sớm'**
  String get lateEarlyArrivals;

  /// No description provided for @legendFullWork.
  ///
  /// In vi, this message translates to:
  /// **'Đủ công'**
  String get legendFullWork;

  /// No description provided for @legendLeave.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ phép'**
  String get legendLeave;

  /// No description provided for @legendMissingTime.
  ///
  /// In vi, this message translates to:
  /// **'Thiếu giờ'**
  String get legendMissingTime;

  /// No description provided for @legendHoliday.
  ///
  /// In vi, this message translates to:
  /// **'Ngày lễ'**
  String get legendHoliday;

  /// No description provided for @holidaysTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngày lễ'**
  String get holidaysTitle;

  /// No description provided for @year2026.
  ///
  /// In vi, this message translates to:
  /// **'Năm 2026'**
  String get year2026;

  /// No description provided for @nationalHolidaysStat.
  ///
  /// In vi, this message translates to:
  /// **'Ngày lễ'**
  String get nationalHolidaysStat;

  /// No description provided for @compensatoryLeaveStat.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ bù'**
  String get compensatoryLeaveStat;

  /// No description provided for @optionalHolidaysStat.
  ///
  /// In vi, this message translates to:
  /// **'Tự chọn'**
  String get optionalHolidaysStat;

  /// No description provided for @rewardsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thưởng & ghi nhận'**
  String get rewardsTitle;

  /// No description provided for @rewardMonthHeader.
  ///
  /// In vi, this message translates to:
  /// **'Thưởng tháng 9'**
  String get rewardMonthHeader;

  /// No description provided for @paidWithMonthSalary.
  ///
  /// In vi, this message translates to:
  /// **'VND · trả cùng lương tháng 9'**
  String get paidWithMonthSalary;

  /// No description provided for @monthlyBonusStat.
  ///
  /// In vi, this message translates to:
  /// **'Thưởng tháng'**
  String get monthlyBonusStat;

  /// No description provided for @kpiBonusStat.
  ///
  /// In vi, this message translates to:
  /// **'Thưởng KPI'**
  String get kpiBonusStat;

  /// No description provided for @yearTotalBonusStat.
  ///
  /// In vi, this message translates to:
  /// **'Tổng năm 2026'**
  String get yearTotalBonusStat;

  /// No description provided for @internalRecognitionStat.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhận nội bộ'**
  String get internalRecognitionStat;

  /// No description provided for @whyReceivedBonus.
  ///
  /// In vi, this message translates to:
  /// **'Vì sao bạn nhận thưởng'**
  String get whyReceivedBonus;

  /// No description provided for @bonusHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử thưởng'**
  String get bonusHistoryTitle;

  /// No description provided for @internalRecruitmentTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tuyển dụng nội bộ'**
  String get internalRecruitmentTitle;

  /// No description provided for @searchJobPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Tìm vị trí, bộ phận...'**
  String get searchJobPlaceholder;

  /// No description provided for @openPositionsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} vị trí mở cho ứng viên nội bộ'**
  String openPositionsCount(int count);

  /// No description provided for @tagNew.
  ///
  /// In vi, this message translates to:
  /// **'MỚI'**
  String get tagNew;

  /// No description provided for @jobDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết vị trí'**
  String get jobDetailTitle;

  /// No description provided for @applyButton.
  ///
  /// In vi, this message translates to:
  /// **'Ứng tuyển'**
  String get applyButton;

  /// No description provided for @jobDescriptionSection.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả công việc'**
  String get jobDescriptionSection;

  /// No description provided for @jobRequirementsSection.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu'**
  String get jobRequirementsSection;

  /// No description provided for @jobBenefitsSection.
  ///
  /// In vi, this message translates to:
  /// **'Phúc lợi'**
  String get jobBenefitsSection;

  /// No description provided for @applySuccessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ứng tuyển thành công!'**
  String get applySuccessTitle;

  /// No description provided for @applySuccessMsg.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ nội bộ của bạn đã được chuyển tới Bộ phận Nhân sự & Quản lý tuyển dụng.'**
  String get applySuccessMsg;

  /// No description provided for @emptyDataMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hiện chưa có dữ liệu nào để hiển thị'**
  String get emptyDataMessage;

  /// No description provided for @errorOccurredTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra sự cố'**
  String get errorOccurredTitle;

  /// No description provided for @errorOccurredMessage.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải dữ liệu lúc này. Vui lòng kiểm tra lại kết nối mạng.'**
  String get errorOccurredMessage;

  /// No description provided for @successDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thao tác thành công!'**
  String get successDialogTitle;

  /// No description provided for @successDialogMessage.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu của bạn đã được ghi nhận và chuyển cho cấp trên xử lý.'**
  String get successDialogMessage;

  /// No description provided for @doneButton.
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get doneButton;

  /// No description provided for @filterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get filterAll;

  /// No description provided for @forgotPasswordShort.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgotPasswordShort;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Vì lý do bảo mật, mật khẩu chỉ được cấp lại bởi bộ phận IT. Vui lòng liên hệ IT và cung cấp mã nhân viên để được hỗ trợ.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @itHotlineLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tổng đài IT · máy lẻ 1234'**
  String get itHotlineLabel;

  /// No description provided for @itHotlineNumber.
  ///
  /// In vi, this message translates to:
  /// **'028 3930 1234'**
  String get itHotlineNumber;

  /// No description provided for @itEmailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get itEmailLabel;

  /// No description provided for @itEmailValue.
  ///
  /// In vi, this message translates to:
  /// **'it.helpdesk@vstech.vn'**
  String get itEmailValue;

  /// No description provided for @itSupportHoursLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giờ hỗ trợ'**
  String get itSupportHoursLabel;

  /// No description provided for @itSupportHoursValue.
  ///
  /// In vi, this message translates to:
  /// **'T2 – T7 · 07:30 – 18:00'**
  String get itSupportHoursValue;

  /// No description provided for @itSecurityDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'IT sẽ xác minh danh tính qua quản lý trực tiếp trước khi cấp mật khẩu tạm. Đổi mật khẩu ngay sau lần đăng nhập đầu tiên.'**
  String get itSecurityDisclaimer;

  /// No description provided for @callItDepartmentBtn.
  ///
  /// In vi, this message translates to:
  /// **'Gọi bộ phận IT'**
  String get callItDepartmentBtn;

  /// No description provided for @backToLoginBtn.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại đăng nhập'**
  String get backToLoginBtn;

  /// No description provided for @loginWithFaceId.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập bằng Face ID'**
  String get loginWithFaceId;

  /// No description provided for @loginWithFingerprint.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập bằng vân tay'**
  String get loginWithFingerprint;

  /// No description provided for @faceIdAuthReason.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực Face ID để đăng nhập'**
  String get faceIdAuthReason;

  /// No description provided for @fingerprintAuthReason.
  ///
  /// In vi, this message translates to:
  /// **'Quét vân tay để đăng nhập'**
  String get fingerprintAuthReason;

  /// No description provided for @orDivider.
  ///
  /// In vi, this message translates to:
  /// **'hoặc'**
  String get orDivider;

  /// No description provided for @faceIdLoginTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập bằng Face ID'**
  String get faceIdLoginTitle;

  /// No description provided for @faceIdLoginSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhận diện khuôn mặt bảo mật thông minh'**
  String get faceIdLoginSubtitle;

  /// No description provided for @faceDetecting.
  ///
  /// In vi, this message translates to:
  /// **'Đang nhận diện khuôn mặt...'**
  String get faceDetecting;

  /// No description provided for @faceAligning.
  ///
  /// In vi, this message translates to:
  /// **'Đang căn chỉnh góc mặt...'**
  String get faceAligning;

  /// No description provided for @faceMatching.
  ///
  /// In vi, this message translates to:
  /// **'Đối soát dữ liệu sinh trắc học...'**
  String get faceMatching;

  /// No description provided for @faceAuthSuccessGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Nhận diện thành công! Chào {name}'**
  String faceAuthSuccessGreeting(String name);

  /// No description provided for @systemBiometricAuthButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực vân tay / Face ID hệ thống'**
  String get systemBiometricAuthButton;

  /// No description provided for @loginWithCredentialsButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập bằng mã nhân viên / mật khẩu'**
  String get loginWithCredentialsButton;

  /// No description provided for @biometricAuthReason.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực sinh trắc học để đăng nhập vào vstech-hrm'**
  String get biometricAuthReason;

  /// No description provided for @punchSuccessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chấm công thành công!'**
  String get punchSuccessTitle;

  /// No description provided for @checkInRecorded.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhận Giờ vào (Check-in)'**
  String get checkInRecorded;

  /// No description provided for @checkOutRecorded.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhận Giờ ra (Check-out)'**
  String get checkOutRecorded;

  /// No description provided for @timeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian'**
  String get timeLabel;

  /// No description provided for @classificationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Phân loại'**
  String get classificationLabel;

  /// No description provided for @locationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Địa điểm'**
  String get locationLabel;

  /// No description provided for @methodLabel.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức'**
  String get methodLabel;

  /// No description provided for @methodFaceGps.
  ///
  /// In vi, this message translates to:
  /// **'Nhận diện khuôn mặt + GPS'**
  String get methodFaceGps;

  /// No description provided for @completeAndHomeCta.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất & Về trang chủ'**
  String get completeAndHomeCta;

  /// No description provided for @dailyLogSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhật ký từng ngày'**
  String get dailyLogSectionTitle;

  /// No description provided for @holidaysLink.
  ///
  /// In vi, this message translates to:
  /// **'Ngày lễ'**
  String get holidaysLink;

  /// No description provided for @statusWorking.
  ///
  /// In vi, this message translates to:
  /// **'Đang làm'**
  String get statusWorking;

  /// No description provided for @statusMissingCheckOut.
  ///
  /// In vi, this message translates to:
  /// **'Thiếu giờ ra'**
  String get statusMissingCheckOut;

  /// No description provided for @statusFullWork.
  ///
  /// In vi, this message translates to:
  /// **'Đủ công'**
  String get statusFullWork;

  /// No description provided for @statusWeeklyOff.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ tuần'**
  String get statusWeeklyOff;

  /// No description provided for @statusFullWorkOt.
  ///
  /// In vi, this message translates to:
  /// **'Đủ công · TC {hours}h'**
  String statusFullWorkOt(String hours);

  /// No description provided for @statusLateMinutes.
  ///
  /// In vi, this message translates to:
  /// **'Đi muộn {minutes} phút'**
  String statusLateMinutes(String minutes);

  /// No description provided for @noShiftAssigned.
  ///
  /// In vi, this message translates to:
  /// **'Không có ca'**
  String get noShiftAssigned;

  /// No description provided for @monthlyWorkdaysUnit.
  ///
  /// In vi, this message translates to:
  /// **'ngày công'**
  String get monthlyWorkdaysUnit;

  /// No description provided for @daysCountUnit.
  ///
  /// In vi, this message translates to:
  /// **'{count} ngày'**
  String daysCountUnit(int count);

  /// No description provided for @faceScanSuccessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực thành công!'**
  String get faceScanSuccessTitle;

  /// No description provided for @faceScanSuccessSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống đã lưu nhận diện khuôn mặt và vị trí'**
  String get faceScanSuccessSubtitle;

  /// No description provided for @faceScanningTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang nhận diện...'**
  String get faceScanningTitle;

  /// No description provided for @faceScanningSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi ảnh quét mặt và toạ độ GPS về máy chủ'**
  String get faceScanningSubtitle;

  /// No description provided for @faceAlignPromptTitle.
  ///
  /// In vi, this message translates to:
  /// **'Căn chỉnh khuôn mặt'**
  String get faceAlignPromptTitle;

  /// No description provided for @faceAlignPromptSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Giữ thẳng đầu và nhìn trực diện vào camera'**
  String get faceAlignPromptSubtitle;

  /// No description provided for @emergencyContactInfo.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ khẩn cấp: 0908 221 470 (Người thân)'**
  String get emergencyContactInfo;

  /// No description provided for @documentsAndRecordsInfo.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ nhân viên & Hợp đồng lao động'**
  String get documentsAndRecordsInfo;

  /// No description provided for @annualLeaveCardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Số phép năm'**
  String get annualLeaveCardTitle;

  /// No description provided for @leaveRatio.
  ///
  /// In vi, this message translates to:
  /// **'{used} / {total} ngày'**
  String leaveRatio(String used, String total);

  /// No description provided for @usedDaysCount.
  ///
  /// In vi, this message translates to:
  /// **'Đã dùng {count}'**
  String usedDaysCount(String count);

  /// No description provided for @remainingDaysCount.
  ///
  /// In vi, this message translates to:
  /// **'Còn lại {count}'**
  String remainingDaysCount(String count);

  /// No description provided for @announcementsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin chính thức từ HR & Ban Giám Đốc'**
  String get announcementsSubtitle;

  /// No description provided for @announcementScopeAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get announcementScopeAll;

  /// No description provided for @announcementScopeCompany.
  ///
  /// In vi, this message translates to:
  /// **'Toàn công ty'**
  String get announcementScopeCompany;

  /// No description provided for @announcementScopeOffice.
  ///
  /// In vi, this message translates to:
  /// **'Khối văn phòng'**
  String get announcementScopeOffice;

  /// No description provided for @announcementScopeFactory.
  ///
  /// In vi, this message translates to:
  /// **'Phân xưởng & Tổ'**
  String get announcementScopeFactory;

  /// No description provided for @announcementScopeDept.
  ///
  /// In vi, this message translates to:
  /// **'Phòng ban'**
  String get announcementScopeDept;

  /// No description provided for @announcementTargetScope.
  ///
  /// In vi, this message translates to:
  /// **'Phạm vi: {scope}'**
  String announcementTargetScope(String scope);

  /// No description provided for @announcementAuthor.
  ///
  /// In vi, this message translates to:
  /// **'Người gửi: {author}'**
  String announcementAuthor(String author);

  /// No description provided for @announcementPublishDate.
  ///
  /// In vi, this message translates to:
  /// **'Đăng lúc: {date}'**
  String announcementPublishDate(String date);

  /// No description provided for @announcementUnreadBadge.
  ///
  /// In vi, this message translates to:
  /// **'MỚI'**
  String get announcementUnreadBadge;

  /// No description provided for @announcementMarkAllRead.
  ///
  /// In vi, this message translates to:
  /// **'Đã đọc tất cả'**
  String get announcementMarkAllRead;

  /// No description provided for @announcementEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thông báo nào trong mục này'**
  String get announcementEmpty;

  /// No description provided for @announcementDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết thông báo'**
  String get announcementDetailTitle;

  /// No description provided for @announcementReadConfirmed.
  ///
  /// In vi, this message translates to:
  /// **'Đã đánh dấu đã đọc'**
  String get announcementReadConfirmed;

  /// No description provided for @laborProfileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ lao động & Hợp đồng'**
  String get laborProfileTitle;

  /// No description provided for @contractSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hợp đồng lao động & Phụ lục'**
  String get contractSectionTitle;

  /// No description provided for @contractNumberLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số hợp đồng'**
  String get contractNumberLabel;

  /// No description provided for @contractTypeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Loại hợp đồng'**
  String get contractTypeLabel;

  /// No description provided for @contractSigningDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày ký'**
  String get contractSigningDateLabel;

  /// No description provided for @contractEffectiveDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày hiệu lực'**
  String get contractEffectiveDateLabel;

  /// No description provided for @contractExpirationDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày hết hạn'**
  String get contractExpirationDateLabel;

  /// No description provided for @contractStatusLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tình trạng HĐ'**
  String get contractStatusLabel;

  /// No description provided for @contractStatusActive.
  ///
  /// In vi, this message translates to:
  /// **'Đang có hiệu lực'**
  String get contractStatusActive;

  /// No description provided for @salaryAndBenefitsSection.
  ///
  /// In vi, this message translates to:
  /// **'Mức lương & Chế độ thoả thuận'**
  String get salaryAndBenefitsSection;

  /// No description provided for @agreedBaseSalary.
  ///
  /// In vi, this message translates to:
  /// **'Lương cơ bản thoả thuận'**
  String get agreedBaseSalary;

  /// No description provided for @responsibilityAllowance.
  ///
  /// In vi, this message translates to:
  /// **'Phụ cấp trách nhiệm'**
  String get responsibilityAllowance;

  /// No description provided for @mealAllowance.
  ///
  /// In vi, this message translates to:
  /// **'Phụ cấp cơm trưa'**
  String get mealAllowance;

  /// No description provided for @overtimeRateDescription.
  ///
  /// In vi, this message translates to:
  /// **'Hệ số tăng ca: 150% (ngày thường), 200% (nghỉ tuần), 300% (lễ tết)'**
  String get overtimeRateDescription;

  /// No description provided for @socialInsuranceSection.
  ///
  /// In vi, this message translates to:
  /// **'Bảo hiểm xã hội & Y tế'**
  String get socialInsuranceSection;

  /// No description provided for @socialInsuranceNumber.
  ///
  /// In vi, this message translates to:
  /// **'Mã số BHXH'**
  String get socialInsuranceNumber;

  /// No description provided for @hospitalRegistered.
  ///
  /// In vi, this message translates to:
  /// **'Nơi đăng ký KCB ban đầu'**
  String get hospitalRegistered;

  /// No description provided for @insuranceSalaryLevel.
  ///
  /// In vi, this message translates to:
  /// **'Mức lương đóng BHXH'**
  String get insuranceSalaryLevel;

  /// No description provided for @insuranceStatus.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái sổ BHXH'**
  String get insuranceStatus;

  /// No description provided for @insuranceStatusActive.
  ///
  /// In vi, this message translates to:
  /// **'Đang đóng đầy đủ'**
  String get insuranceStatusActive;

  /// No description provided for @contractAttachmentsSection.
  ///
  /// In vi, this message translates to:
  /// **'Tệp đính kèm & Bản scan HĐLĐ'**
  String get contractAttachmentsSection;

  /// No description provided for @downloadAttachmentButton.
  ///
  /// In vi, this message translates to:
  /// **'Tải về'**
  String get downloadAttachmentButton;

  /// No description provided for @previewAttachmentButton.
  ///
  /// In vi, this message translates to:
  /// **'Xem trước'**
  String get previewAttachmentButton;

  /// No description provided for @laborProfileHrNotice.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin hợp đồng và chế độ lao động do Phòng Nhân sự quản lý. Người lao động không thể tự chỉnh sửa trên ứng dụng di động. Mọi thắc mắc xin liên hệ HR.'**
  String get laborProfileHrNotice;

  /// No description provided for @offlineQueueTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hàng đợi chấm công ngoại tuyến'**
  String get offlineQueueTitle;

  /// No description provided for @offlineQueueSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu chấm công lưu trên máy khi mất mạng'**
  String get offlineQueueSubtitle;

  /// No description provided for @statusRecorded.
  ///
  /// In vi, this message translates to:
  /// **'Đã ghi nhận'**
  String get statusRecorded;

  /// No description provided for @statusPendingSync.
  ///
  /// In vi, this message translates to:
  /// **'Chờ đồng bộ'**
  String get statusPendingSync;

  /// No description provided for @statusSyncing.
  ///
  /// In vi, this message translates to:
  /// **'Đang đồng bộ...'**
  String get statusSyncing;

  /// No description provided for @statusSynced.
  ///
  /// In vi, this message translates to:
  /// **'Đã đồng bộ'**
  String get statusSynced;

  /// No description provided for @statusSyncFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đồng bộ thất bại'**
  String get statusSyncFailed;

  /// No description provided for @syncAllButton.
  ///
  /// In vi, this message translates to:
  /// **'Đồng bộ tất cả'**
  String get syncAllButton;

  /// No description provided for @syncRetryButton.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get syncRetryButton;

  /// No description provided for @persistentQueueWarning.
  ///
  /// In vi, this message translates to:
  /// **'CẢNH BÁO: Còn {count} lượt chấm công chưa gửi lên máy chủ! Hãy đồng bộ để không bị mất công.'**
  String persistentQueueWarning(int count);

  /// No description provided for @factoryRemindersTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở ca kíp nhà máy'**
  String get factoryRemindersTitle;

  /// No description provided for @factoryRemindersSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở giờ vào ca & ăn trưa (do không được mang điện thoại vào xưởng)'**
  String get factoryRemindersSubtitle;

  /// No description provided for @reminderMorningShift.
  ///
  /// In vi, this message translates to:
  /// **'Vào ca sáng (07:45)'**
  String get reminderMorningShift;

  /// No description provided for @reminderLunchBreak.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ ăn trưa (11:45)'**
  String get reminderLunchBreak;

  /// No description provided for @reminderAfternoonShift.
  ///
  /// In vi, this message translates to:
  /// **'Vào ca chiều (12:45)'**
  String get reminderAfternoonShift;

  /// No description provided for @reminderShiftEnd.
  ///
  /// In vi, this message translates to:
  /// **'Tan ca về (17:00)'**
  String get reminderShiftEnd;

  /// No description provided for @reminderSavedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu cài đặt nhắc nhở ca kíp thành công!'**
  String get reminderSavedSuccess;

  /// No description provided for @geofenceDistanceLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng cách toạ độ: {meters}m so với tâm nhà máy'**
  String geofenceDistanceLabel(int meters);

  /// No description provided for @geofenceWithinRange.
  ///
  /// In vi, this message translates to:
  /// **'Trong bán kính hợp lệ (≤ 50m)'**
  String get geofenceWithinRange;

  /// No description provided for @geofenceOutOfRange.
  ///
  /// In vi, this message translates to:
  /// **'Ngoài bán kính nhà máy (> 50m)'**
  String get geofenceOutOfRange;

  /// No description provided for @checkInGpsSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã ghi nhận Check-in GPS thành công!'**
  String get checkInGpsSuccess;

  /// No description provided for @checkOutGpsSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã ghi nhận Check-out GPS thành công!'**
  String get checkOutGpsSuccess;

  /// No description provided for @qrScannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quét mã QR đăng nhập'**
  String get qrScannerTitle;

  /// No description provided for @qrScannerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hướng camera vào mã QR trên màn hình Cổng thông tin Web'**
  String get qrScannerSubtitle;

  /// No description provided for @qrTorchToggle.
  ///
  /// In vi, this message translates to:
  /// **'Bật/Tắt đèn Flash'**
  String get qrTorchToggle;

  /// No description provided for @qrSamplePayloadsButton.
  ///
  /// In vi, this message translates to:
  /// **'Mã QR mẫu để thử nghiệm'**
  String get qrSamplePayloadsButton;

  /// No description provided for @qrConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận đăng nhập Web'**
  String get qrConfirmTitle;

  /// No description provided for @qrConfirmPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có đang đăng nhập vào Cổng thông tin VSTech không?'**
  String get qrConfirmPrompt;

  /// No description provided for @qrBrowserLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trình duyệt'**
  String get qrBrowserLabel;

  /// No description provided for @qrDeviceLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị / Máy tính trạm'**
  String get qrDeviceLabel;

  /// No description provided for @qrLocationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí đăng nhập'**
  String get qrLocationLabel;

  /// No description provided for @qrRequestTimeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian yêu cầu'**
  String get qrRequestTimeLabel;

  /// No description provided for @qrIpAddressLabel.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ IP'**
  String get qrIpAddressLabel;

  /// No description provided for @qrApproveButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận đăng nhập'**
  String get qrApproveButton;

  /// No description provided for @qrRejectButton.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get qrRejectButton;

  /// No description provided for @qrBiometricPromptReason.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực sinh trắc học để phê duyệt đăng nhập trên Web'**
  String get qrBiometricPromptReason;

  /// No description provided for @qrLoginApprovedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập thành công! Phiên làm việc trên máy tính đã được kích hoạt.'**
  String get qrLoginApprovedSuccess;

  /// No description provided for @qrLoginRejectedMsg.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã từ chối yêu cầu đăng nhập này.'**
  String get qrLoginRejectedMsg;

  /// No description provided for @qrExpiredWarning.
  ///
  /// In vi, this message translates to:
  /// **'Mã QR này đã hết hạn. Vui lòng làm mới trang web để lấy mã mới.'**
  String get qrExpiredWarning;

  /// No description provided for @qrInvalidWarning.
  ///
  /// In vi, this message translates to:
  /// **'Mã QR không hợp lệ hoặc không thuộc hệ thống VSTech.'**
  String get qrInvalidWarning;

  /// No description provided for @qrUsedWarning.
  ///
  /// In vi, this message translates to:
  /// **'Mã QR này đã được sử dụng trước đó.'**
  String get qrUsedWarning;

  /// No description provided for @qrCancelledWarning.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu đăng nhập này đã bị huỷ bởi máy tính trạm.'**
  String get qrCancelledWarning;

  /// No description provided for @execDashboardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bảng điều hành Ban Giám Đốc'**
  String get execDashboardTitle;

  /// No description provided for @execRoleTag.
  ///
  /// In vi, this message translates to:
  /// **'TỔNG GIÁM ĐỐC / CEO'**
  String get execRoleTag;

  /// No description provided for @execGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Chào anh Lê Hoàng'**
  String get execGreeting;

  /// No description provided for @execWaitingBadge.
  ///
  /// In vi, this message translates to:
  /// **'ĐƠN CHỜ PHÊ DUYỆT CUỐI'**
  String get execWaitingBadge;

  /// No description provided for @execWaitingSub.
  ///
  /// In vi, this message translates to:
  /// **'Cần ý kiến phê duyệt của Giám đốc'**
  String get execWaitingSub;

  /// No description provided for @execOldestWaiting.
  ///
  /// In vi, this message translates to:
  /// **'Đơn cũ nhất: 18h trước'**
  String get execOldestWaiting;

  /// No description provided for @execCompanyNow.
  ///
  /// In vi, this message translates to:
  /// **'TÌNH HÌNH DOANH NGHIỆP HÔM NAY'**
  String get execCompanyNow;

  /// No description provided for @execHeadcount.
  ///
  /// In vi, this message translates to:
  /// **'Tổng nhân sự'**
  String get execHeadcount;

  /// No description provided for @execAttendanceRate.
  ///
  /// In vi, this message translates to:
  /// **'Tỷ lệ đi làm'**
  String get execAttendanceRate;

  /// No description provided for @execMonthlyPayroll.
  ///
  /// In vi, this message translates to:
  /// **'Quỹ lương tháng'**
  String get execMonthlyPayroll;

  /// No description provided for @execOvertimeHours.
  ///
  /// In vi, this message translates to:
  /// **'Giờ tăng ca tháng'**
  String get execOvertimeHours;

  /// No description provided for @execTurnoverRate.
  ///
  /// In vi, this message translates to:
  /// **'Tỷ lệ nghỉ việc'**
  String get execTurnoverRate;

  /// No description provided for @execNeedAttention.
  ///
  /// In vi, this message translates to:
  /// **'Rủi ro & Tuân thủ cần chú ý'**
  String get execNeedAttention;

  /// No description provided for @execSeeAllAlerts.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả cảnh báo'**
  String get execSeeAllAlerts;

  /// No description provided for @execAttendanceByDept.
  ///
  /// In vi, this message translates to:
  /// **'Tỷ lệ đi làm theo khối/xưởng'**
  String get execAttendanceByDept;

  /// No description provided for @finalApprovalTitle.
  ///
  /// In vi, this message translates to:
  /// **'Phê duyệt cuối'**
  String get finalApprovalTitle;

  /// No description provided for @finalApprovalCaption.
  ///
  /// In vi, this message translates to:
  /// **'Cấp thẩm quyền cao nhất · Chu trình kết thúc'**
  String get finalApprovalCaption;

  /// No description provided for @finalApprovalDelegateBtn.
  ///
  /// In vi, this message translates to:
  /// **'Ủy quyền'**
  String get finalApprovalDelegateBtn;

  /// No description provided for @finalApprovalBatchHint.
  ///
  /// In vi, this message translates to:
  /// **'Phê duyệt nhanh các đơn đã qua kiểm tra của HR & Kế toán'**
  String get finalApprovalBatchHint;

  /// No description provided for @finalApprovalApproveAll.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt tất cả'**
  String get finalApprovalApproveAll;

  /// No description provided for @finalApprovalFinancialImpact.
  ///
  /// In vi, this message translates to:
  /// **'TÁC ĐỘNG TÀI CHÍNH'**
  String get finalApprovalFinancialImpact;

  /// No description provided for @finalApprovalBudget.
  ///
  /// In vi, this message translates to:
  /// **'NGÂN SÁCH DỰ PHÒNG'**
  String get finalApprovalBudget;

  /// No description provided for @finalApprovalApproveBtn.
  ///
  /// In vi, this message translates to:
  /// **'Phê duyệt cuối'**
  String get finalApprovalApproveBtn;

  /// No description provided for @finalApprovalRejectBtn.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get finalApprovalRejectBtn;

  /// No description provided for @finalApprovalSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã phê duyệt cuối thành công. HR sẽ tiến hành thực thi.'**
  String get finalApprovalSuccess;

  /// No description provided for @finalApprovalRejected.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối đơn đề xuất.'**
  String get finalApprovalRejected;

  /// No description provided for @riskTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo Rủi ro & Tuân thủ'**
  String get riskTitle;

  /// No description provided for @riskCaption.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo qua 3 phân tầng · Giao việc trực tiếp cho HR'**
  String get riskCaption;

  /// No description provided for @riskTierCritical.
  ///
  /// In vi, this message translates to:
  /// **'Nghiêm trọng'**
  String get riskTierCritical;

  /// No description provided for @riskTierHigh.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo cao'**
  String get riskTierHigh;

  /// No description provided for @riskTierMedium.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi'**
  String get riskTierMedium;

  /// No description provided for @riskAssignHr.
  ///
  /// In vi, this message translates to:
  /// **'Giao việc cho HR'**
  String get riskAssignHr;

  /// No description provided for @riskAssignedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã giao việc cho bộ phận HR xử lý!'**
  String get riskAssignedSuccess;

  /// No description provided for @delTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trung tâm Ủy quyền'**
  String get delTitle;

  /// No description provided for @delCaption.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển giao quyền phê duyệt khi vắng mặt hoặc đi công tác'**
  String get delCaption;

  /// No description provided for @delSelectPerson.
  ///
  /// In vi, this message translates to:
  /// **'Người nhận ủy quyền'**
  String get delSelectPerson;

  /// No description provided for @delPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian ủy quyền'**
  String get delPeriod;

  /// No description provided for @delFromDate.
  ///
  /// In vi, this message translates to:
  /// **'Từ ngày'**
  String get delFromDate;

  /// No description provided for @delToDate.
  ///
  /// In vi, this message translates to:
  /// **'Đến ngày'**
  String get delToDate;

  /// No description provided for @delTotalDays.
  ///
  /// In vi, this message translates to:
  /// **'Tổng cộng'**
  String get delTotalDays;

  /// No description provided for @delScope.
  ///
  /// In vi, this message translates to:
  /// **'Phạm vi thẩm quyền'**
  String get delScope;

  /// No description provided for @delAllScope.
  ///
  /// In vi, this message translates to:
  /// **'Toàn bộ thẩm quyền'**
  String get delAllScope;

  /// No description provided for @delPartialScope.
  ///
  /// In vi, this message translates to:
  /// **'Theo từng loại đơn'**
  String get delPartialScope;

  /// No description provided for @delLimit.
  ///
  /// In vi, this message translates to:
  /// **'Hạn mức duyệt tối đa'**
  String get delLimit;

  /// No description provided for @delLimitHint.
  ///
  /// In vi, this message translates to:
  /// **'Các đơn vượt hạn mức này vẫn sẽ chuyển trực tiếp cho bạn khi online'**
  String get delLimitHint;

  /// No description provided for @delUnlimited.
  ///
  /// In vi, this message translates to:
  /// **'Không giới hạn'**
  String get delUnlimited;

  /// No description provided for @delSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận thiết lập ủy quyền'**
  String get delSubmit;

  /// No description provided for @delActiveList.
  ///
  /// In vi, this message translates to:
  /// **'Ủy quyền đang hiệu lực'**
  String get delActiveList;

  /// No description provided for @delRevoke.
  ///
  /// In vi, this message translates to:
  /// **'Hủy ủy quyền'**
  String get delRevoke;

  /// No description provided for @delRevokeSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã hủy ủy quyền thành công!'**
  String get delRevokeSuccess;

  /// No description provided for @delCreateSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập ủy quyền phê duyệt thành công!'**
  String get delCreateSuccess;

  /// No description provided for @delRunning.
  ///
  /// In vi, this message translates to:
  /// **'Đang chạy'**
  String get delRunning;

  /// No description provided for @requestTypeOnDuty.
  ///
  /// In vi, this message translates to:
  /// **'Đi việc ngoài'**
  String get requestTypeOnDuty;

  /// No description provided for @requestTypeBusinessTrip.
  ///
  /// In vi, this message translates to:
  /// **'Công tác'**
  String get requestTypeBusinessTrip;

  /// No description provided for @requestTypeShiftSwap.
  ///
  /// In vi, this message translates to:
  /// **'Đổi ca'**
  String get requestTypeShiftSwap;

  /// No description provided for @onDutyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký Đi việc ngoài'**
  String get onDutyTitle;

  /// No description provided for @onDutySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Công tác ngắn hạn trong ngày (gặp khách hàng, cơ quan, việc gấp)'**
  String get onDutySubtitle;

  /// No description provided for @onDutyFromTime.
  ///
  /// In vi, this message translates to:
  /// **'Từ giờ'**
  String get onDutyFromTime;

  /// No description provided for @onDutyToTime.
  ///
  /// In vi, this message translates to:
  /// **'Đến giờ'**
  String get onDutyToTime;

  /// No description provided for @onDutyLocation.
  ///
  /// In vi, this message translates to:
  /// **'Địa điểm đến'**
  String get onDutyLocation;

  /// No description provided for @onDutyDescription.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung công việc'**
  String get onDutyDescription;

  /// No description provided for @onDutyShiftConstraintWarning.
  ///
  /// In vi, this message translates to:
  /// **'Giờ đi việc ngoài phải nằm trong ca làm việc hôm nay'**
  String get onDutyShiftConstraintWarning;

  /// No description provided for @onDutySubmitSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi đơn Đi việc ngoài thành công!'**
  String get onDutySubmitSuccess;

  /// No description provided for @businessTripTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký Công tác'**
  String get businessTripTitle;

  /// No description provided for @businessTripSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chuyến công tác nhiều ngày trong nước hoặc nước ngoài'**
  String get businessTripSubtitle;

  /// No description provided for @businessTripDestination.
  ///
  /// In vi, this message translates to:
  /// **'Nơi đến / Địa điểm'**
  String get businessTripDestination;

  /// No description provided for @businessTripColleagues.
  ///
  /// In vi, this message translates to:
  /// **'Đồng nghiệp cùng đi'**
  String get businessTripColleagues;

  /// No description provided for @businessTripPurpose.
  ///
  /// In vi, this message translates to:
  /// **'Mục đích công tác'**
  String get businessTripPurpose;

  /// No description provided for @businessTripPlan.
  ///
  /// In vi, this message translates to:
  /// **'Kế hoạch / Lịch trình'**
  String get businessTripPlan;

  /// No description provided for @businessTripSubmitSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi đơn Công tác thành công!'**
  String get businessTripSubmitSuccess;

  /// No description provided for @offSiteTimesheetLabel.
  ///
  /// In vi, this message translates to:
  /// **'Công tác'**
  String get offSiteTimesheetLabel;

  /// No description provided for @offSiteCreditDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đã ghi nhận đủ công (không tính muộn/về sớm)'**
  String get offSiteCreditDesc;

  /// No description provided for @leaveBalanceBreakdownTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết quỹ nghỉ phép'**
  String get leaveBalanceBreakdownTitle;

  /// No description provided for @leaveTypeCompOff.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ bù (từ tăng ca)'**
  String get leaveTypeCompOff;

  /// No description provided for @leaveTypeMaternity.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ thai sản'**
  String get leaveTypeMaternity;

  /// No description provided for @leaveTypePaidPersonal.
  ///
  /// In vi, this message translates to:
  /// **'Việc riêng có lương'**
  String get leaveTypePaidPersonal;

  /// No description provided for @leaveBalanceEntitlement.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu chuẩn'**
  String get leaveBalanceEntitlement;

  /// No description provided for @leaveBalanceUsed.
  ///
  /// In vi, this message translates to:
  /// **'Đã dùng'**
  String get leaveBalanceUsed;

  /// No description provided for @leaveBalancePending.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ duyệt'**
  String get leaveBalancePending;

  /// No description provided for @leaveBalanceAvailable.
  ///
  /// In vi, this message translates to:
  /// **'Khả dụng'**
  String get leaveBalanceAvailable;

  /// No description provided for @leaveHalfDayMorning.
  ///
  /// In vi, this message translates to:
  /// **'Nửa ca sáng'**
  String get leaveHalfDayMorning;

  /// No description provided for @leaveHalfDayAfternoon.
  ///
  /// In vi, this message translates to:
  /// **'Nửa ca chiều'**
  String get leaveHalfDayAfternoon;

  /// No description provided for @leaveHandoverPerson.
  ///
  /// In vi, this message translates to:
  /// **'Người bàn giao / thay thế'**
  String get leaveHandoverPerson;

  /// No description provided for @leaveAttachment.
  ///
  /// In vi, this message translates to:
  /// **'Giấy tờ / Chứng từ đính kèm'**
  String get leaveAttachment;

  /// No description provided for @leaveExceedBalanceWarning.
  ///
  /// In vi, this message translates to:
  /// **'Số ngày nghỉ vượt quá số phép khả dụng ({days} ngày)!'**
  String leaveExceedBalanceWarning(String days);

  /// No description provided for @leaveExcludeWeekendHint.
  ///
  /// In vi, this message translates to:
  /// **'Đã tự động trừ ngày nghỉ cuối tuần và ngày lễ'**
  String get leaveExcludeWeekendHint;

  /// No description provided for @leaveSaveDraftBtn.
  ///
  /// In vi, this message translates to:
  /// **'Lưu nháp'**
  String get leaveSaveDraftBtn;

  /// No description provided for @leaveDraftSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu bản nháp thành công!'**
  String get leaveDraftSaved;

  /// No description provided for @otRateWeekday.
  ///
  /// In vi, this message translates to:
  /// **'Ngày thường (150%)'**
  String get otRateWeekday;

  /// No description provided for @otRateWeekend.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ tuần (200%)'**
  String get otRateWeekend;

  /// No description provided for @otRateHoliday.
  ///
  /// In vi, this message translates to:
  /// **'Ngày lễ (300%)'**
  String get otRateHoliday;

  /// No description provided for @otCompensationType.
  ///
  /// In vi, this message translates to:
  /// **'Hình thức tính bù'**
  String get otCompensationType;

  /// No description provided for @otCompensationPay.
  ///
  /// In vi, this message translates to:
  /// **'Hưởng tiền lương tăng ca'**
  String get otCompensationPay;

  /// No description provided for @otCompensationCompOff.
  ///
  /// In vi, this message translates to:
  /// **'Quy đổi nghỉ bù (Comp-off)'**
  String get otCompensationCompOff;

  /// No description provided for @otMonthlyCapWarning.
  ///
  /// In vi, this message translates to:
  /// **'Chú ý: Bạn đã tích lũy {current}h/40h trần tăng ca tháng này'**
  String otMonthlyCapWarning(String current);

  /// No description provided for @otMonthlyCapExceeded.
  ///
  /// In vi, this message translates to:
  /// **'Không thể gửi đơn: Tổng giờ tăng ca vượt quá 40h/tháng theo BLLĐ 2019!'**
  String get otMonthlyCapExceeded;

  /// No description provided for @otMonthlyApprovedHeader.
  ///
  /// In vi, this message translates to:
  /// **'Tổng giờ tăng ca đã duyệt: {hours}h'**
  String otMonthlyApprovedHeader(String hours);

  /// No description provided for @extraHoursBalanceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quỹ giờ làm thêm & Nghỉ bù'**
  String get extraHoursBalanceTitle;

  /// No description provided for @extraHoursMonth.
  ///
  /// In vi, this message translates to:
  /// **'Giờ OT tháng này'**
  String get extraHoursMonth;

  /// No description provided for @extraHoursQuarter.
  ///
  /// In vi, this message translates to:
  /// **'Giờ OT quý này'**
  String get extraHoursQuarter;

  /// No description provided for @extraHoursPayable.
  ///
  /// In vi, this message translates to:
  /// **'Giờ hưởng lương'**
  String get extraHoursPayable;

  /// No description provided for @extraHoursConvertedCompOff.
  ///
  /// In vi, this message translates to:
  /// **'Giờ đã đổi nghỉ bù'**
  String get extraHoursConvertedCompOff;

  /// No description provided for @compOffConversionRule.
  ///
  /// In vi, this message translates to:
  /// **'Quy đổi: 8 giờ tăng ca = 1 ngày nghỉ bù'**
  String get compOffConversionRule;

  /// No description provided for @shiftSwapEligibilityCheck.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra điều kiện đổi ca'**
  String get shiftSwapEligibilityCheck;

  /// No description provided for @shiftSwapBranchMismatch.
  ///
  /// In vi, this message translates to:
  /// **'Đồng nghiệp khác chi nhánh ({branch})'**
  String shiftSwapBranchMismatch(String branch);

  /// No description provided for @shiftSwapGradeMismatch.
  ///
  /// In vi, this message translates to:
  /// **'Cấp bậc công việc không tương đương'**
  String get shiftSwapGradeMismatch;

  /// No description provided for @shiftSwapOnLeaveConflict.
  ///
  /// In vi, this message translates to:
  /// **'Đồng nghiệp đang nghỉ phép vào ngày này'**
  String get shiftSwapOnLeaveConflict;

  /// No description provided for @shiftSwapSameShiftConflict.
  ///
  /// In vi, this message translates to:
  /// **'Hai người đang cùng một ca làm việc'**
  String get shiftSwapSameShiftConflict;

  /// No description provided for @shiftSwapRestConflict.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng cách giữa hai ca < 12 giờ (Điều 109 BLLĐ 2019)'**
  String get shiftSwapRestConflict;

  /// No description provided for @shiftSwapOvertimeExceed.
  ///
  /// In vi, this message translates to:
  /// **'Tổng giờ tuần sẽ vượt quá 48 giờ'**
  String get shiftSwapOvertimeExceed;

  /// No description provided for @shiftSwapConflictAlert.
  ///
  /// In vi, this message translates to:
  /// **'Không đủ điều kiện đổi ca'**
  String get shiftSwapConflictAlert;

  /// No description provided for @shiftSwapApprovedTag.
  ///
  /// In vi, this message translates to:
  /// **'Đã đổi ca'**
  String get shiftSwapApprovedTag;

  /// No description provided for @shiftMonthUnpublished.
  ///
  /// In vi, this message translates to:
  /// **'Lịch tháng sau sẽ được công bố vào ngày 25'**
  String get shiftMonthUnpublished;

  /// No description provided for @shiftNetworkRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại kết nối'**
  String get shiftNetworkRetry;

  /// No description provided for @registeredDeviceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị đã đăng ký'**
  String get registeredDeviceTitle;

  /// No description provided for @registeredDeviceSub.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ chấm công trên thiết bị định danh duy nhất của bạn'**
  String get registeredDeviceSub;

  /// No description provided for @deviceModelLabel.
  ///
  /// In vi, this message translates to:
  /// **'Dòng máy / Thiết bị'**
  String get deviceModelLabel;

  /// No description provided for @deviceIdLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã định danh (UUID)'**
  String get deviceIdLabel;

  /// No description provided for @deviceRegisteredDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày đăng ký'**
  String get deviceRegisteredDate;

  /// No description provided for @deviceCheckRegistered.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị chính chủ hợp lệ'**
  String get deviceCheckRegistered;

  /// No description provided for @deviceCheckNotRooted.
  ///
  /// In vi, this message translates to:
  /// **'Không phát hiện Root / Jailbreak'**
  String get deviceCheckNotRooted;

  /// No description provided for @deviceCheckNoMockGps.
  ///
  /// In vi, this message translates to:
  /// **'Không dùng định vị giả (Mock GPS)'**
  String get deviceCheckNoMockGps;

  /// No description provided for @deviceCheckIntegrity.
  ///
  /// In vi, this message translates to:
  /// **'Tính toàn vẹn ứng dụng chuẩn'**
  String get deviceCheckIntegrity;

  /// No description provided for @deviceBlockRootTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị đã bị can thiệp (Root)'**
  String get deviceBlockRootTitle;

  /// No description provided for @deviceBlockRootMsg.
  ///
  /// In vi, this message translates to:
  /// **'Vì lý do an toàn, tài khoản không thể chấm công trên thiết bị đã can thiệp hệ điều hành. Vui lòng liên hệ HR.'**
  String get deviceBlockRootMsg;

  /// No description provided for @deviceBlockMockGpsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Phát hiện vị trí giả lập (Mock GPS)'**
  String get deviceBlockMockGpsTitle;

  /// No description provided for @deviceBlockMockGpsMsg.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống phát hiện bạn đang bật ứng dụng giả lập toạ độ. Vui lòng tắt ứng dụng giả lập vị trí và bấm \'Kiểm tra lại\'.'**
  String get deviceBlockMockGpsMsg;

  /// No description provided for @deviceRecheckBtn.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra lại'**
  String get deviceRecheckBtn;

  /// No description provided for @deviceDemoTogglesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mô phỏng vi phạm (Demo Sandbox)'**
  String get deviceDemoTogglesTitle;

  /// No description provided for @deviceSimulateMockGps.
  ///
  /// In vi, this message translates to:
  /// **'Mô phỏng phát hiện Mock GPS'**
  String get deviceSimulateMockGps;

  /// No description provided for @deviceSimulateRoot.
  ///
  /// In vi, this message translates to:
  /// **'Mô phỏng thiết bị Root'**
  String get deviceSimulateRoot;

  /// No description provided for @punchResultOnTime.
  ///
  /// In vi, this message translates to:
  /// **'Đúng giờ'**
  String get punchResultOnTime;

  /// No description provided for @punchResultLate.
  ///
  /// In vi, this message translates to:
  /// **'Đi muộn'**
  String get punchResultLate;

  /// No description provided for @punchResultEarly.
  ///
  /// In vi, this message translates to:
  /// **'Về sớm'**
  String get punchResultEarly;

  /// No description provided for @punchLateReasonPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Lý do đi muộn / về sớm'**
  String get punchLateReasonPrompt;

  /// No description provided for @faceThumbnailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh chụp đối chiếu AI'**
  String get faceThumbnailLabel;

  /// No description provided for @approvalTypeFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get approvalTypeFilterAll;

  /// No description provided for @approvalTypeFilterLeave.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ phép'**
  String get approvalTypeFilterLeave;

  /// No description provided for @approvalTypeFilterOT.
  ///
  /// In vi, this message translates to:
  /// **'Tăng ca'**
  String get approvalTypeFilterOT;

  /// No description provided for @approvalTypeFilterCorrection.
  ///
  /// In vi, this message translates to:
  /// **'Sửa công'**
  String get approvalTypeFilterCorrection;

  /// No description provided for @approvalTypeFilterSwap.
  ///
  /// In vi, this message translates to:
  /// **'Đổi ca'**
  String get approvalTypeFilterSwap;

  /// No description provided for @approvalTypeFilterOffSite.
  ///
  /// In vi, this message translates to:
  /// **'Đi việc ngoài'**
  String get approvalTypeFilterOffSite;

  /// No description provided for @approvalAttendanceSnippet.
  ///
  /// In vi, this message translates to:
  /// **'Chấm công ngày liên quan'**
  String get approvalAttendanceSnippet;

  /// No description provided for @approvalSwapBothSchedules.
  ///
  /// In vi, this message translates to:
  /// **'Lịch làm việc hai nhân viên'**
  String get approvalSwapBothSchedules;

  /// No description provided for @approvalInternalNoteLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú nội bộ (chỉ quản lý thấy)'**
  String get approvalInternalNoteLabel;

  /// No description provided for @approvalMandatoryRejectReason.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập lý do từ chối (bắt buộc)'**
  String get approvalMandatoryRejectReason;

  /// No description provided for @legendLateEarly.
  ///
  /// In vi, this message translates to:
  /// **'Đi muộn / Về sớm'**
  String get legendLateEarly;

  /// No description provided for @dateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get dateLabel;

  /// No description provided for @fillRequiredField.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập thông tin này'**
  String get fillRequiredField;

  /// No description provided for @submitButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu'**
  String get submitButton;

  /// No description provided for @annualLeaveRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn {days} ngày'**
  String annualLeaveRemaining(String days);

  /// No description provided for @availableDays.
  ///
  /// In vi, this message translates to:
  /// **'{days} ngày khả dụng'**
  String availableDays(String days);

  /// No description provided for @attendanceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chấm công'**
  String get attendanceTitle;

  /// No description provided for @loadingState.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải dữ liệu...'**
  String get loadingState;

  /// No description provided for @errorStateTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải dữ liệu'**
  String get errorStateTitle;

  /// No description provided for @networkError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi kết nối mạng, vui lòng thử lại'**
  String get networkError;

  /// No description provided for @currentMonthSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch ca tháng này'**
  String get currentMonthSchedule;

  /// No description provided for @deviceGpsRecheckedValid.
  ///
  /// In vi, this message translates to:
  /// **'Đang kiểm tra lại toạ độ GPS... Hợp lệ!'**
  String get deviceGpsRecheckedValid;

  /// No description provided for @deviceContactHrSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu hỗ trợ kiểm tra thiết bị tới HR.'**
  String get deviceContactHrSent;

  /// No description provided for @deviceContactHrBtn.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ phòng Nhân sự (HR)'**
  String get deviceContactHrBtn;

  /// No description provided for @deviceTestBlockCta.
  ///
  /// In vi, this message translates to:
  /// **'Thử nghiệm Chặn Chấm công (Demo)'**
  String get deviceTestBlockCta;

  /// No description provided for @deviceCheckSafetyBtn.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra an toàn'**
  String get deviceCheckSafetyBtn;

  /// No description provided for @requestDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết yêu cầu'**
  String get requestDetailTitle;

  /// No description provided for @requestCodeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã yêu cầu'**
  String get requestCodeLabel;

  /// No description provided for @requesterLabel.
  ///
  /// In vi, this message translates to:
  /// **'Người gửi'**
  String get requesterLabel;

  /// No description provided for @cancelRequestBtn.
  ///
  /// In vi, this message translates to:
  /// **'Hủy yêu cầu'**
  String get cancelRequestBtn;

  /// No description provided for @cancelRequestConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn hủy yêu cầu này?'**
  String get cancelRequestConfirm;

  /// No description provided for @requestCancelledSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu đã được hủy thành công'**
  String get requestCancelledSuccess;

  /// No description provided for @internalNoteHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập ghi chú nội bộ (chỉ người duyệt thấy)...'**
  String get internalNoteHint;

  /// No description provided for @approveRequestConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận phê duyệt yêu cầu này?'**
  String get approveRequestConfirm;

  /// No description provided for @rejectRequestConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận từ chối yêu cầu?'**
  String get rejectRequestConfirm;

  /// No description provided for @approvalTimelineTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiến trình phê duyệt (4 cấp)'**
  String get approvalTimelineTitle;

  /// No description provided for @submittedFieldsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin chi tiết'**
  String get submittedFieldsTitle;

  /// No description provided for @attachedFilesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tệp đính kèm & Minh chứng'**
  String get attachedFilesTitle;

  /// No description provided for @shiftComparisonTitle.
  ///
  /// In vi, this message translates to:
  /// **'So sánh ca làm việc hai nhân viên'**
  String get shiftComparisonTitle;

  /// No description provided for @attendanceLogComparisonTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đối chiếu giờ quẹt thẻ thực tế'**
  String get attendanceLogComparisonTitle;

  /// No description provided for @disputeComparisonTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đối chiếu khoản mục khiếu nại'**
  String get disputeComparisonTitle;

  /// No description provided for @disputedAmountDiff.
  ///
  /// In vi, this message translates to:
  /// **'Mức chênh lệch'**
  String get disputedAmountDiff;

  /// No description provided for @leaveManageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý Nghỉ phép'**
  String get leaveManageTitle;

  /// No description provided for @annualLeaveHeroTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quỹ phép năm 2026'**
  String get annualLeaveHeroTitle;

  /// No description provided for @leaveStatusFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get leaveStatusFilterAll;

  /// No description provided for @leaveStatusFilterPending.
  ///
  /// In vi, this message translates to:
  /// **'Chờ duyệt'**
  String get leaveStatusFilterPending;

  /// No description provided for @leaveStatusFilterApproved.
  ///
  /// In vi, this message translates to:
  /// **'Đã duyệt'**
  String get leaveStatusFilterApproved;

  /// No description provided for @leaveStatusFilterRejected.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get leaveStatusFilterRejected;

  /// No description provided for @createLeaveBtn.
  ///
  /// In vi, this message translates to:
  /// **'Tạo đơn nghỉ phép'**
  String get createLeaveBtn;

  /// No description provided for @overtimeManageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý Tăng ca'**
  String get overtimeManageTitle;

  /// No description provided for @totalOvertimeHours.
  ///
  /// In vi, this message translates to:
  /// **'Tổng giờ tăng ca'**
  String get totalOvertimeHours;

  /// No description provided for @rateNormal150.
  ///
  /// In vi, this message translates to:
  /// **'Ngày thường 150%'**
  String get rateNormal150;

  /// No description provided for @rateWeekend200.
  ///
  /// In vi, this message translates to:
  /// **'Cuối tuần 200%'**
  String get rateWeekend200;

  /// No description provided for @rateHoliday300.
  ///
  /// In vi, this message translates to:
  /// **'Ngày lễ 300%'**
  String get rateHoliday300;

  /// No description provided for @createOvertimeBtn.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký tăng ca'**
  String get createOvertimeBtn;

  /// No description provided for @correctionManageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý Sửa công'**
  String get correctionManageTitle;

  /// No description provided for @correctionQuotaTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hạn mức sửa công tháng này'**
  String get correctionQuotaTitle;

  /// No description provided for @correctionQuotaUsage.
  ///
  /// In vi, this message translates to:
  /// **'Đã dùng {used}/{total} lần'**
  String correctionQuotaUsage(String used, String total);

  /// No description provided for @missingPunchesSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngày thiếu chấm công cần xử lý'**
  String get missingPunchesSectionTitle;

  /// No description provided for @fixPunchBtn.
  ///
  /// In vi, this message translates to:
  /// **'Sửa công ngay'**
  String get fixPunchBtn;

  /// No description provided for @noMissingPunches.
  ///
  /// In vi, this message translates to:
  /// **'Không có ngày nào bị thiếu chấm công'**
  String get noMissingPunches;

  /// No description provided for @shiftSwapsManageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý Đổi ca'**
  String get shiftSwapsManageTitle;

  /// No description provided for @swapsSentTab.
  ///
  /// In vi, this message translates to:
  /// **'Đơn gửi đi'**
  String get swapsSentTab;

  /// No description provided for @swapsReceivedTab.
  ///
  /// In vi, this message translates to:
  /// **'Đơn nhận được'**
  String get swapsReceivedTab;

  /// No description provided for @colleagueLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đồng nghiệp đổi ca'**
  String get colleagueLabel;

  /// No description provided for @swapStatusPending.
  ///
  /// In vi, this message translates to:
  /// **'Chờ duyệt'**
  String get swapStatusPending;

  /// No description provided for @swapStatusApproved.
  ///
  /// In vi, this message translates to:
  /// **'Đã đổi ca'**
  String get swapStatusApproved;

  /// No description provided for @swapStatusRejected.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get swapStatusRejected;

  /// No description provided for @requestSentTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gửi thành công'**
  String get requestSentTitle;

  /// No description provided for @requestSentSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu của bạn đã được gửi thành công!'**
  String get requestSentSuccess;

  /// No description provided for @requestAssignedTo.
  ///
  /// In vi, this message translates to:
  /// **'Người tiếp nhận: {name}'**
  String requestAssignedTo(String name);

  /// No description provided for @backToListBtn.
  ///
  /// In vi, this message translates to:
  /// **'Về danh sách'**
  String get backToListBtn;

  /// No description provided for @viewRequestDetailBtn.
  ///
  /// In vi, this message translates to:
  /// **'Xem chi tiết yêu cầu'**
  String get viewRequestDetailBtn;

  /// No description provided for @payslipLockTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực bảo mật'**
  String get payslipLockTitle;

  /// No description provided for @payslipLockSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã PIN 6 số hoặc xác thực sinh trắc học để xem phiếu lương'**
  String get payslipLockSubtitle;

  /// No description provided for @payslipLockWrongPin.
  ///
  /// In vi, this message translates to:
  /// **'Mã PIN không chính xác. Còn lại {remaining} lần thử'**
  String payslipLockWrongPin(String remaining);

  /// No description provided for @payslipLockLocked.
  ///
  /// In vi, this message translates to:
  /// **'Đã khóa tạm thời trong 30 giây do nhập sai nhiều lần'**
  String get payslipLockLocked;

  /// No description provided for @payslipLockBiometricPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực để mở khóa phiếu lương'**
  String get payslipLockBiometricPrompt;

  /// No description provided for @payslipLockForgotPin.
  ///
  /// In vi, this message translates to:
  /// **'Quên mã PIN?'**
  String get payslipLockForgotPin;

  /// No description provided for @useBiometricsBtn.
  ///
  /// In vi, this message translates to:
  /// **'Dùng sinh trắc học'**
  String get useBiometricsBtn;

  /// No description provided for @signPayslipBtn.
  ///
  /// In vi, this message translates to:
  /// **'Ký xác nhận phiếu lương'**
  String get signPayslipBtn;

  /// No description provided for @signPadTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ký xác nhận điện tử'**
  String get signPadTitle;

  /// No description provided for @signPadSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng ký tên của bạn vào khung bên dưới'**
  String get signPadSubtitle;

  /// No description provided for @signPadClear.
  ///
  /// In vi, this message translates to:
  /// **'Xóa chữ ký'**
  String get signPadClear;

  /// No description provided for @signPadConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận ký'**
  String get signPadConfirm;

  /// No description provided for @signPadDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'Tôi xác nhận đã kiểm tra kỹ các thông tin thu nhập, khấu trừ và công chuẩn theo Bộ luật Lao động.'**
  String get signPadDisclaimer;

  /// No description provided for @signPadEmptyAlert.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng ký tên trước khi xác nhận'**
  String get signPadEmptyAlert;

  /// No description provided for @payslipSignedBadge.
  ///
  /// In vi, this message translates to:
  /// **'Đã ký điện tử'**
  String get payslipSignedBadge;

  /// No description provided for @payslipSignedAt.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian ký: {time}'**
  String payslipSignedAt(String time);

  /// No description provided for @payslipSignedHash.
  ///
  /// In vi, this message translates to:
  /// **'Mã băm xác thực: {hash}'**
  String payslipSignedHash(String hash);

  /// No description provided for @payslipSignedSigner.
  ///
  /// In vi, this message translates to:
  /// **'Người ký: {name}'**
  String payslipSignedSigner(String name);

  /// No description provided for @disputePayslipBtn.
  ///
  /// In vi, this message translates to:
  /// **'Khiếu nại bảng lương'**
  String get disputePayslipBtn;

  /// No description provided for @disputeLineBtn.
  ///
  /// In vi, this message translates to:
  /// **'Khiếu nại dòng này'**
  String get disputeLineBtn;

  /// No description provided for @disputeManageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý Khiếu nại lương'**
  String get disputeManageTitle;

  /// No description provided for @disputeNewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo khiếu nại lương'**
  String get disputeNewTitle;

  /// No description provided for @disputeMonthLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tháng khiếu nại'**
  String get disputeMonthLabel;

  /// No description provided for @disputeItemLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khoản mục sai lệch'**
  String get disputeItemLabel;

  /// No description provided for @disputeCurrentAmountLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền trên phiếu lương (₫)'**
  String get disputeCurrentAmountLabel;

  /// No description provided for @disputeExpectedAmountLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền đề xuất đúng (₫)'**
  String get disputeExpectedAmountLabel;

  /// No description provided for @disputeDifferenceLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chênh lệch đề xuất'**
  String get disputeDifferenceLabel;

  /// No description provided for @disputeReasonLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lý do & giải trình chi tiết'**
  String get disputeReasonLabel;

  /// No description provided for @disputeReasonHint.
  ///
  /// In vi, this message translates to:
  /// **'Nêu rõ nguyên nhân chênh lệch, ngày phát sinh, ca làm việc...'**
  String get disputeReasonHint;

  /// No description provided for @disputeAttachmentLabel.
  ///
  /// In vi, this message translates to:
  /// **'Minh chứng (bảng công, ảnh chụp phân ca...)'**
  String get disputeAttachmentLabel;

  /// No description provided for @submitDisputeBtn.
  ///
  /// In vi, this message translates to:
  /// **'Gửi khiếu nại'**
  String get submitDisputeBtn;

  /// No description provided for @disputeCreatedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi khiếu nại lương thành công'**
  String get disputeCreatedSuccess;

  /// No description provided for @noDisputesFound.
  ///
  /// In vi, this message translates to:
  /// **'Không có khiếu nại nào'**
  String get noDisputesFound;

  /// No description provided for @disputeStatusPending.
  ///
  /// In vi, this message translates to:
  /// **'Đang đối soát'**
  String get disputeStatusPending;

  /// No description provided for @disputeStatusApproved.
  ///
  /// In vi, this message translates to:
  /// **'Đã duyệt bù'**
  String get disputeStatusApproved;

  /// No description provided for @disputeStatusRejected.
  ///
  /// In vi, this message translates to:
  /// **'Không chấp thuận'**
  String get disputeStatusRejected;

  /// No description provided for @rewardsTabBonus.
  ///
  /// In vi, this message translates to:
  /// **'Thưởng'**
  String get rewardsTabBonus;

  /// No description provided for @rewardsTabCommission.
  ///
  /// In vi, this message translates to:
  /// **'Hoa hồng'**
  String get rewardsTabCommission;

  /// No description provided for @rewardsTabTargets.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ tiêu'**
  String get rewardsTabTargets;

  /// No description provided for @commissionTotalTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tổng hoa hồng tháng {month}'**
  String commissionTotalTitle(String month);

  /// No description provided for @commissionFilterDay.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get commissionFilterDay;

  /// No description provided for @commissionFilterWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần'**
  String get commissionFilterWeek;

  /// No description provided for @commissionFilterMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng'**
  String get commissionFilterMonth;

  /// No description provided for @commissionSourceDirect.
  ///
  /// In vi, this message translates to:
  /// **'Bán hàng trực tiếp'**
  String get commissionSourceDirect;

  /// No description provided for @commissionSourceTeam.
  ///
  /// In vi, this message translates to:
  /// **'Doanh số nhóm'**
  String get commissionSourceTeam;

  /// No description provided for @commissionSourceRenewal.
  ///
  /// In vi, this message translates to:
  /// **'Tái tục hợp đồng'**
  String get commissionSourceRenewal;

  /// No description provided for @commissionContractsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} giao dịch'**
  String commissionContractsCount(int count);

  /// No description provided for @targetPersonalTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ tiêu cá nhân tháng này'**
  String get targetPersonalTitle;

  /// No description provided for @targetTeamTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ tiêu đội nhóm chi nhánh'**
  String get targetTeamTitle;

  /// No description provided for @targetTiersTitle.
  ///
  /// In vi, this message translates to:
  /// **'Các mốc thưởng bậc thang'**
  String get targetTiersTitle;

  /// No description provided for @targetTierAchieved.
  ///
  /// In vi, this message translates to:
  /// **'Đã đạt mốc'**
  String get targetTierAchieved;

  /// No description provided for @targetTierRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn thiếu {remaining}'**
  String targetTierRemaining(String remaining);

  /// No description provided for @targetTierNext.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu kế tiếp'**
  String get targetTierNext;

  /// No description provided for @referCandidateBtn.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu ứng viên'**
  String get referCandidateBtn;

  /// No description provided for @referralFormTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu ứng viên'**
  String get referralFormTitle;

  /// No description provided for @candidateNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên ứng viên'**
  String get candidateNameLabel;

  /// No description provided for @candidatePhoneLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get candidatePhoneLabel;

  /// No description provided for @candidateEmailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email liên hệ'**
  String get candidateEmailLabel;

  /// No description provided for @candidatePositionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí ứng tuyển'**
  String get candidatePositionLabel;

  /// No description provided for @candidateBranchLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chi nhánh mong muốn'**
  String get candidateBranchLabel;

  /// No description provided for @candidateCvLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tải lên CV (PDF, DOCX)'**
  String get candidateCvLabel;

  /// No description provided for @candidateCvSelected.
  ///
  /// In vi, this message translates to:
  /// **'Đã đính kèm CV: {fileName}'**
  String candidateCvSelected(String fileName);

  /// No description provided for @candidateDuplicateError.
  ///
  /// In vi, this message translates to:
  /// **'Ứng viên này đã có hồ sơ trong hệ thống trong vòng 6 tháng qua'**
  String get candidateDuplicateError;

  /// No description provided for @submitReferralBtn.
  ///
  /// In vi, this message translates to:
  /// **'Gửi hồ sơ giới thiệu'**
  String get submitReferralBtn;

  /// No description provided for @referralSuccessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gửi giới thiệu thành công'**
  String get referralSuccessTitle;

  /// No description provided for @referralSuccessMsg.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ ứng viên đã được chuyển trực tiếp đến bộ phận Tuyển dụng'**
  String get referralSuccessMsg;

  /// No description provided for @referralCodeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã theo dõi giới thiệu'**
  String get referralCodeLabel;

  /// No description provided for @referralBonusNotice.
  ///
  /// In vi, this message translates to:
  /// **'Thưởng giới thiệu: 3.000.000 ₫ (khi ứng viên qua thử việc)'**
  String get referralBonusNotice;

  /// No description provided for @viewMyReferralsBtn.
  ///
  /// In vi, this message translates to:
  /// **'Xem ứng viên tôi đã giới thiệu'**
  String get viewMyReferralsBtn;

  /// No description provided for @myReferralsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ứng viên tôi đã giới thiệu'**
  String get myReferralsTitle;

  /// No description provided for @myReferralLinkTitle.
  ///
  /// In vi, this message translates to:
  /// **'Link & Mã QR giới thiệu của bạn'**
  String get myReferralLinkTitle;

  /// No description provided for @copyLinkBtn.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép link'**
  String get copyLinkBtn;

  /// No description provided for @shareQrBtn.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ QR'**
  String get shareQrBtn;

  /// No description provided for @linkCopiedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép link giới thiệu vào clipboard'**
  String get linkCopiedSnackbar;

  /// No description provided for @stageReceived.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp nhận hồ sơ'**
  String get stageReceived;

  /// No description provided for @stageInterview.
  ///
  /// In vi, this message translates to:
  /// **'Phỏng vấn'**
  String get stageInterview;

  /// No description provided for @stageProbation.
  ///
  /// In vi, this message translates to:
  /// **'Thử việc'**
  String get stageProbation;

  /// No description provided for @stageHired.
  ///
  /// In vi, this message translates to:
  /// **'Đã nhận việc & Thưởng'**
  String get stageHired;

  /// No description provided for @noReferralsFound.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có ứng viên nào được giới thiệu'**
  String get noReferralsFound;

  /// No description provided for @profileEditTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa hồ sơ'**
  String get profileEditTitle;

  /// No description provided for @profileEditHeader.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cá nhân & Tài khoản'**
  String get profileEditHeader;

  /// No description provided for @freeEditSection.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin liên hệ (Cập nhật ngay)'**
  String get freeEditSection;

  /// No description provided for @sensitiveEditSection.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin định danh & Ngân hàng (Cần HR duyệt)'**
  String get sensitiveEditSection;

  /// No description provided for @sensitiveEditNotice.
  ///
  /// In vi, this message translates to:
  /// **'Các thay đổi về CCCD/Hộ chiếu và Tài khoản ngân hàng cần được phòng Nhân sự phê duyệt trước khi áp dụng chính thức.'**
  String get sensitiveEditNotice;

  /// No description provided for @phoneEditLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get phoneEditLabel;

  /// No description provided for @emailEditLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email cá nhân'**
  String get emailEditLabel;

  /// No description provided for @addressEditLabel.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ hiện tại'**
  String get addressEditLabel;

  /// No description provided for @emergencyNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Người liên hệ khẩn cấp'**
  String get emergencyNameLabel;

  /// No description provided for @emergencyPhoneLabel.
  ///
  /// In vi, this message translates to:
  /// **'SĐT khẩn cấp'**
  String get emergencyPhoneLabel;

  /// No description provided for @bankNameEditLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngân hàng thụ hưởng'**
  String get bankNameEditLabel;

  /// No description provided for @bankAccountEditLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số tài khoản'**
  String get bankAccountEditLabel;

  /// No description provided for @bankHolderEditLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên chủ tài khoản'**
  String get bankHolderEditLabel;

  /// No description provided for @cccdEditLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số CCCD / Hộ chiếu'**
  String get cccdEditLabel;

  /// No description provided for @cccdIssueDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày cấp'**
  String get cccdIssueDateLabel;

  /// No description provided for @cccdIssuePlaceLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nơi cấp'**
  String get cccdIssuePlaceLabel;

  /// No description provided for @permanentAddressLabel.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ thường trú (theo CCCD)'**
  String get permanentAddressLabel;

  /// No description provided for @saveChangesBtn.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get saveChangesBtn;

  /// No description provided for @profileEditSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật thông tin thành công'**
  String get profileEditSuccess;

  /// No description provided for @profilePendingHrAlert.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu thay đổi thông tin định danh/ngân hàng đã được gửi đến HR (Mã: {code})'**
  String profilePendingHrAlert(String code);

  /// No description provided for @statusPendingHr.
  ///
  /// In vi, this message translates to:
  /// **'Chờ HR duyệt'**
  String get statusPendingHr;

  /// No description provided for @documentManagementTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tài liệu & Hồ sơ'**
  String get documentManagementTitle;

  /// No description provided for @expiringDocAlertTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo giấy tờ sắp hết hạn'**
  String get expiringDocAlertTitle;

  /// No description provided for @expiringDocAlertMsg.
  ///
  /// In vi, this message translates to:
  /// **'Giấy khám sức khỏe định kỳ sẽ hết hạn sau {days} ngày ({date}). Vui lòng cập nhật minh chứng mới.'**
  String expiringDocAlertMsg(int days, String date);

  /// No description provided for @legalDocSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ pháp lý & Bằng cấp'**
  String get legalDocSectionTitle;

  /// No description provided for @viewContractBtn.
  ///
  /// In vi, this message translates to:
  /// **'Xem hợp đồng'**
  String get viewContractBtn;

  /// No description provided for @contractViewerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hợp đồng lao động điện tử'**
  String get contractViewerTitle;

  /// No description provided for @contractWatermark.
  ///
  /// In vi, this message translates to:
  /// **'BẢN SAO ĐIỆN TỬ - {employeeCode} - {name} - {date}'**
  String contractWatermark(String employeeCode, String name, String date);

  /// No description provided for @uploadNewDocBtn.
  ///
  /// In vi, this message translates to:
  /// **'Tải lên tài liệu mới'**
  String get uploadNewDocBtn;

  /// No description provided for @downloadDocBtn.
  ///
  /// In vi, this message translates to:
  /// **'Tải về PDF'**
  String get downloadDocBtn;

  /// No description provided for @dependantsManageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Người phụ thuộc'**
  String get dependantsManageTitle;

  /// No description provided for @dependantsTaxReliefTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giảm trừ gia cảnh (TNCN)'**
  String get dependantsTaxReliefTitle;

  /// No description provided for @dependantsCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số người phụ thuộc: {count} người'**
  String dependantsCountLabel(int count);

  /// No description provided for @dependantsTotalReliefLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tổng mức giảm trừ: {amount} ₫/tháng'**
  String dependantsTotalReliefLabel(String amount);

  /// No description provided for @dependantPolicyNotice.
  ///
  /// In vi, this message translates to:
  /// **'Mức giảm trừ gia cảnh 4.400.000 ₫/người/tháng theo Nghị quyết của Ủy ban Thường vụ Quốc hội.'**
  String get dependantPolicyNotice;

  /// No description provided for @addDependantBtn.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký người phụ thuộc mới'**
  String get addDependantBtn;

  /// No description provided for @dependantNewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký người phụ thuộc'**
  String get dependantNewTitle;

  /// No description provided for @dependantFullNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên người phụ thuộc'**
  String get dependantFullNameLabel;

  /// No description provided for @dependantRelationshipLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mối quan hệ'**
  String get dependantRelationshipLabel;

  /// No description provided for @dependantDobLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày tháng năm sinh'**
  String get dependantDobLabel;

  /// No description provided for @dependantTaxIdLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã số thuế / CCCD / Giấy khai sinh'**
  String get dependantTaxIdLabel;

  /// No description provided for @dependantStartMonthLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tháng bắt đầu tính giảm trừ'**
  String get dependantStartMonthLabel;

  /// No description provided for @dependantProofUploadLabel.
  ///
  /// In vi, this message translates to:
  /// **'Minh chứng (Giấy khai sinh / CCCD)'**
  String get dependantProofUploadLabel;

  /// No description provided for @dependantDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'Tôi cam đoan các thông tin kê khai về người phụ thuộc trên là hoàn toàn chính xác và chịu trách nhiệm trước pháp luật.'**
  String get dependantDisclaimer;

  /// No description provided for @submitDependantBtn.
  ///
  /// In vi, this message translates to:
  /// **'Gửi hồ sơ đăng ký'**
  String get submitDependantBtn;

  /// No description provided for @dependantCreatedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi hồ sơ đăng ký người phụ thuộc đến phòng Nhân sự'**
  String get dependantCreatedSuccess;

  /// No description provided for @noDependantsFound.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có người phụ thuộc nào được đăng ký'**
  String get noDependantsFound;

  /// No description provided for @onboardingHomeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hành trình Hội nhập'**
  String get onboardingHomeTitle;

  /// No description provided for @onboardingWelcomeMsg.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng bạn gia nhập VSTECH!'**
  String get onboardingWelcomeMsg;

  /// No description provided for @onboardingCountdownDays.
  ///
  /// In vi, this message translates to:
  /// **'Còn {days} ngày nữa đến Ngày đầu tiên ({date})'**
  String onboardingCountdownDays(int days, String date);

  /// No description provided for @onboardingProgressSummary.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ chuẩn bị: {completed}/{total} bước'**
  String onboardingProgressSummary(int completed, int total);

  /// No description provided for @offerLetterTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thư mời nhận việc (Offer)'**
  String get offerLetterTitle;

  /// No description provided for @offerAcceptBtn.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận chấp thuận Offer'**
  String get offerAcceptBtn;

  /// No description provided for @offerAcceptedBadge.
  ///
  /// In vi, this message translates to:
  /// **'Đã chấp thuận Offer'**
  String get offerAcceptedBadge;

  /// No description provided for @offerSalaryProbation.
  ///
  /// In vi, this message translates to:
  /// **'Lương thử việc (85%): {amount} ₫'**
  String offerSalaryProbation(String amount);

  /// No description provided for @orgIntroTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đội ngũ & Người đồng hành'**
  String get orgIntroTitle;

  /// No description provided for @buddyCardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Người hướng dẫn (Buddy) của bạn'**
  String get buddyCardTitle;

  /// No description provided for @uploadDocsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nộp hồ sơ nhân sự'**
  String get uploadDocsTitle;

  /// No description provided for @uploadDocsProgress.
  ///
  /// In vi, this message translates to:
  /// **'Đã nộp {uploaded}/{total} tài liệu'**
  String uploadDocsProgress(int uploaded, int total);

  /// No description provided for @capturePhotoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh thẻ nhân viên'**
  String get capturePhotoTitle;

  /// No description provided for @capturePhotoGuide.
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh chân dung 3x4 nền sáng, nhìn thẳng vào camera'**
  String get capturePhotoGuide;

  /// No description provided for @capturePhotoBtn.
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh'**
  String get capturePhotoBtn;

  /// No description provided for @confirmPhotoBtn.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận dùng ảnh này'**
  String get confirmPhotoBtn;

  /// No description provided for @ocrVerificationTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực danh tính (OCR CCCD)'**
  String get ocrVerificationTitle;

  /// No description provided for @ocrScanBtn.
  ///
  /// In vi, this message translates to:
  /// **'Quét mặt trước CCCD'**
  String get ocrScanBtn;

  /// No description provided for @ocrVerifiedBadge.
  ///
  /// In vi, this message translates to:
  /// **'Đã xác thực trùng khớp 100%'**
  String get ocrVerifiedBadge;

  /// No description provided for @probationContractTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hợp đồng thử việc điện tử'**
  String get probationContractTitle;

  /// No description provided for @signContractBtn.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận ký hợp đồng'**
  String get signContractBtn;

  /// No description provided for @contractSignedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn tất ký hợp đồng thử việc điện tử'**
  String get contractSignedSuccess;

  /// No description provided for @dayOneGuideTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cẩm nang Ngày đầu tiên'**
  String get dayOneGuideTitle;

  /// No description provided for @dayOneChecklistTitle.
  ///
  /// In vi, this message translates to:
  /// **'Những điều cần lưu ý cho Ngày 1'**
  String get dayOneChecklistTitle;

  /// No description provided for @startNextStepBtn.
  ///
  /// In vi, this message translates to:
  /// **'Thực hiện bước tiếp theo'**
  String get startNextStepBtn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
