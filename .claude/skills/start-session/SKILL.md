---
name: start-session
description: Nạp lại toàn bộ ngữ cảnh dự án vstech-hrm tường minh giữa phiên — khi nghi ngờ context cũ/thiếu, khi chuyển sang task lớn khác, hoặc khi người dùng yêu cầu "đọc context dự án"/"nạp lại ngữ cảnh"/"onboard vào dự án". Quy trình đầy đủ đã nằm sẵn trong AGENTS.md §0 (áp dụng tự động cho mọi agent, kể cả Claude Code) — skill này chỉ là lối gọi lại tường minh khi cần trong 1 phiên Claude Code.
---

# Nạp lại ngữ cảnh dự án (tường minh)

Thực hiện đúng quy trình đã mô tả ở **`AGENTS.md` mục 0 — "Quy trình bắt đầu phiên làm việc"**. Không lặp lại các bước ở đây để tránh 2 nơi trôi lệch nhau — đọc thẳng mục đó và làm theo.

Lưu ý riêng cho Claude Code: nội dung `AGENTS.md` đã được `CLAUDE.md` import (`@AGENTS.md`) nên bình thường đã có sẵn trong context ngay từ đầu phiên. Skill này hữu ích khi:
- Phiên đã chạy lâu, nghi ngờ context bị nén/mất chi tiết (compact).
- Người dùng chủ động gọi `/start-session` để ép đọc lại toàn bộ tài liệu mới nhất (phòng trường hợp docs vừa được cập nhật sau khi phiên bắt đầu).
- Chuẩn bị bàn giao/chuyển task lớn, muốn chắc chắn có đủ ngữ cảnh trước khi bắt tay vào.
