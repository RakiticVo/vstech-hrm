---
name: design-review
description: Review 1 màn hình hoặc widget mới trong vstech-hrm so với docs/design-system.md và docs/screens-mapping.md trước khi coi là hoàn thành. Dùng sau khi code xong UI 1 màn hình, hoặc khi người dùng yêu cầu "review UI"/"kiểm tra design".
---

# Design review checklist

Đọc `docs/design-system.md` trước khi review nếu chưa đọc trong phiên hiện tại. Review theo đúng thứ tự dưới, báo cáo từng mục Pass/Fail kèm số dòng code liên quan nếu Fail.

## 1. Đối chiếu phạm vi (docs/screens-mapping.md)

- Màn này thuộc nhóm A (có thiết kế, trong P0)? Nếu thuộc nhóm B (P1/P2) hoặc nhóm C (chưa có thiết kế) — dừng lại, hỏi người dùng có nên build lúc này không, đừng tự ý implement.

## 2. Màu sắc

- [ ] Không có hex code hardcode trong widget — mọi màu lấy từ `AppColors`/`context.colors` (ThemeExtension).
- [ ] Amber đặc (`amberCta`) chỉ xuất hiện đúng 1 lần trên màn hình này.
- [ ] Xanh lá chỉ dùng cho trạng thái thành công, đỏ chỉ dùng cho lỗi — không dùng trang trí.
- [ ] Chữ/số trên nền màu nhạt dùng đúng bậc "mực" (`amberInk`/`greenInk`/`redInk`), không dùng thẳng màu "nét" cho text (rủi ro tương phản < 4.5:1).
- [ ] Chữ trên hoạ văn gạch bông dùng `cream` đặc, không dùng opacity.

## 3. Typography

- [ ] Dùng đúng bậc type scale trong `docs/design-system.md` §5 (không tự chế size/weight mới).
- [ ] Số liệu (tiền, giờ, ngày, mã NV, %) có `FontFeature.tabularFigures()`.
- [ ] Không dùng font-weight 900, không dùng cỡ chữ < 10px.

## 4. Spacing & hình khối

- [ ] Bán kính bo góc đúng theo cấp độ thẻ/nút/nhãn (§6).
- [ ] Lề ngang màn hình 16–18px, khoảng cách thẻ 9–11px, khoảng cách khối 20–22px.
- [ ] Không dùng shadow tuỳ tiện — chỉ thẻ "số dư" đè lên băng hoạ văn mới có shadow.

## 5. Icon & Font (2 điểm đã lệch DESIGN.md gốc)

- [ ] Icon dùng `material_symbols_icons`, tra bảng ánh xạ ở §7 nếu icon chưa có trong bảng — bổ sung vào bảng khi dùng icon mới.
- [ ] Font dùng `google_fonts` với family `Source Sans 3`, không vô tình để lại font mặc định hệ thống.

## 6. Trạng thái bắt buộc (docs/design-system.md §10)

- [ ] Màn/component này đã xử lý đủ: loading (skeleton đúng layout thật, không phải spinner giữa màn), empty (có giải thích), error (có đường thoát), success.
- [ ] Nếu là màn chấm công: đủ 3 trạng thái (chưa vào/đang làm/xong ca) với số liệu/nhãn/CTA đổi đúng theo bảng.

## 7. Copywriting

- [ ] Chuỗi tiếng Việt trong ARB tự nhiên, không dịch máy, không thuật ngữ kỹ thuật (vd tránh "Lỗi 422", ưu tiên "Chưa có giờ ra...").
- [ ] Mọi trạng thái lỗi có đường thoát rõ ràng (vd nút/link "Liên hệ HR").

## 8. Coding rules chung

- [ ] Không file nào vượt 300 dòng.
- [ ] Widget con dùng ≥2 nơi hoặc có state riêng đã được tách file đúng `docs/coding-rules.md` §2.
