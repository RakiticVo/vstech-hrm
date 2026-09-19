# Git Workflow

## 1. Branching (GitFlow đầy đủ)

| Branch | Vai trò |
| --- | --- |
| `main` | Code đã lên production. Chỉ nhận merge từ `release/*` hoặc `hotfix/*`. Mỗi merge = 1 tag version. |
| `develop` | Nhánh tích hợp — mọi `feature/*` merge vào đây trước. |
| `feature/<scope>-<mo-ta-ngan>` | Nhánh làm 1 chức năng/task cụ thể, tách từ `develop`. Vd: `feature/attendance-face-scan`, `feature/leave-apply-form`. |
| `release/<version>` | Tách từ `develop` khi chuẩn bị phát hành, chỉ sửa lỗi nhỏ + cập nhật `CHANGELOG.md`/version. Merge vào cả `main` và `develop` khi xong. |
| `hotfix/<version>-<mo-ta-ngan>` | Tách từ `main` khi cần vá lỗi khẩn cấp trên production, merge vào cả `main` và `develop`. |

Quy tắc đặt tên `<scope>` theo tên feature module trong `lib/features/` (attendance, leave, overtime, payroll, requests, approvals, dashboard, notifications, profile, auth...).

## 2. Commit message (Conventional Commits)

```
<type>(<scope>): <mô tả ngắn, tiếng Việt hoặc Anh đều được, ưu tiên nhất quán>
```

| Type | Dùng khi |
| --- | --- |
| `feat` | Thêm chức năng/màn hình mới |
| `fix` | Sửa lỗi |
| `refactor` | Tái cấu trúc code, không đổi hành vi |
| `test` | Thêm/sửa test |
| `docs` | Chỉ sửa tài liệu (`docs/`, `CLAUDE.md`, README) |
| `chore` | Việc linh tinh: cập nhật dependency, cấu hình CI, gitignore... |
| `style` | Format code, không đổi logic (thường tự động qua `dart format`) |
| `perf` | Cải thiện hiệu năng |

`<scope>` = tên feature module (vd `attendance`, `leave`, `payroll`, `router`, `di`, `theme`...). Ví dụ thực tế:

```
feat(attendance): thêm màn quét khuôn mặt 3 bước
fix(leave): sửa lỗi tính sai số ngày khi chọn nghỉ nửa ca
docs(prd): cập nhật acceptance criteria cho chức năng #11
chore(deps): nâng cấp go_router lên 14.x
```

Commit liên quan tới 1 chức năng P0 cụ thể nên ghi số thứ tự chức năng trong phần thân commit (không bắt buộc trong subject) để dễ truy vết lại `docs/prd.md`, vd:

```
feat(payroll): hiển thị chi tiết phiếu lương

Liên quan chức năng P0 #11 (docs/prd.md).
```

## 3. Pull Request

Dùng template ở `.github/PULL_REQUEST_TEMPLATE.md`. Mỗi PR nên:
- Trỏ về 1 hoặc vài chức năng P0 cụ thể (số thứ tự trong `docs/prd.md`).
- Base branch là `develop` (trừ hotfix base `main`).
- Tick đủ checklist: đã tự test trên thiết bị thật/simulator, đã cập nhật `CHANGELOG.md` nếu là user-facing change, đã chạy `flutter analyze` sạch.

## 4. CHANGELOG.md

Theo chuẩn [Keep a Changelog](https://keepachangelog.com/) + [Semantic Versioning](https://semver.org/):

```
## [Unreleased]
### Added
- ...
### Changed
- ...
### Fixed
- ...

## [0.1.0] - 2026-09-18
### Added
- Khởi tạo dự án, thiết lập kiến trúc Clean Architecture + BLoC.
```

Cập nhật mục `[Unreleased]` ngay trong PR đưa ra thay đổi user-facing (feature mới, fix bug ảnh hưởng người dùng). Khi tạo `release/*`, đổi `[Unreleased]` thành `[x.y.z] - YYYY-MM-DD` tương ứng.

Semantic Versioning cho app: `MAJOR.MINOR.PATCH`
- `MAJOR`: thay đổi phá vỡ tương thích lớn (vd đổi kiến trúc auth, không dùng cho giai đoạn hiện tại).
- `MINOR`: thêm chức năng P0/P1 mới hoàn chỉnh.
- `PATCH`: fix bug, cải thiện nhỏ.

## 5. CI (GitHub Actions) — hiện tại

File `.github/workflows/ci.yml` (tạo khi bắt đầu code, chưa tạo ở bước planning này) chỉ chạy:
- `flutter analyze` trên mọi push/PR vào `develop`/`main`.

Chưa bật `flutter test` hay build APK/IPA trong CI — bổ sung sau khi có MVP chạy ổn định, tránh phí thời gian setup sớm khi codebase còn thay đổi cấu trúc nhiều.
