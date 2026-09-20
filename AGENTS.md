# vstech-hrm — Agent Context (dùng chung cho mọi AI coding agent)

> File này là nguồn ngữ cảnh chuẩn (canonical) cho bất kỳ AI coding agent nào làm việc trên repo này — Claude Code, ChatGPT/Codex, Antigravity, OpenCode, Cursor, Copilot, Aider, v.v. Đọc file này trước khi làm bất kỳ task nào. Chi tiết sâu hơn nằm ở `docs/*.md`, được trỏ tới từ từng mục bên dưới — đọc file này + mục docs liên quan tới task đang làm là đủ ngữ cảnh, không cần hỏi lại người dùng những điều đã chốt ở đây.
>
> Repo hiện ở giai đoạn **planning/thiết lập nền tảng** — chưa chạy `flutter create`, chưa có code Dart thật. Remote: https://github.com/RakiticVo/vstech-hrm. Khi agent bắt đầu code, hãy tuân thủ đúng mọi quyết định trong file này và `docs/`.

## 0. Quy trình bắt đầu phiên làm việc (bắt buộc cho MỌI agent)

Áp dụng đầy đủ quy trình này khi: bắt đầu 1 phiên/cuộc trò chuyện hoàn toàn mới, chuẩn bị nhận 1 task lớn/không rõ phạm vi, hoặc người dùng yêu cầu tường minh "đọc lại context dự án"/"nạp lại ngữ cảnh". Không cần áp dụng đầy đủ nếu task rất hẹp và rõ ràng (vd sửa 1 lỗi chính tả trong 1 file cụ thể).

1. **Đọc tài liệu gốc theo thứ tự**: file này (`AGENTS.md`) → `docs/roadmap.md` → `docs/prd.md` → `docs/architecture.md` → `docs/libraries-matrix.md` → `docs/coding-rules.md` (kèm `.agents/rules/solid-clean-architecture.md`) → `docs/design-system.md` → `docs/screens-mapping.md` → `docs/api-contract.md` → `docs/git-workflow.md` → `docs/security.md` → `CHANGELOG.md` (đặc biệt mục `[Unreleased]`).
2. **Đối chiếu với trạng thái thực tế của repo** — tài liệu có thể đã lỗi thời so với code thật:
   - Kiểm tra `pubspec.yaml` có tồn tại chưa (đã scaffold Flutter thật hay vẫn ở giai đoạn planning thuần).
   - Nếu là git repo: xem lịch sử commit và trạng thái working tree để biết tiến độ thực tế, branch hiện tại, có thay đổi chưa commit không.
   - Nếu `lib/features/` đã tồn tại: liệt kê feature đã có thư mục, đối chiếu với 25 chức năng P0 trong `docs/prd.md` để biết cái nào đã làm/đang làm/chưa đụng tới.
   - Nếu phát hiện sai khác rõ ràng giữa docs và thực tế — nêu rõ ở bước 3, **không tự ý sửa docs** khi chưa được yêu cầu.
3. **Tóm tắt ngắn gọn cho người dùng** trước khi nhận task (không lặp nguyên văn docs):
   - Giai đoạn hiện tại của dự án (planning / đang code / đã có bao nhiêu feature).
   - **Kỷ luật cốt lõi Clean Architecture & SOLID**: Phụ thuộc 1 chiều `presentation → domain ← data`; `domain` độc lập 100% (pure Dart, cấm import UI/network); 1 Usecase = 1 hành động nghiệp vụ; dùng Freezed sealed unions; DI qua `GetIt`; giới hạn cứng **≤ 300 dòng/file**; cấm `print()`.
   - Nhắc nhanh các quyết định lớn dễ quên: đã đổi Manrope→Source Sans 3, Lucide→Material Symbols; chấm công ngoại tuyến (offline queue) đã hoãn; **Phase 0 chỉ làm 2 vai trò: NV và QL** (vai trò BGĐ hoãn); **3 chức năng P0 chưa có UI tạm hoãn** (#1 Referral, #2 Pre-onboarding, #8 Lịch ca riêng) chờ người dùng cung cấp UI; **chỉ dùng 2 môi trường: dev và prod**; hỗ trợ **chế độ Demo độc lập với Mock Data**.
   - Nêu rõ nếu có sai khác giữa docs và thực tế phát hiện ở bước 2, hỏi người dùng có muốn cập nhật docs không.
   - Hỏi người dùng task cụ thể muốn làm trong phiên này — **không tự đoán/tự bắt đầu code** khi chưa được giao task rõ ràng.

Quy trình này áp dụng như nhau cho mọi agent đọc file này (Claude Code, ChatGPT/Codex, Antigravity, OpenCode, Cursor, Copilot, Aider...). Để tiện gọi lại tường minh giữa phiên (khi nghi ngờ context cũ/thiếu hoặc người dùng yêu cầu), dự án đã cấu hình sẵn skill `start-session` cho các công cụ:
- **Claude Code**: `.claude/skills/start-session/SKILL.md` (gọi `/start-session`).
- **Antigravity / các agent theo chuẩn `.agents`**: `.agents/skills/start-session/SKILL.md`.
- **Cursor**: `.cursor/rules/start-session.mdc` (gọi `@start-session`).
Bản chất quy trình giống hệt mục này.

## 1. Sản phẩm là gì

B2B SaaS HRM mobile app, module **Employee App** (ứng dụng cho nhân viên/quản lý/ban giám đốc dùng hàng ngày). Nghiệp vụ chuẩn hoá quanh 4 trụ cột: **Tuyển dụng – Công – Lương – Thưởng**. Nguồn nghiệp vụ gốc: `DANH_SACH_CHUC_NANG_HRM_THEO_UU_TIEN_v2_BGD.pdf` (71 chức năng, ưu tiên P0/P1/P2).

- **Giai đoạn hiện tại**: chỉ build **25 chức năng P0 (Must Have/MVP)**. P1 (38 CN) và P2 (8 CN) là backlog, chưa động vào trừ khi có quyết định mới.
- **Đã loại khỏi P0 hiện tại**: Chấm công ngoại tuyến / hàng đợi offline — tạm hoãn, xem [docs/prd.md](docs/prd.md).
- **Loại hình triển khai**: single-tenant (1 doanh nghiệp) trước, nhưng kiến trúc dữ liệu để mở cho multi-tenant sau (không hardcode giả định chỉ có 1 công ty ở tầng domain).
- **Repo này** chỉ chứa **mobile app (Flutter)**. Backend là repo/team riêng, đang phát triển song song, **chưa có OpenAPI/Swagger chính thức** → xem [docs/api-contract.md](docs/api-contract.md) cho hợp đồng API kỳ vọng mà mobile team tự định nghĩa.
- **Nguồn thiết kế UI**: `DESIGN.md` gốc (hướng "Gạch bông/Saigon tile") + 2 file trình bày `HRM Employee App.dc.html` / `HRM Employee App-print.dc.html` — đã tổng hợp lại vào [docs/design-system.md](docs/design-system.md). File `Phone.dc.html` (markup thật từng màn) **chưa có** — khi cần chi tiết pixel-level một màn cụ thể, hỏi người dùng trước khi đoán.
- **Đối chiếu 29 màn hình thiết kế ↔ 25 chức năng P0**: có khoảng lệch (một số màn trong design thuộc P1/P2, một số chức năng P0 chưa có màn thiết kế) — xem bảng đối chiếu ở [docs/screens-mapping.md](docs/screens-mapping.md) trước khi bắt đầu bất kỳ màn hình nào.

## 2. Người dùng & vai trò

Ở **Phase 0/MVP**, ứng dụng tập trung hỗ trợ **2 vai trò cốt lõi**:

| Vai trò | Viết tắt | Khác biệt trong UI | Trạng thái Phase 0 |
| --- | --- | --- | --- |
| Nhân viên | NV / ESS | Mặc định: chấm công, đơn từ, lương, hồ sơ | **Active (MVP)** |
| Quản lý trực tiếp | QL / MSS | + dải chờ duyệt trên trang chủ, tab "Yêu cầu" có badge, màn Phê duyệt (duyệt cấp 1) | **Active (MVP)** |
| Ban Giám đốc | BGĐ / C-level | Tab 1 → "Điều hành" (Bảng điều hành), tab 3 → "Phê duyệt cuối" (duyệt cấp cuối) | *Tạm hoãn (Phase sau)* |

Chu trình duyệt chuẩn: `Nhân viên gửi → Quản lý trực tiếp → HR xác nhận → Giám đốc phê duyệt` (4 đoạn tiến độ luôn hiển thị đủ 4 bước trên UI chi tiết đơn).

## 3. Tech stack đã chốt (không tự ý đổi khi code)

| Hạng mục | Lựa chọn | Ghi chú |
| --- | --- | --- |
| Framework | Flutter (Dart) | Android + iOS, chỉ portrait, chỉ điện thoại |
| Kiến trúc | Clean Architecture (data/domain/presentation), feature-first | [docs/architecture.md](docs/architecture.md) |
| State management | BLoC / Cubit (`flutter_bloc`) | Mỗi feature có bloc/cubit riêng |
| Dependency Injection | GetIt | Không dùng Riverpod |
| Routing | `go_router` | ShellRoute theo vai trò, redirect theo auth/role, deep-link |
| Networking | `dio` + `retrofit` | Interceptor JWT/retry/logging |
| HTTP logging | `pretty_dio_logger` | Chỉ bật ở debug/dev |
| App logging | `logger` (PrettyPrinter) | Không dùng `print()` |
| Models/JSON | `freezed` + `json_serializable` | |
| Error handling | `fpdart` — `Either<Failure, T>` xuyên suốt | Không try-catch trần ở presentation |
| Form validation | `formz` | 3 lớp: cơ bản / logic ngày tháng / cảnh báo trùng lịch client-side |
| i18n | Flutter `intl` chuẩn (gen-l10n + ARB) | Việt + Anh từ đầu |
| Theme | Sáng/Tối, mặc định theo hệ thống, override lưu local | Token màu ở [docs/design-system.md](docs/design-system.md) |
| Font | `google_fonts` — **Source Sans 3** (đã đổi khỏi Manrope trong DESIGN.md gốc) | Giữ nguyên type scale gốc |
| Icon | `material_symbols_icons` — **Material Symbols** (đã đổi khỏi Lucide trong DESIGN.md gốc) | Bảng ánh xạ ở design-system.md |
| Hoạ văn gạch bông | `CustomPainter` tự vẽ Canvas | Không dùng asset ảnh |
| Local biometric | `local_auth` | Khác AI Face Recognition (xử lý backend) |
| Camera (quét khuôn mặt) | `camera` | |
| Chọn ảnh/tệp đính kèm | `image_picker` + `file_picker` | |
| GPS | `geolocator` | |
| Wi-Fi info | `network_info_plus` | |
| Secure storage | `flutter_secure_storage` | JWT/refresh token, không dùng SharedPreferences |
| Env config | `flutter_dotenv` | `.env` không commit, chỉ commit `.env.example` |
| Push notification | `firebase_messaging` + `flutter_local_notifications` | |
| Crash/Analytics | Firebase Crashlytics + Analytics | |
| Chống chụp màn hình | `screen_protector` | Riêng màn Phiếu lương |
| Root/jailbreak detection | `safe_device` (hoặc `freerasp`) | |
| App icon | `flutter_launcher_icons` | Cấu hình khi có logo thật |
| Lint | `very_good_analysis` | |
| Test/Mock | `flutter_test` + `bloc_test` + `mocktail` | Không dùng `mockito` |
| Phiếu lương | Custom UI từ dữ liệu API — **không** dùng PDF viewer | |

**Platform targets**: Android `minSdkVersion 26` (8.0+), target = mới nhất. iOS deployment target `14.0+`.

## 4. Cấu trúc thư mục (tóm tắt — chi tiết ở docs/architecture.md)

```
lib/
  core/           # shared: theme, network client, router, DI, Failure classes, shared widgets
  features/
    <feature>/
      data/        # datasources, models (freezed DTO), repository impl
      domain/      # entities, repository interface (abstract), usecases
      presentation/
        bloc/      # <feature>_bloc.dart / event / state (hoặc cubit)
        screens/   # 1 file = 1 màn hình
        widgets/   # widget con CHỈ dùng trong feature này
  l10n/            # ARB files
docs/              # tài liệu chi tiết
```

Nguyên tắc phụ thuộc: `presentation → domain ← data`. `domain` không import gì từ `data`/`presentation` (Dependency Inversion).

## 5. Coding rules (bắt buộc — chi tiết ở docs/coding-rules.md)

1. **SOLID** xuyên suốt, đặc biệt Single Responsibility và Dependency Inversion.
2. **Giới hạn 300 dòng/file**, không ngoại lệ.
3. **Tách widget**: dùng ≥2 nơi hoặc có state riêng → bắt buộc file riêng trong `presentation/widgets/`. Widget hiển thị thuần, dùng đúng 1 lần → được phép giữ làm private method trong cùng file (miễn ≤300 dòng).
4. Không giới hạn số lượng function/file, chỉ cần mỗi function làm đúng 1 việc.
5. Validate nhiều lớp qua `formz`: cơ bản (required/format/độ dài) + logic ngày tháng + cảnh báo trùng lịch (client-side cache) — hiển thị inline, real-time. Logic nghiệp vụ phức tạp để backend xử lý.
6. Không dùng `print()` — luôn `logger`. Không log token/dữ liệu nhạy cảm dù ở debug mode.
7. Token/dữ liệu nhạy cảm luôn ở `flutter_secure_storage`, không bao giờ `SharedPreferences`.

## 6. Git & quy trình (chi tiết ở docs/git-workflow.md)

- **GitFlow đầy đủ**: `main` / `develop` / `feature/*` / `release/*` / `hotfix/*`.
- **Commit**: Conventional Commits (`feat:`, `fix:`, `chore:`, `refactor:`, `test:`, `docs:`), scope = tên feature.
- **CHANGELOG.md**: Keep a Changelog + Semantic Versioning.
- **CI (GitHub Actions)**: hiện chỉ chạy `flutter analyze` trên push/PR.
- **PR template**: `.github/PULL_REQUEST_TEMPLATE.md`.

## 7. Bảo mật (chi tiết ở docs/security.md)

- Mở khoá app / xem màn lương yêu cầu `local_auth`.
- Chấm công AI Face Recognition: mobile chỉ capture ảnh/video, gửi kèm GPS + BSSID lên backend xử lý — không tự xử lý AI ở client.
- Ràng buộc 1 thiết bị/tài khoản, phát hiện root/jailbreak + giả lập GPS.
- Chống chụp/quay màn hình ở màn Phiếu lương.
- Token luôn `flutter_secure_storage`, không log token dù debug mode.

## 8. Bản đồ tài liệu đầy đủ

| File | Nội dung |
| --- | --- |
| [docs/roadmap.md](docs/roadmap.md) | Lộ trình phân kỳ 6 Phase, chiến lược Standalone Demo (Mock Data), phân công chức năng |
| [docs/prd.md](docs/prd.md) | 25 chức năng P0 chi tiết + acceptance criteria, backlog P1/P2, hạng mục đã hoãn |
| [docs/architecture.md](docs/architecture.md) | Clean Architecture chi tiết, cấu trúc thư mục đầy đủ, luồng dữ liệu, DI, router, mock engine |
| [docs/design-system.md](docs/design-system.md) | Màu, typography, spacing, component spec |
| [docs/screens-mapping.md](docs/screens-mapping.md) | Đối chiếu 29 màn thiết kế ↔ 25 chức năng P0, khoảng lệch và quyết định chốt |
| [docs/api-contract.md](docs/api-contract.md) | Hợp đồng API kỳ vọng cho từng feature P0 |
| [docs/libraries-matrix.md](docs/libraries-matrix.md) | Bảng quy hoạch toàn bộ thư viện theo tầng Clean Architecture & ma trận import |
| [docs/coding-rules.md](docs/coding-rules.md) | SOLID, quy tắc tách file/widget, validation, naming |
| [docs/git-workflow.md](docs/git-workflow.md) | GitFlow, commit convention, PR template, CHANGELOG |
| [docs/security.md](docs/security.md) | Toàn bộ yêu cầu bảo mật đặc thù |

## 9. Ghi chú theo từng agent/tool

- **Claude Code**: đọc `CLAUDE.md` (file đó import trực tiếp nội dung file này qua `@AGENTS.md`, các skill tại `.claude/skills/`: `start-session`, `new-feature`, `design-review`, `arch-review`, `git-commit`).
- **Antigravity / Gemini**: đọc `GEMINI.md` và `AGENTS.md`. Bộ workspace skills tương đương đã được cấu hình tại `.agents/skills/` (`start-session`, `new-feature`, `design-review`, `arch-review`, `git-commit`) và workspace rule tại `.agents/rules/solid-clean-architecture.md`.
- **Cursor**: đọc `.cursor/rules/project-context.mdc`, rule toàn cục `.cursor/rules/solid-clean-architecture.mdc`, và `AGENTS.md`. Đã cấu hình các rule/skill tương ứng trong `.cursor/rules/` (`start-session.mdc`, `new-feature.mdc`, `design-review.mdc`, `arch-review.mdc`, `git-commit.mdc`).
- **ChatGPT/Codex, Aider, OpenCode**: các tool này tự động tìm và đọc `AGENTS.md` ở root (hoặc chuẩn `.agents/` nếu được hỗ trợ) — đọc file này làm điểm bắt đầu.
- **Bất kỳ agent nào khác** không có quy ước riêng: đọc file này làm điểm bắt đầu, rồi đọc `docs/` theo nhu cầu task.

## 10. Việc còn thiếu / cần quyết định thêm

- `Phone.dc.html` (markup thật 29 màn) chưa có — khi làm màn cụ thể mà thiếu chi tiết pixel-level, hỏi người dùng thay vì đoán.
- Backend đang phát triển song song — app sử dụng **chế độ Demo độc lập với Mock Data** (`USE_MOCK_DATA=true`) để hoàn thiện toàn bộ luồng demo trước mà không bị block.
- Môi trường: Chỉ duy trì **`dev`** và **`prod`** (bỏ `staging`).
- Quyết định vai trò Phase 0: **Chỉ làm 2 vai trò: NV và QL** (vai trò BGĐ tạm hoãn).
- Quyết định chức năng chưa có UI: **3 chức năng P0 (#1 Referral, #2 Pre-onboarding, #8 Lịch ca riêng) tạm hoãn**, người dùng sẽ cung cấp UI sau.
- Logo/app icon chính thức chưa có.
- Đã hoãn: Chấm công ngoại tuyến (offline queue).
