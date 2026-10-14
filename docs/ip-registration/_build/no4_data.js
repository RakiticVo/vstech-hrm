// Content data for document No.4 – functional & architecture description.
//
// Feature rows: [key, name, role, description, screens, release?]
//   release omitted  → shipped in version 0.1 (screen reachable + wired to real logic)
//   release = NEXT   → UI already built in the source code, fully enabled in the next release
// Features hidden from the UI (no entry point) are not listed.
// Codes CN-xx are assigned automatically; sequence diagrams reference features by key.

const NEXT = "next";

const FEATURES = [
  { title: "Xác thực, phiên đăng nhập và bảo mật", intro:
    "Nhóm chức năng bảo đảm chỉ người lao động hợp lệ mới truy cập được dữ liệu nhân sự. Phiên làm việc được lưu trong vùng lưu trữ mã hoá của hệ điều hành (Keychain trên iOS, Keystore trên Android).",
    rows: [
      ["splash", "Màn hình khởi động và khôi phục phiên", "NV, QL", "Kiểm tra token đã lưu, xác thực lại với máy chủ (`/api/Account/check-auth`), tự điều hướng tới Trang chủ hoặc Đăng nhập.", "SplashScreen"],
      ["login", "Đăng nhập bằng mã nhân viên và mật khẩu", "NV, QL", "Gửi thông tin đăng nhập kèm thông tin thiết bị (mã thiết bị, model, hệ điều hành, phiên bản ứng dụng, cờ root); nhận JWT; xác định vai trò Nhân viên / Quản lý theo quyền của tài khoản.", "LoginScreen"],
      ["bioLogin", "Ghi nhớ đăng nhập và đăng nhập nhanh bằng sinh trắc học", "NV, QL", "Lưu thông tin đăng nhập trong vùng mã hoá; đăng nhập lại bằng Face ID / vân tay qua `local_auth`.", "LoginScreen, BiometricLoginButton"],
      ["forgot", "Hướng dẫn quên mật khẩu", "NV, QL", "Hướng dẫn các bước khôi phục mật khẩu và kênh liên hệ bộ phận Nhân sự.", "ForgotPasswordScreen"],
      ["guard", "Phân quyền điều hướng theo vai trò", "Hệ thống", "Bộ chặn điều hướng `authRedirectGuard`: chặn truy cập khi chưa đăng nhập, chỉ vai trò Quản lý được vào khu vực Phê duyệt.", "GoRouter, AppShell"],
      ["logout", "Đăng xuất an toàn", "NV, QL", "Hộp thoại xác nhận; xoá toàn bộ token, phiên và hạn token khỏi vùng lưu trữ mã hoá rồi quay về màn Đăng nhập.", "LogoutConfirmDialog, AuthCubit"],
      ["qr", "Đăng nhập Web bằng mã QR", "NV, QL", "Quét mã QR trên trình duyệt, xem chi tiết yêu cầu đăng nhập và xác nhận bằng sinh trắc học trên điện thoại.", "QrScannerScreen, QrConfirmationBottomSheet", NEXT],
    ] },
  { title: "Trang chủ và điều hướng", intro:
    "Trang chủ là bảng điều khiển tự phục vụ (Personal Dashboard), hiển thị khác nhau theo vai trò Nhân viên và Quản lý.",
    rows: [
      ["home", "Trang chủ cá nhân", "NV, QL", "Băng hoạ văn gạch bông, lời chào, phòng ban; thẻ giờ đã làm hôm nay (đếm theo giây) với vòng tiến độ ca, giờ vào/ra và nút CHECK IN / CHECK OUT; lối tắt Nghỉ phép, Tăng ca, Bảng lương, Tất cả; ô tổng hợp ngày công, phép còn lại, giờ tăng ca, muộn/sớm; khối thông báo mới.", "HomeScreen, HomeBalanceCard, HomeSummaryGrid"],
      ["salaryMask", "Ẩn / hiện số lương thực nhận", "NV, QL", "Số lương ở Trang chủ và tab Bảng lương mặc định che (\"•••••••• ₫\"); bấm biểu tượng mắt để hiện / ẩn.", "HomeSalaryCard, PayrollScreen"],
      ["strip", "Dải chờ duyệt cho Quản lý", "QL", "Hiển thị số đơn cấp dưới đang chờ duyệt, chạm để mở hộp thư phê duyệt.", "HomeManagerApprovalStrip"],
      ["services", "Tất cả dịch vụ", "NV, QL", "Lưới dịch vụ 4 nhóm: Chấm công & Thời gian (chấm công, Lịch & Ca làm việc); Đơn từ (nghỉ phép, tăng ca, giải trình công với Quản lý); Lương & thưởng (bảng lương, khiếu nại lương); Cá nhân (hồ sơ, cài đặt).", "AllServicesScreen"],
      ["shell", "Thanh điều hướng 5 tab theo vai trò", "NV, QL", "Nhân viên: Trang chủ · Chấm công · Yêu cầu · Bảng lương · Cá nhân. Quản lý: tab thứ 3 là Phê duyệt (thay cho Yêu cầu).", "AppShell"],
    ] },
  { title: "Chấm công", intro:
    "Phân hệ cốt lõi, kết hợp 3 lớp xác thực: nhận diện khuôn mặt AI, vị trí GPS và thông tin mạng Wi-Fi / thiết bị.",
    rows: [
      ["faceScan", "Chấm công vào / ra bằng nhận diện khuôn mặt AI", "NV, QL", "Kiểm tra đăng ký khuôn mặt, lấy toạ độ GPS, mở camera trước với khung căn mặt; xác thực khuôn mặt qua Face API rồi mới ghi nhận lượt chấm công lên máy chủ; rung nhẹ và hiển thị biên lai.", "FaceScanScreen, AttendanceBloc"],
      ["enroll", "Đăng ký / cập nhật khuôn mặt", "NV, QL", "Từ Hồ sơ → \"Xác thực khuôn mặt\" hoặc khi chưa đăng ký: chụp ảnh mẫu để đăng ký lần đầu hoặc cập nhật dữ liệu sinh trắc trên Face API.", "FaceEnrollmentScreen"],
      ["attTab", "Tab Chấm công và nhật ký ngày", "NV, QL", "Giờ đã làm hôm nay, trạng thái và đồng hồ hệ thống, nút CHECK IN / CHECK OUT, vị trí đã xác thực; ô giờ vào, giờ ra, đi muộn, tăng ca; tổng hợp tháng (đủ công, nghỉ phép, thiếu giờ, ngày lễ); nhật ký từng ngày.", "AttendanceScreen, AttendancePunchCard, AttendanceDailyLogCard"],
      ["shift", "Lịch & Ca làm việc – Lịch ca", "NV, QL", "Tuần 7 ngày dạng viên nang, tổng số ca / giờ công / ngày nghỉ trong tuần; chi tiết ca (giờ làm, nghỉ giữa ca, địa điểm, quản lý ca); nút \"Báo tăng ca\" mở form đăng ký tăng ca; lưới ca 30 ngày.", "ShiftScheduleScreen, ShiftScheduleTabView, ShiftDetailCard"],
      ["calendar", "Lịch & Ca làm việc – Lịch công 5 mã màu", "NV, QL", "Lịch tháng tô màu xanh – đủ công, vàng – muộn/sớm, đỏ – thiếu giờ, tím – nghỉ phép, xám – ngày lễ; tổng hợp ngày công tính lương, tổng giờ làm, tăng ca luỹ kế, nghỉ phép có lương, số lần muộn / sớm.", "ShiftScheduleScreen (tab Lịch công), CalendarTimesheetView"],
      ["holidays", "Ngày lễ và nghỉ bù", "NV, QL", "Mở từ nhật ký chấm công; danh mục ngày lễ đang áp dụng theo luật lao động.", "HolidaysScreen"],
      ["swap", "Đổi ca", "NV", "Đề xuất đổi ca với đồng nghiệp, kiểm tra hợp lệ, theo dõi trạng thái đề xuất.", "ShiftSwapsScreen, ShiftSwapModal", NEXT],
    ] },
  { title: "Đơn từ và Trung tâm yêu cầu", intro:
    "Số hoá đơn từ, gom về một nơi và theo dõi tiến độ phê duyệt.",
    rows: [
      ["requests", "Trung tâm yêu cầu hợp nhất", "NV", "Tab Yêu cầu: danh mục Nghỉ phép, Tăng ca; nút tạo đơn mới; danh sách đơn của tháng đã chọn, lọc Chờ duyệt / Đã duyệt / Từ chối.", "RequestsScreen, RequestsCategoryTiles, NewRequestBottomSheet"],
      ["month", "Chọn tháng xem dữ liệu", "NV, QL", "Bộ chọn tháng dùng chung cho Trung tâm yêu cầu, Nghỉ phép, Tăng ca; tự chuyển thành khoảng ngày đầu – cuối tháng khi truy vấn máy chủ.", "MonthPickerButton, AppMonthPickerDialog"],
      ["leave", "Đơn xin nghỉ phép", "NV, QL", "Danh sách đơn theo tháng; tạo đơn: cả ngày / nửa ca sáng / nửa ca chiều, loại phép lấy từ máy chủ, từ ngày – đến ngày, lý do; tự tính số ngày nghỉ.", "LeaveManageScreen, LeaveRequestModal"],
      ["ot", "Đăng ký tăng ca", "NV, QL", "Tổng giờ tăng ca trong tháng so với giới hạn 40 giờ; danh sách theo tháng; tạo đơn: ngày, giờ bắt đầu – kết thúc, loại tăng ca (hệ số ×1,5 / ×2,0 / ×3,0), lý do; tự tính thời lượng, chặn gửi trùng, hiển thị lỗi máy chủ ngay trên form.", "OvertimeManageScreen, OvertimeRequestModal, OvertimeRequestScreen"],
      ["correction", "Giải trình / điều chỉnh công", "QL", "Danh sách phiếu giải trình; tạo phiếu 3 bước (ngày → vấn đề và giờ thực tế → giải trình); bắt buộc ghi chú / ảnh theo từng lý do; đính kèm vị trí.", "CorrectionManageScreen, AttendanceCorrectionScreen"],
      ["detail", "Chi tiết đơn và tiến trình phê duyệt", "NV, QL", "Loại đơn, mã đơn, trạng thái, thông tin chi tiết và tiến trình phê duyệt 4 cấp: Nhân viên → Quản lý trực tiếp → Nhân sự → Ban Giám đốc.", "RequestDetailScreen, RequestDetailTimeline"],
      ["cancel", "Thu hồi đơn đang chờ duyệt", "NV", "Hộp thoại xác nhận thu hồi đơn chưa được duyệt; gửi yêu cầu huỷ lên máy chủ.", "CancelRequestDialog, CancelLeave / CancelOvertime UseCase", NEXT],
    ] },
  { title: "Phê duyệt dành cho Quản lý", intro:
    "Hộp thư phê duyệt giúp quản lý trực tiếp xử lý đơn ngay trên điện thoại.",
    rows: [
      ["inbox", "Hộp thư phê duyệt hợp nhất", "QL", "Tải đồng thời 3 nguồn (phiếu giải trình công, đơn nghỉ phép, đơn tăng ca), lọc đơn đang chờ, chuẩn hoá thành thẻ đơn; lọc Tất cả / Giải trình / Tăng ca / Nghỉ phép.", "ApprovalsScreen, ApprovalsActionHandler, ApprovalCard"],
      ["confirmHours", "Xác nhận giờ công", "QL", "Nhập số giờ công xác nhận và ghi chú khi duyệt phiếu giải trình.", "ConfirmTimesheetDialog"],
      ["approve", "Duyệt / từ chối 1 chạm", "QL", "Duyệt nhanh; từ chối bắt buộc nhập lý do; tự gọi đúng nghiệp vụ theo loại đơn và hiển thị thông báo của máy chủ.", "ApprovalsActionHandler"],
    ] },
  { title: "Lương, thưởng và thu nhập", intro:
    "Dữ liệu tài chính được bảo vệ bằng lớp xác thực sinh trắc học độc lập.",
    rows: [
      ["payroll", "Tổng quan thu nhập", "NV, QL", "Thẻ lương thực nhận (NET) của kỳ lương, chi tiết thu nhập và khấu trừ, lịch sử kỳ lương.", "PayrollScreen, PayrollHeroCard"],
      ["lock", "Khoá bảo vệ phiếu lương", "NV, QL", "Xác thực Face ID / vân tay; dự phòng mã PIN 6 số, tối đa 5 lần thử, khoá tạm 30 giây.", "PayslipLockScreen, PinCodeKeypad"],
      ["payslip", "Phiếu lương điện tử chi tiết", "NV, QL", "Thu nhập (lương cơ bản, phụ cấp ăn trưa & đi lại, tăng ca, thưởng KPI), khấu trừ (BHXH/BHYT/BHTN, thuế TNCN, phí đoàn thể) và lương thực nhận.", "PayslipDetailScreen"],
      ["sign", "Ký xác nhận phiếu lương", "NV", "Ký tay trên màn hình, lưu thời điểm ký và mã băm xác thực.", "SignaturePadModal, PayslipSignedCard", NEXT],
      ["dispute", "Khiếu nại sai lệch lương", "NV", "Tạo khiếu nại từ một dòng lương (kỳ lương, khoản mục, số tiền, số đúng, mô tả, minh chứng) và theo dõi trạng thái xử lý.", "SalaryDisputeNewScreen, SalaryDisputeScreen, RequestSentScreen", NEXT],
      ["rewards", "Thưởng, hoa hồng và chỉ tiêu", "NV", "3 tab: thưởng và lý do được thưởng; hoa hồng theo 3 nguồn, tổng hợp ngày / tuần / tháng; tiến độ chỉ tiêu KPI và mức thưởng theo mốc 80 / 100 / 120%.", "RewardsScreen", NEXT],
    ] },
  { title: "Thông báo", intro: "Kênh thông tin chính thống của doanh nghiệp tới người lao động.",
    rows: [
      ["notif", "Trung tâm thông báo", "NV, QL", "Mở từ biểu tượng chuông hoặc khối thông báo ở Trang chủ; lọc theo nhóm (Phép, Lương, Chấm công, Thưởng, Tuyển dụng); đánh dấu đã đọc / đọc tất cả; điều hướng tới màn hình liên quan.", "NotificationsScreen, HomeAnnouncements"],
      ["fcm", "Nhận thông báo đẩy (FCM)", "NV, QL", "Đăng ký mã thiết bị với máy chủ để nhận thông báo kết quả duyệt, nhắc chấm công, phát hành phiếu lương.", "RegisterFcmTokenUseCase", NEXT],
    ] },
  { title: "Hồ sơ nhân viên", intro: "Hồ sơ 360° của người lao động.",
    rows: [
      ["profile", "Hồ sơ cá nhân", "NV, QL", "Thông tin cá nhân (họ tên, ngày sinh, điện thoại, email, địa chỉ), thông tin công việc (bộ phận, chức danh, quản lý, ngày vào, trạng thái), tài khoản ngân hàng – tải từ máy chủ.", "ProfileScreen, ProfileHeaderCard"],
      ["profileEdit", "Chỉnh sửa hồ sơ có duyệt", "NV", "Sửa thông tin cá nhân theo chính sách duyệt 2 cấp; thông tin công việc chỉ được xem.", "ProfileEditScreen", NEXT],
      ["docs", "Quản lý tài liệu cá nhân", "NV", "Hợp đồng, giấy tờ pháp lý, cảnh báo giấy tờ sắp hết hạn.", "DocumentManagementScreen", NEXT],
      ["dependants", "Người phụ thuộc giảm trừ thuế", "NV", "Danh sách và đăng ký mới người phụ thuộc để giảm trừ thuế TNCN.", "DependantsScreen, DependantNewScreen", NEXT],
      ["labor", "Hồ sơ lao động – hợp đồng – BHXH", "NV", "Điều khoản hợp đồng, số hợp đồng, mức lương thoả thuận, phúc lợi, đóng bảo hiểm xã hội, tệp hợp đồng đính kèm.", "LaborProfileScreen", NEXT],
      ["jobs", "Tuyển dụng nội bộ", "NV", "Danh sách vị trí đang tuyển, chi tiết vị trí và ứng tuyển nhanh.", "InternalRecruitmentScreen, JobDetailScreen", NEXT],
      ["refer", "Giới thiệu ứng viên", "NV", "Nhập hồ sơ ứng viên được giới thiệu; theo dõi tiến độ 4 bước Tiếp nhận → Phỏng vấn → Thử việc → Ký hợp đồng.", "ReferralFormScreen, ReferralSuccessScreen, MyReferralsScreen", NEXT],
    ] },
  { title: "Cài đặt và hệ thống", intro: "Tuỳ biến ứng dụng và các thành phần dùng chung.",
    rows: [
      ["push", "Bật / tắt thông báo đẩy", "NV, QL", "Xin quyền thông báo của hệ điều hành khi bật.", "SettingsScreen"],
      ["theme", "Giao diện sáng / tối", "NV, QL", "Chọn theo hệ thống, sáng hoặc tối; áp dụng ngay toàn ứng dụng (từ Cài đặt hoặc Hồ sơ).", "ThemeSelectionSheet, ThemeCubit"],
      ["lang", "Ngôn ngữ Việt / Anh", "NV, QL", "Chuyển ngôn ngữ giao diện tức thời; toàn bộ chuỗi tách ra tệp ARB tiếng Việt và tiếng Anh.", "LanguageSelectionSheet, LocaleCubit, lib/l10n"],
      ["bioUnlock", "Mở khoá bằng sinh trắc học", "NV, QL", "Hiển thị khi thiết bị hỗ trợ; xác thực Face ID / vân tay trước khi bật và lưu cấu hình trong vùng mã hoá.", "SettingsScreen"],
      ["perms", "Quản lý quyền thiết bị", "NV, QL", "Mở trang cài đặt của hệ điều hành để cấp quyền máy ảnh, vị trí, tệp & ảnh, thông báo.", "SettingsScreen"],
      ["states", "Trạng thái giao diện dùng chung", "Hệ thống", "Trạng thái rỗng, đang tải (khung xương đúng bố cục), lỗi có đường thoát, thành công; có màn minh hoạ trong Cài đặt.", "StateShowcaseScreen, core widgets"],
      ["emailReport", "Email báo cáo và nhắc nhở chấm công", "NV, QL", "Gửi bản tóm tắt công & lương qua email; nhắc trước giờ vào ca 15 phút.", "SettingsScreen", NEXT],
      ["cache", "Xoá bộ nhớ đệm", "NV, QL", "Hiển thị dung lượng bộ nhớ đệm và giải phóng dữ liệu tạm.", "SettingsScreen", NEXT],
    ] },
];

// Assign CN-xx codes in order.
const CODE = {};
let n = 0;
FEATURES.forEach((g) => g.rows.forEach((r) => { n += 1; CODE[r[0]] = `CN-${String(n).padStart(2, "0")}`; }));
const cn = (...keys) => keys.map((k) => { if (!CODE[k]) throw new Error(`unknown feature ${k}`); return CODE[k]; }).join(", ");

// ---- Sequence diagram catalogue (section 7) – only version 0.1 features ----
const SEQ = [
  { code: "SD01", features: cn("splash", "login", "bioLogin", "guard"),
    actors: "Nhân viên, Quản lý; AuthCubit; HRM Backend API.", pre: "Ứng dụng đã cài đặt; thiết bị có kết nối Internet.",
    exc: "Sai thông tin đăng nhập (401), tài khoản bị khoá (400), lỗi máy chủ (500): hiển thị thông báo, giữ ở màn Đăng nhập.",
    flow: ["Khởi động: đọc token và phiên đã lưu, xác minh qua `GET /api/Account/check-auth`; hợp lệ thì vào Trang chủ, hết hạn thì xoá phiên.",
      "Đăng nhập: gửi `POST /api/Account` kèm thông tin thiết bị; lưu JWT, phiên, hạn token vào vùng mã hoá; xác định vai trò từ quyền `manager.approve`.",
      "Đăng nhập nhanh: xác thực Face ID / vân tay rồi đăng nhập bằng tài khoản đã ghi nhớ."] },
  { code: "SD02", features: cn("faceScan", "home", "attTab"),
    actors: "Nhân viên; FaceScanScreen; AttendanceBloc; GPS; Camera; Face Authentication API; HRM Backend API.",
    pre: "Đã đăng nhập; đã cấp quyền camera và vị trí; khuôn mặt đã đăng ký.",
    exc: "Chưa đăng ký khuôn mặt → SD03; khuôn mặt không khớp → chụp lại; vi phạm quy tắc chấm công (400) → thông báo kèm hướng liên hệ HR.",
    flow: ["Chuẩn bị: lấy toạ độ GPS (≤ 4 giây), kiểm tra đăng ký khuôn mặt (`GET /checkreg/`), mở camera trước với khung căn mặt.",
      "Xác thực: chụp ảnh và gửi `POST /verify/` tới Face API; chỉ khi khớp mới chuyển sang ghi nhận.",
      "Ghi nhận: gửi `POST /api/Enrollments/Checkin|Checkout` kèm toạ độ, mạng, dấu vân tay thiết bị; tải lại công hôm nay và hiển thị biên lai."] },
  { code: "SD03", features: cn("enroll"),
    actors: "Nhân viên; FaceEnrollmentScreen; Face Authentication API.", pre: "Đã đăng nhập; đã cấp quyền camera.",
    exc: "Ảnh không hợp lệ (422) hoặc lỗi máy chủ: thông báo và cho phép chụp lại.",
    flow: ["Kiểm tra trạng thái đăng ký (`GET /checkreg/`) và hướng dẫn chụp.",
      "Lần đầu gửi `POST /register/`, đã có dữ liệu gửi `POST /update/`; thành công thì quay lại sẵn sàng chấm công."] },
  { code: "SD04", features: cn("attTab", "shift", "calendar", "holidays"),
    actors: "Nhân viên; AttendanceScreen; ShiftScheduleScreen; HolidaysScreen; HRM Backend API.", pre: "Đã đăng nhập.",
    exc: "Lỗi tải dữ liệu: hiển thị trạng thái lỗi kèm thử lại.",
    flow: ["Tab Chấm công tải công hôm nay, nhật ký theo khoảng ngày (`GET /api/Enrollments/info`) và giờ tăng ca trong tháng; đổi giờ UTC sang UTC+7.",
      "Lịch & Ca làm việc: tab Lịch ca (ca trong tuần, chi tiết ca) và tab Lịch công (lịch tháng 5 mã màu, tổng hợp tháng).",
      "Ngày lễ: tải danh mục qua `GET /api/Holidays`."] },
  { code: "SD05", features: cn("leave", "month"),
    actors: "Nhân viên; LeaveManageScreen; LeaveRequestModal; HRM Backend API.", pre: "Đã đăng nhập; còn quỹ phép.",
    exc: "Vượt quỹ phép / trùng lịch (400): hiển thị thông báo của máy chủ.",
    flow: ["Tải loại phép và danh sách đơn của tháng đã chọn (`GET /api/LeaveRequests/self?From&To`).",
      "Tạo đơn: chọn hình thức nghỉ, loại phép, khoảng ngày, lý do; gửi `POST /api/LeaveRequests/self` (from, to, validFrom, validTo, isMultiple…); mã nhân viên do máy chủ xác định theo JWT."] },
  { code: "SD06", features: cn("requests", "month", "detail"),
    actors: "Nhân viên; RequestsScreen; RequestDetailScreen; HRM Backend API.", pre: "Đăng nhập với vai trò Nhân viên.",
    exc: "Lỗi tải dữ liệu: hiển thị trạng thái lỗi.",
    flow: ["Chọn tháng; lần lượt tải đơn nghỉ phép và đơn tăng ca của tháng.",
      "Gộp, sắp xếp, lọc theo trạng thái; mở chi tiết đơn để xem tiến trình phê duyệt 4 cấp."] },
  { code: "SD07", features: cn("ot", "month"),
    actors: "Nhân viên; OvertimeManageScreen; OvertimeRequestModal; HRM Backend API.", pre: "Đã đăng nhập.",
    exc: "Máy chủ từ chối (vượt giới hạn giờ / dữ liệu không hợp lệ): giữ form, hiển thị nguyên văn thông báo lỗi.",
    flow: ["Tải loại tăng ca (`GET /api/OvertimeTypes/fetch?IsActive=1`, dự phòng `GET /api/OvertimeRequests/self?init=1`) và lịch sử tăng ca của tháng.",
      "Tạo đơn: chọn ngày, khung giờ, loại tăng ca, lý do; form tự tính thời lượng; gửi `POST /api/OvertimeRequests`, chặn gửi trùng."] },
  { code: "SD08", features: cn("correction"),
    actors: "Quản lý; CorrectionManageScreen; AttendanceCorrectionScreen; HRM Backend API.", pre: "Đăng nhập với vai trò Quản lý.",
    exc: "Thiếu ghi chú / ảnh bắt buộc: chặn gửi ngay trên form; lỗi máy chủ: thông báo.",
    flow: ["Tải danh sách phiếu và danh mục lý do (`GET /api/TimesheetConfirmRequests/reasons`).",
      "Lập phiếu 3 bước, đính kèm ảnh và vị trí theo yêu cầu của lý do; gửi `POST /api/TimesheetConfirmRequests`."] },
  { code: "SD09", features: cn("strip", "inbox", "confirmHours", "approve"),
    actors: "Quản lý; ApprovalsScreen; ApprovalsActionHandler; HRM Backend API.", pre: "Đăng nhập với vai trò Quản lý.",
    exc: "Lỗi máy chủ: giữ thẻ đơn và thông báo.",
    flow: ["Tải đồng thời 3 nguồn đơn, lọc đơn đang chờ, chuẩn hoá thành thẻ đơn.",
      "Duyệt: phiếu giải trình nhập giờ công xác nhận (`/confirm/{id}`); nghỉ phép (`/leave/accept/{id}`); tăng ca (`/overtime/accept/{id}`).",
      "Từ chối (bắt buộc lý do): `/reject/{id}`, `/leave/deny/{id}`, `/overtime/Deny/{id}`."] },
  { code: "SD10", features: cn("payroll", "salaryMask", "lock", "payslip"),
    actors: "Nhân viên; PayrollScreen; PayslipLockScreen; PayslipDetailScreen; local_auth; HRM Backend API.",
    pre: "Đã đăng nhập; thiết bị hỗ trợ sinh trắc học hoặc dùng mã PIN.",
    exc: "Xác thực thất bại: không mở phiếu lương; sai PIN 5 lần: khoá 30 giây.",
    flow: ["Tab Bảng lương tải bảng lương của kỳ (`GET /api/EmployeeSalaryPayrolls/detail/{id}`), số liệu có thể ẩn / hiện.",
      "Mở phiếu lương phải qua cổng Face ID / vân tay hoặc mã PIN 6 số.",
      "Phiếu lương chi tiết hiển thị thu nhập, khấu trừ và lương thực nhận."] },
  { code: "SD11", features: cn("notif"),
    actors: "Nhân viên, Quản lý; HomeScreen; NotificationsScreen; HRM Backend API.", pre: "Đã đăng nhập.",
    exc: "Thông báo không tồn tại (404): bỏ qua, làm mới danh sách.",
    flow: ["Trang chủ hiển thị thông báo mới nhất (`GET /api/BaseNotifications`); bấm chuông mở trung tâm thông báo, lọc theo nhóm.",
      "Chạm thông báo → đánh dấu đã đọc (`/{id}/read`); hỗ trợ đọc tất cả (`/read-all`)."] },
  { code: "SD12", features: cn("profile", "theme", "lang", "logout"),
    actors: "Người dùng; ProfileScreen; SettingsScreen; AuthCubit; HRM Backend API.", pre: "Đã đăng nhập.",
    exc: "Phiên hết hạn (401): tự đăng xuất.",
    flow: ["Tải hồ sơ đầy đủ (`GET /api/Account`) và hiển thị theo nhóm thông tin.",
      "Cài đặt: giao diện, ngôn ngữ áp dụng tức thời; đăng xuất xoá toàn bộ phiên trong vùng mã hoá."] },
];

// ---- Screenshots manifest (section 9) – files in ../screenshots -----------
const SCREENS = [
  ["01_login", "Đăng nhập"],
  ["02_home_employee", "Trang chủ"],
  ["04_services", "Tất cả dịch vụ (4 nhóm)"],
  ["05_attendance", "Tab Chấm công"],
  ["06_face_scan", "Chấm công bằng nhận diện khuôn mặt"],
  ["24_shift_schedule", "Lịch & Ca làm việc – tab Lịch ca"],
  ["08_calendar", "Lịch & Ca làm việc – tab Lịch công"],
  ["11_requests", "Trung tâm yêu cầu"],
  ["12_leave_manage", "Quản lý nghỉ phép"],
  ["13_leave_create", "Tạo đơn xin nghỉ phép"],
  ["16_request_detail", "Chi tiết đơn – tiến trình phê duyệt 4 cấp"],
  ["14_overtime_manage", "Quản lý tăng ca"],
  ["15_overtime_create", "Đăng ký tăng ca – tự tính thời lượng"],
  ["18_payroll", "Bảng lương và thu nhập"],
  ["19_payslip_lock", "Khoá bảo vệ phiếu lương"],
  ["20_payslip_detail", "Phiếu lương chi tiết"],
  ["21_notifications", "Trung tâm thông báo"],
  ["22_profile", "Hồ sơ cá nhân"],
  ["23_settings", "Cài đặt"],
];

module.exports = { FEATURES, SEQ, SCREENS, CODE, NEXT };
