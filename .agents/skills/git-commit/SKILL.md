---
name: git-commit
description: Viết commit message, cập nhật CHANGELOG.md, và đặt tên branch cho vstech-hrm đúng theo docs/git-workflow.md (Conventional Commits + GitFlow + Keep a Changelog). Dùng khi chuẩn bị commit, tạo branch mới, hoặc mở PR.
---

# Git commit / branch / changelog helper

Đọc `docs/git-workflow.md` trước nếu chưa đọc trong phiên hiện tại.

## Khi tạo branch mới

1. Xác định loại: `feature/` (việc mới từ `develop`), `release/` (chuẩn bị phát hành từ `develop`), `hotfix/` (vá khẩn từ `main`).
2. Với `feature/`, đặt tên `feature/<scope>-<mo-ta-ngan-khong-dau>`, `<scope>` = tên feature module trong `lib/features/` (vd `attendance`, `leave`, `payroll`). Ví dụ: `feature/leave-apply-form`, `feature/payroll-biometric-lock`.
3. Xác nhận branch nền tảng đúng (`git checkout develop && git pull` trước khi tách `feature/*`; `git checkout main && git pull` trước khi tách `hotfix/*`) trước khi tạo branch mới — không tự ý tạo branch từ branch hiện tại đang đứng nếu chưa chắc đúng gốc.

## Khi viết commit message

Format: `<type>(<scope>): <mô tả ngắn>`

- Chọn `type` đúng bảng trong `docs/git-workflow.md` §2 (`feat`/`fix`/`refactor`/`test`/`docs`/`chore`/`style`/`perf`).
- `<scope>` = tên feature module hoặc phần hạ tầng (`router`, `di`, `theme`, `security`...).
- Nếu commit liên quan 1 chức năng P0 cụ thể, thêm dòng trong phần thân: `Liên quan chức năng P0 #<n> (docs/prd.md).`
- Không viết commit message chung chung kiểu "update code", "fix bug" — luôn nói rõ cái gì thay đổi.

## Khi cập nhật CHANGELOG.md

- Chỉ thêm entry vào `[Unreleased]` cho thay đổi **user-facing** (feature mới hoàn chỉnh, fix bug ảnh hưởng trải nghiệm người dùng). Refactor nội bộ/chore không cần lên changelog.
- Đặt đúng nhóm: `Added` (tính năng mới) / `Changed` (thay đổi hành vi có sẵn) / `Fixed` (sửa lỗi) / `Removed` (bỏ tính năng).
- Viết bằng tiếng Việt, ngắn gọn, nói được giá trị cho người dùng cuối chứ không phải mô tả code, vd: `- Thêm màn Xin nghỉ phép với cảnh báo trùng lịch tự động.` thay vì `- Implement LeaveScreen widget`.

## Khi mở Pull Request

- Dùng đúng `.github/PULL_REQUEST_TEMPLATE.md`, điền đủ mục "Chức năng liên quan" (trỏ số thứ tự ở `docs/prd.md`).
- Base branch mặc định `develop` (trừ hotfix → `main`).
- Nhắc kiểm tra lại checklist bảo mật ở `docs/security.md` §7 nếu PR chạm token/lương/sinh trắc.
