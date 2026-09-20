> Đọc file này đầu tiên trong mọi phiên làm việc mới với Google Antigravity / Gemini.

@AGENTS.md

---

## Ghi chú riêng cho Antigravity / Gemini

Nội dung phía trên được liên kết trực tiếp từ [AGENTS.md](AGENTS.md) — file ngữ cảnh chuẩn dùng chung cho mọi AI coding agent (Claude Code, Antigravity, Cursor, ChatGPT/Codex, OpenCode...). Sửa nội dung chung ở `AGENTS.md`, **không** copy-paste lặp lại vào đây, để tránh các file trôi lệch nhau.

Phần dưới đây áp dụng cho Google Antigravity / Gemini CLI.

### Skills (`.agents/skills/`)

| Skill | Dùng khi nào |
| --- | --- |
| `start-session` | Chạy đầu tiên khi bắt đầu 1 phiên/cuộc trò chuyện mới, hoặc khi nghi ngờ context cũ/thiếu — đọc toàn bộ `AGENTS.md` + `docs/*.md` + đối chiếu trạng thái code/git thực tế |
| `new-feature` | Scaffold 1 feature mới đúng cấu trúc Clean Architecture (data/domain/presentation + bloc stub) |
| `design-review` | Review 1 màn hình/component mới so với `docs/design-system.md` (màu, type, spacing, state) trước khi coi là xong |
| `arch-review` | Review kiến trúc Clean Architecture, SOLID, giới hạn 300 dòng và ranh giới tầng trước khi hoàn thành feature |
| `git-commit` | Viết commit message/CHANGELOG entry đúng chuẩn đã chốt |
