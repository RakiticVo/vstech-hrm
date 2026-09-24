# Changelog

Định dạng theo [Keep a Changelog](https://keepachangelog.com/vi/1.1.0/), dự án tuân theo [Semantic Versioning](https://semver.org/lang/vi/). Chi tiết quy ước ở [docs/git-workflow.md](docs/git-workflow.md#4-changelogmd).

## [Unreleased]

### Added
- Xây dựng Phân hệ Bảng điều khiển Điều hành cấp cao & Phê duyệt cuối C-Level (`lib/features/executive/`):
  - Màn 21 — Executive Dashboard (`ExecutiveDashboardScreen`): Dashboard trực quan dành cho CEO/Ban Điều Hành hiển thị Headcount 3.142 lao động, tỷ lệ đi làm 98,2%, quỹ lương 42,8 tỷ VNĐ (+3,4%), tổng giờ OT 14.280h (TB 18,2h/người); Hero card hồ sơ chờ ký duyệt cao nhất; Khối cảnh báo rủi ro & tuân thủ cần chú ý; Tỷ lệ đi làm trực quan theo từng khối/xưởng sản xuất.
  - Màn 22 — Final Approval C-Level (`FinalApprovalScreen`): Màn hình phê duyệt cấp cao nhất trước khi HR/Kế toán giải ngân; Chuỗi quy trình ký duyệt 4 cấp trực quan (`FinalApprovalChainTimeline`); Thống kê tác động tài chính & kiểm tra ngân sách dự phòng; Cơ chế phê duyệt nhanh toàn bộ ("Duyệt tất cả") và phê duyệt/từ chối từng hồ sơ kèm ghi chú HR.
- Xây dựng Phân hệ Cảnh báo Rủi ro Tuân thủ & Trung tâm Ủy quyền (`lib/features/compliance/`):
  - Màn 28 — Risk & Compliance Alerts (`RiskComplianceScreen`): Phân tầng 3 cấp độ cảnh báo (Nghiêm trọng, Cảnh báo cao, Theo dõi) với các chỉ số vi phạm luật lao động thực tế tại nhà máy (14 công nhân OT vượt 40h/tháng theo Điều 107 BLLĐ, 6 công nhân làm việc ca đêm 7 ngày liên tục chưa nghỉ bù, quá hạn phụ lục HĐLĐ); Hành động 1-chạm "Giao việc cho HR" tự động phân công bộ phận chuyên trách.
  - Màn 29 — Delegation Center (`DelegationCenterScreen`): Trung tâm chuyển giao quyền phê duyệt khi lãnh đạo công tác/vắng mặt; Chọn người nhận ủy quyền từ danh sách cán bộ chủ chốt; Thiết lập khoảng thời gian linh hoạt qua bộ chọn ngày `DelegationPeriodCard`; Bộ chuyển đổi phạm vi quyền hạn `DelegationScopeToggle` (Toàn bộ vs Từng loại đơn); Thiết lập trần hạn mức tài chính `DelegationLimitCard` (Vô hạn, ≤ 20Tr, ≤ 50Tr, ≤ 100Tr); Quản lý danh sách ủy quyền đang hiệu lực `ActiveDelegationCard` và thao tác thu hồi quyền lực tức thì.
- Hoàn thiện Kiến trúc Core & Tiện ích Design System:
  - Bổ sung cấu trúc `AppGap` chuẩn hóa các khoảng cách cố định trong `lib/core/responsive/app_layout.dart`.
  - Mở rộng semantic tokens trong `AppColorsExtension` (`primary`, `surfaceContainer`, `borderSubtle`) và `AppTextStyles` (`h3`, `bodyBold`).
  - Tích hợp 4 dịch vụ mới vào danh mục "Quản trị & Điều hành" tại `AllServicesScreen`.
  - Viết bộ kiểm thử đơn vị `test/features/executive/` và `test/features/compliance/` (100% passed, 50/50 tests passing).
- Xây dựng Phân hệ Thông báo nội bộ (`lib/features/announcements/`):
  - Tra cứu thông báo ban hành từ HR/Admin theo 4 cấp phạm vi (Toàn công ty, Khối nhà xưởng, Khối văn phòng, Phòng ban).
  - Hỗ trợ thanh tìm kiếm nhanh, bộ lọc phân loại theo phạm vi, thẻ thông báo hiển thị huy hiệu chưa đọc, và màn hình chi tiết tự động cập nhật trạng thái đã xem.
  - Tích hợp điều hướng trực tiếp từ mục "Xem tất cả" tại trang chủ Dashboard.
- Xây dựng Phân hệ Hồ sơ lao động & HĐLĐ (`lib/features/labor_profile/`):
  - Màn hình tra cứu thông tin lao động dành cho công nhân viên: hợp đồng lao động (loại HĐ, số HĐ, ngày ký, ngày hiệu lực/hết hạn), mức lương thỏa thuận & các khoản phụ cấp trách nhiệm, cơm trưa.
  - Thẻ thông tin BHXH & BHYT chi tiết (mã số sổ, mức lương đóng BHXH, nơi đăng ký khám chữa bệnh ban đầu).
  - Xem và tải xuống các tài liệu/phụ lục hợp đồng đính kèm định dạng PDF; tích hợp liên kết từ màn hình Hồ sơ cá nhân.
- Nâng cấp Hàng đợi chấm công ngoại tuyến & Cảnh báo ca kíp (`lib/features/attendance/`):
  - Hỗ trợ 5 trạng thái đồng bộ rõ ràng (`recorded`, `pending`, `syncing`, `synced`, `failed`) lưu trữ bảo mật trên thiết bị qua `FlutterSecureStorage`.
  - Kiểm tra bán kính Geofence 50m và hiển thị khoảng cách thực tế từ vị trí chấm công đến tâm xưởng sản xuất.
  - Màn hình quản lý hàng đợi ngoại tuyến `OfflineQueueScreen` với bộ lọc theo trạng thái và đồng bộ lại thủ công 1-chạm.
  - Tính năng nhắc nhở chấm công theo ca nhà máy (đầu ca 07:45, nghỉ trưa 11:45, vào ca chiều 12:45, tan ca 17:00) dành cho công nhân không được mang điện thoại vào phân xưởng sản xuất.
  - Banner cảnh báo công ngoại tuyến chưa đồng bộ hiển thị liên tục tại trang chủ và màn hình chấm công.
- Xây dựng Phân hệ Xác nhận đăng nhập Web bằng QR (`lib/features/qr_auth/`):
  - Màn hình quét mã QR trực tiếp qua Camera với khung quét Saigon Tile và hiệu ứng laser scan line.
  - Bóc tách chi tiết phiên đăng nhập: tên trình duyệt, loại thiết bị, địa chỉ IP, vị trí địa lý, thời gian yêu cầu và đếm ngược thời gian hết hạn.
  - Cơ chế phê duyệt an toàn yêu cầu xác thực sinh trắc học vân tay / Face ID hoặc mã PIN trước khi xác nhận.
  - Xử lý toàn diện các kịch bản ngoại lệ: mã QR hết hạn, mã đã sử dụng, mã không hợp lệ, hoặc yêu cầu bị hủy.
  - Tích hợp nút quét QR tiện lợi ngay trên banner chào mừng trang chủ.
- Xây dựng bộ công cụ Pure Flutter Responsive Architecture (`lib/core/responsive/app_layout.dart`):
  - Hỗ trợ đầy đủ các tiện ích định cỡ theo tỷ lệ và phân loại màn hình: `context.w()`, `context.wp()`, `context.h()`, `context.hp()`, `context.custom(compact: ..., normal: ..., expanded: ...)`.
  - Bộ helper padding và khoảng cách co giãn tự động: `context.paddingCustom(...)`, `AppGap`, `gapW`/`gapH`.
  - Kiểm thử đơn vị toàn diện tại `test/core/responsive/app_layout_test.dart` (100% passed).
- Thiết lập hệ thống quốc tế hoá & bản địa hoá toàn diện (Zero-Hardcoding Policy):
  - Bổ sung hơn 250+ translation keys với sự đồng bộ song ngữ 1:1 chuẩn xác giữa Tiếng Việt (`lib/l10n/app_vi.arb`) và Tiếng Anh (`lib/l10n/app_en.arb`).
  - Hỗ trợ các placeholder động có kiểu dữ liệu (`{name}`, `{hours}`, `{minutes}`, `{date}`, `{count}`, `{used}`, `{total}`).
  - Cung cấp extension `context.l10n` tại `lib/core/extensions/l10n_extension.dart`.
- Lưu file thiết kế và PDF chức năng gốc vào `docs/source/` (`DESIGN.md`, `Phone.dc.html`, 2 file trình bày, PDF).
- Khởi tạo tài liệu kế hoạch dự án: `CLAUDE.md`, `docs/` (PRD, architecture, design-system, screens-mapping, api-contract, coding-rules, git-workflow, security), `.claude/skills/`.
- Thiết lập bộ workspace skills và rules tương đương cho các agent khác: `GEMINI.md`, `.agents/skills/` (`start-session`, `new-feature`, `design-review`, `git-commit`) cho Antigravity/chuẩn `.agents` và `.cursor/rules/` cho Cursor.
- Bổ sung `docs/roadmap.md` phân kỳ 6 Phase triển khai; điều chỉnh phạm vi Phase 0 (hỗ trợ Demo độc lập qua Mock Data, chỉ 2 môi trường dev/prod, giới hạn 2 vai trò NV & QL, tạm hoãn 3 chức năng P0 chưa có UI).
- Quy hoạch trọn bộ thư viện tại `docs/libraries-matrix.md` theo từng tầng Clean Architecture; thiết lập rule chuẩn SOLID `.agents/rules/solid-clean-architecture.md` (Antigravity) & `.cursor/rules/solid-clean-architecture.mdc` (Cursor); bổ sung skill `arch-review`.
- Tích hợp tài liệu quy hoạch thư viện và nguyên tắc cốt lõi Clean Architecture & SOLID vào quy trình bắt đầu phiên `start-session` cho mọi agent.
- Khởi tạo khung dự án Flutter di động (`com.vstech.vstech_hrm`) với Android `minSdk = 26`, iOS `14.0+`, cố định chế độ màn hình dọc (Portrait only).
- Xây dựng tầng kiến trúc Core hoàn chỉnh: Bộ lỗi (`Failure` / `AppException`), Quản lý Dependency Injection (`GetIt`), cấu hình Dio Client và Interceptors.
- Thiết lập hệ thống Design System chuẩn nhận diện Gạch bông (Saigon Tile): Custom Canvas `TilePatternPainter`, `AppColorsExtension` (Light/Dark), `AppTextStyles` (Source Sans 3, Tabular figures), các widget cốt lõi (`TileHeaderBanner`, `AmberCtaButton`, `PrimaryButton`, `SecondaryButton`, `AppCard`, `StatusChip`).
- Triển khai động cơ Standalone Demo Engine: Bộ mock fixtures JSON (`assets/mock/`) và `MockDioInterceptor` giả lập độ trễ mạng thực tế.
- Triển khai quản lý phiên làm việc & vai trò (`AuthCubit`, `UserSession`, `FlutterSecureStorage`) hỗ trợ chuyển đổi vai trò Demo tức thì (NV / QL).
- Thiết lập định tuyến `GoRouter` với `ShellRoute` 5 tab đáy linh hoạt theo vai trò và cơ chế bảo vệ phân quyền `authRedirectGuard`.
- Bộ automated test ban đầu cho Domain Failures, AuthCubit, và StatusChip widget.
- Cấu hình quyền Native Permissions trên Android (`AndroidManifest.xml`) và iOS (`Info.plist`) cho Camera, Location (GPS/Geofence), Wi-Fi và Biometrics.
- Xây dựng module Chấm công (`lib/features/attendance/`) theo chuẩn Clean Architecture & SOLID (P0 #3, #4, #5, #6):
  - **Domain**: Định nghĩa các thực thể nghiệp vụ (`AttendanceRecordEntity`, `AttendanceTodayEntity`, `AttendanceType`, `AttendanceClassification`), hợp đồng kho dữ liệu `AttendanceRepository`, và các Usecase chuyên biệt (`CheckInUseCase`, `CheckOutUseCase`, `GetTodayAttendanceUseCase`).
  - **Data**: Triển khai `AttendanceRemoteDataSource` kết nối REST API / Mock Data, các model DTO chuyển đổi (`AttendanceRecordModel`, `AttendanceTodayModel`), và `AttendanceRepositoryImpl` bắt lỗi chuyển đổi sang `Failure`.
  - **Presentation**: `AttendanceBloc` quản lý vòng đời camera, toạ độ Geofence 50m, và xác thực check-in/check-out; màn hình quét mặt `FaceScanScreen` chuẩn pixel `Phone.dc.html` với đồng hồ live ticking `HH:mm:ss`, khung oval `FaceOvalFrame` (236x290px kèm 4 góc SVG và laser scan line), `FaceScanTopBar`, `FaceScanStepProgress`, thẻ trạng thái vị trí `LocationStatusCard`, và biên lai chấm công bottom sheet `AttendanceSuccessSheet`.
- Bổ sung Chế độ Chấm công Ngoại tuyến (Offline Check-in Queue):
  - Cơ chế Face Vector Embedding 128 chiều tải và lưu cục bộ an toàn theo MSNV qua `FlutterSecureStorage`.
  - Tính toán độ tương đồng Cosine similarity, cho phép chấm công thành công khi độ khớp $\ge 85\%$.
  - Lưu hàng đợi ngoại tuyến an toàn trên thiết bị và tự động/thủ công đồng bộ lên máy chủ khi có mạng (`AttendanceOfflineQueueBanner`).
- Xây dựng Phân hệ Lịch làm việc & Ca kíp cá nhân (Shift Scheduling - P0 #8):
  - Thanh chọn 7 ngày Capsule trong tuần `ShiftWeekSelector` với chấm màu phân loại từng loại ca (Sáng, Chiều, Gãy, Hành chính, Đêm, Nghỉ tuần).
  - Thẻ chi tiết ca làm việc `ShiftDetailCard` hiển thị thời gian, nghỉ giữa ca, địa điểm chi nhánh, người quản lý, ghi chú.
  - Tính năng Đổi ca làm việc `ShiftSwapModal` cho phép gửi đề xuất đổi ca cho đồng nghiệp kèm lý do.
  - Phím tắt Báo tăng ca nhanh và Hộp thoại lưới lịch ca cả tháng `ShiftMonthGridDialog`.
- Hoàn thiện Màn hình Chấm công chính (`AttendanceScreen`): thẻ chấm công, 4 ô chỉ số giờ vào/ra, biểu đồ Donut phân bổ công tháng, nhật ký từng ngày `AttendanceDailyLogCard`, và nút liên kết Lịch ca kíp / Ngày lễ.
- Xây dựng Phân hệ Trung tâm Yêu cầu & Đơn từ (`RequestsScreen`):
  - Nút chọn tháng linh hoạt `MonthPickerButton` lọc toàn bộ danh sách đơn từ theo kỳ.
  - Quản lý danh sách và màn hình tạo mới 3 loại đơn: Đơn nghỉ phép (`LeaveRequestScreen`), Đăng ký tăng ca (`OvertimeRequestScreen`), Giải trình / Sửa công (`AttendanceCorrectionScreen` cho phép chọn ngày công cần sửa và giờ vào/ra linh hoạt).
  - Chu trình theo dõi tiến độ phê duyệt chuẩn 4 bước xuyên suốt.
- Xây dựng Trung tâm Phê duyệt (`ApprovalsScreen`) dành riêng cho vai trò Quản lý (MSS):
  - Tab "Duyệt" trên thanh điều hướng Bottom Bar với badge số lượng đơn chờ duyệt.
  - Bộ lọc đa năng theo loại đơn và trạng thái duyệt, thao tác phê duyệt / từ chối 1-chạm kèm lý do phản hồi.
- Hoàn thiện Phân hệ Lương & Thưởng:
  - Màn hình Bảng lương tháng (`PayrollScreen`) chi tiết lương cứng, KPI, phụ cấp, các khoản khấu trừ BHXH, BHYT, BHTN, thuế TNCN.
  - Phiếu lương chi tiết (`PayslipDetailScreen`) chuẩn sao kê bảo mật, nút ẩn/hiện số tiền, kích hoạt chống chụp/quay màn hình thiết bị (`screen_protector`).
  - Màn hình Thưởng & Ghi nhận (`RewardsScreen`) theo dõi điểm tích luỹ, vinh danh và đổi quà nội bộ.
- Xây dựng Phân hệ Tuyển dụng & Dịch vụ: Màn hình Tuyển dụng nội bộ (`InternalRecruitmentScreen`), Chi tiết công việc (`JobDetailScreen`), và Hub Tất cả dịch vụ (`AllServicesScreen`).
- Hoàn thiện Phân hệ Cá nhân & Cài đặt: Hồ sơ nhân viên (`ProfileScreen`), Cài đặt ứng dụng (`SettingsScreen` đổi ngôn ngữ Việt/Anh, giao diện Sáng/Tối, cấu hình sinh trắc học Face ID / Vân tay), và Trung tâm thông báo (`NotificationsScreen`).
- Xuất bản tài liệu báo cáo danh sách toàn bộ chức năng ứng dụng định dạng bảng PDF (`DANH_SACH_CHUC_NANG_HIEN_TAI_VSTECH_HRM.pdf`).
- Xuất bản báo cáo điều hành & kỹ thuật chuyên sâu về 04 chức năng bổ sung và mở rộng giai đoạn P0 (Cộng đồng nội bộ, Hợp đồng điện tử & Ký số, Hàng đợi & Banner cảnh báo công ngoại tuyến, Tổng hợp công theo ca tuần của tổ/nhóm) theo chuẩn nhà máy ~3.000 nhân sự: `docs/BAO_CAO_BO_SUNG_CHUC_NANG_P0.md`, `docs/bao_cao_bo_sung_chuc_nang_p0.html` và bản PDF trình ký `docs/BAO_CAO_BO_SUNG_CHUC_NANG_P0.pdf`.
- Bổ sung bộ Unit Test cho toàn bộ UseCases, `AttendanceBloc`, `OfflineAttendanceService`, và `ShiftScheduleMockDatasource` (21/21 tests pass).

### Changed
- Tái cấu trúc toàn bộ các màn hình và widget giao diện trên toàn ứng dụng:
  - Loại bỏ hoàn toàn các chuỗi văn bản hardcode trong UI presentation widgets, chuyển sang sử dụng `context.l10n`.
  - Chuẩn hoá kích thước và khoảng cách giao diện theo hệ thống `AppLayout` responsive.
  - Tuân thủ nghiêm ngặt giới hạn $\le 300$ dòng trên mỗi file mã nguồn Dart theo quy chuẩn Clean Architecture & SOLID.
- Cập nhật `docs/screens-mapping.md`: làm rõ nguồn gốc thiết kế pixel-level từ `docs/source/Phone.dc.html` (29 màn markup thực tế).
- Cập nhật `docs/roadmap.md`: đồng bộ trạng thái hoàn thành thực tế của Phase 0 (Foundation & Mock Engine), Phase 1 (Navigation Shell & Session), và Phase 2 (Personal Dashboard & Core Attendance Face Scan).


