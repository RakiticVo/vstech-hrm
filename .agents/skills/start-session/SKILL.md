---
name: start-session
description: Nạp lại toàn bộ ngữ cảnh dự án vstech-hrm tường minh giữa phiên — khi nghi ngờ context cũ/thiếu, khi chuyển sang task lớn khác, hoặc khi người dùng yêu cầu "đọc context dự án"/"nạp lại ngữ cảnh"/"onboard vào dự án"/"start-session". Quy trình đầy đủ đã nằm sẵn trong AGENTS.md §0 (áp dụng tự động cho mọi agent).
---

# Nạp lại ngữ cảnh dự án (tường minh)

Thực hiện đúng quy trình đã mô tả ở **`AGENTS.md` mục 0 — "Quy trình bắt đầu phiên làm việc"**. Không lặp lại các bước ở đây để tránh các nơi trôi lệch nhau — đọc thẳng mục đó và làm theo:

1. **Đọc tài liệu gốc theo thứ tự**: `AGENTS.md` → `docs/roadmap.md` → `docs/prd.md` → `docs/architecture.md` → `docs/libraries-matrix.md` → `docs/coding-rules.md` (kèm `.agents/rules/solid-clean-architecture.md`) → `docs/design-system.md` → `docs/screens-mapping.md` → `docs/api-contract.md` → `docs/git-workflow.md` → `docs/security.md` → `CHANGELOG.md`.
2. **Đối chiếu với trạng thái thực tế của repo**: `pubspec.yaml`, git branch & status, thư mục `lib/features/`.
3. **Tóm tắt ngắn gọn cho người dùng**:
   - Giai đoạn hiện tại của dự án.
   - **Kỷ luật cốt lõi Clean Architecture & SOLID**: Phụ thuộc 1 chiều `presentation → domain ← data`; `domain` độc lập 100% (pure Dart, cấm import UI/network); 1 Usecase = 1 hành động nghiệp vụ; dùng Freezed sealed unions; DI qua `GetIt`; giới hạn cứng **≤ 300 dòng/file**; cấm `print()`.
   - Các quyết định lớn dễ quên (Source Sans 3, Material Symbols, offline queue đã hoãn, Phase 0 chỉ làm 2 vai trò NV & QL, 3 chức năng P0 chưa có UI tạm hoãn, 2 môi trường dev & prod, Mock Data demo).
   - Nêu sai khác giữa docs và thực tế (nếu có).
   - Hỏi task cụ thể muốn làm — không tự ý bắt đầu code.

Skill này hữu ích khi:
- Bắt đầu phiên làm việc mới hoặc chuẩn bị nhận task lớn.
- Phiên đã chạy lâu, nghi ngờ context bị nén/mất chi tiết (compact).
- Người dùng chủ động yêu cầu nạp lại context dự án.
