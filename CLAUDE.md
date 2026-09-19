> Đọc file này đầu tiên trong mọi phiên làm việc mới với Claude Code.

@AGENTS.md

---

## Ghi chú riêng cho Claude Code

Nội dung phía trên được import trực tiếp từ [AGENTS.md](AGENTS.md) — file ngữ cảnh chuẩn dùng chung cho mọi AI coding agent (Claude Code, ChatGPT/Codex, Antigravity, OpenCode...). Sửa nội dung chung ở `AGENTS.md`, **không** copy-paste lặp lại vào đây, để tránh 2 file trôi lệch nhau.

Phần dưới đây chỉ áp dụng riêng cho Claude Code (các agent khác không có cơ chế "skill" tương đương thì đọc thẳng `docs/*.md` liên quan thay thế).

### Skills (`.claude/skills/`)

| Skill | Dùng khi nào |
| --- | --- |
| `start-session` | Chạy đầu tiên khi bắt đầu 1 phiên/cuộc trò chuyện mới, hoặc khi nghi ngờ context cũ/thiếu — đọc toàn bộ `AGENTS.md` + `docs/*.md` + đối chiếu trạng thái code/git thực tế |
| `new-feature` | Scaffold 1 feature mới đúng cấu trúc Clean Architecture (data/domain/presentation + bloc stub) |
| `design-review` | Review 1 màn hình/component mới so với `docs/design-system.md` (màu, type, spacing, state) trước khi coi là xong |
| `git-commit` | Viết commit message/CHANGELOG entry đúng chuẩn đã chốt |
