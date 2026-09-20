# Changelog

Định dạng theo [Keep a Changelog](https://keepachangelog.com/vi/1.1.0/), dự án tuân theo [Semantic Versioning](https://semver.org/lang/vi/). Chi tiết quy ước ở [docs/git-workflow.md](docs/git-workflow.md#4-changelogmd).

## [Unreleased]

### Added
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
- Đấu nối định tuyến `AppRoutes.checkInCamera` (`/home/check-in`) và tích hợp nút CTA Chấm công nhanh trên màn hình chính `HomeScreen`.
- Bổ sung bộ Unit Test cho toàn bộ UseCases và `AttendanceBloc` với Mocktail và BlocTest.

### Changed
- Cập nhật `docs/screens-mapping.md`: làm rõ nguồn gốc thiết kế pixel-level từ `docs/source/Phone.dc.html` (29 màn markup thực tế).
- Cập nhật `docs/roadmap.md`: đồng bộ trạng thái hoàn thành thực tế của Phase 0 (Foundation & Mock Engine), Phase 1 (Navigation Shell & Session), và Phase 2 (Personal Dashboard & Core Attendance Face Scan).


