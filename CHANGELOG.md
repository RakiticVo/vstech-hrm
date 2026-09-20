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
