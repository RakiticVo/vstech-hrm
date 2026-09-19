# Design System — Flutter tokens (chuyển thể từ `DESIGN.md` gốc)

Nguồn chân lý: `DESIGN.md` (hướng thiết kế "Gạch bông / Saigon tile", chốt 16/09/2026) + `HRM Employee App.dc.html` / `HRM Employee App-print.dc.html`. Tài liệu này chuyển các token CSS/HTML gốc sang giá trị dùng trực tiếp trong Flutter (`ThemeData`, `TextStyle`, `Color`), và ghi rõ **2 điểm đã lệch khỏi bản gốc theo quyết định của người dùng**: font chữ và icon set.

## 0. Hai điểm đã lệch khỏi DESIGN.md gốc

| Token | DESIGN.md gốc | Đã chốt dùng | Lý do |
| --- | --- | --- | --- |
| Font | Manrope | **Source Sans 3** (qua `google_fonts`) | Quyết định người dùng — giữ nguyên type scale (size/weight) gốc, chỉ đổi typeface |
| Icon | Lucide | **Material Symbols** (qua `material_symbols_icons`) | Quyết định người dùng — cần bảng ánh xạ icon tương đương, xem mục 7 |

Toàn bộ màu sắc, spacing, bán kính, component spec khác giữ **nguyên 100%** theo DESIGN.md.

## 1. Màu (Sáng)

| Token Dart (đề xuất) | Vai trò | Hex |
| --- | --- | --- |
| `AppColors.tileDark` | Teal đậm — nền hoạ văn, dải phân mục, nút tròn "Tất cả" | `#0A544E` |
| `AppColors.tealPrimary` | Mực/icon/số liệu nhấn/viền nút phụ/tab đang chọn | `#0F766E` |
| `AppColors.tealLight` | Trạng thái phụ, link hover | `#14B8A6` |
| `AppColors.amberCta` | **Chỉ** CTA chính, viền, nền tô nhạt, vòng tiến độ ca | `#F59E0B` |
| `AppColors.amberInk` | Chữ/số amber trên nền trắng | `#B45309` |
| `AppColors.amberInkOnTint` | Chữ/số amber trên nền tô nhạt (đậm hơn 1 bậc) | `#92400E` |
| `AppColors.greenInk` | Chữ/số thành công | `#047857` |
| `AppColors.redInk` | Chữ/số lỗi | `#B91C1C` |
| `AppColors.cream` | Chữ/icon trên nền hoạ văn | `#FFF8EC` |
| `AppColors.pageBackground` | Nền trang (giấy ấm) | `#F6F4EF` |
| `AppColors.cardBackground` | Nền thẻ | `#FFFFFF` |
| `AppColors.cardSecondary` | Nền ô icon, khối trích dẫn | `#F0EDE5` |
| `AppColors.border` | Viền thẻ, đường kẻ hàng | `#E3DFD6` |
| `AppColors.textPrimary` | Chữ chính | `#111827` |
| `AppColors.textSecondary` | Chữ phụ | `#5B6572` |
| `AppColors.success` | Trạng thái thành công (không dùng làm màu trang trí) | `#10B981` |
| `AppColors.warning` | Cảnh báo | `#F59E0B` |
| `AppColors.error` | Lỗi, hành động phá huỷ | `#EF4444` |

## 2. Màu (Tối)

| Token | Hex |
| --- | --- |
| Nền | `#111827` |
| Thẻ | `#1F2937` |
| Thẻ phụ | `#263243` |
| Teal | `#2DD4BF` |
| Teal nhạt | `#5EEAD4` |
| Amber | `#FBBF24` |
| Chữ chính | `#F8FAFC` |
| Chữ phụ | `#94A3B8` |
| Viền | `#374151` |
| Thành công | `#34D399` |
| Lỗi | `#F87171` |
| Băng hoạ văn (giữ nguyên nền) | `#0A544E`, hoạ văn đổi sang `rgba(45,212,191,.16)` |

Implement bằng `ThemeExtension<AppColorsExtension>` để `context.colors.tealPrimary` tự đổi theo `Brightness` hiện tại — không hardcode `if (isDark)` rải rác trong widget.

## 3. Luật màu (bắt buộc tuân thủ khi code UI)

- Amber đặc chỉ xuất hiện **1 lần** mỗi màn hình. Vòng tiến độ ca tính là nét (stroke), không phải nền (fill).
- Xanh lá chỉ dùng cho thành công, đỏ chỉ dùng cho lỗi — không dùng trang trí.
- Nền tô màu luôn tính theo công thức tương đương `Color.alphaBlend(color.withOpacity(.14), background)` — không tự chế hex mới. Trong Flutter: dùng `color.withOpacity(0.14)` phủ lên `cardBackground` nếu cần opaque, hoặc `Color.lerp`.
- Tách màu **mực** (chữ/số) khỏi màu **nét** (viền/nền tô/thanh tiến độ/nút): amber/xanh/đỏ gốc dùng cho viền-nền tô-progress-nút; chữ/số cùng tông phải dùng bậc mực đậm hơn (`amberInk`/`greenInk`/`redInk`) để đạt tương phản 4.5:1. Amber trên nền tô nhạt dùng `amberInkOnTint` (đậm thêm 1 bậc nữa).
- Ở dark mode, màu gốc đã đủ tương phản nên mực trùng với nét — không cần bậc riêng.
- Chữ trên nền hoạ văn luôn `cream` (`#FFF8EC`) đặc, không dùng opacity.

## 4. Hoạ văn gạch bông (CustomPainter)

Công thức gốc (CSS):

```css
background-color: #0A544E;
background-image:
  radial-gradient(circle at 0 0,      transparent 12px, rgba(255,248,236,.19) 12px 14.5px, transparent 15px),
  radial-gradient(circle at 100% 0,   transparent 12px, rgba(255,248,236,.19) 12px 14.5px, transparent 15px),
  radial-gradient(circle at 0 100%,   transparent 12px, rgba(255,248,236,.19) 12px 14.5px, transparent 15px),
  radial-gradient(circle at 100% 100%,transparent 12px, rgba(255,248,236,.19) 12px 14.5px, transparent 15px),
  radial-gradient(circle at 50% 50%,  rgba(255,248,236,.19) 0 2.5px, transparent 3px);
background-size: 46px 46px;
```

Chuyển thành `TilePatternPainter extends CustomPainter`: vẽ lặp ô 46×46 (hoặc 22×22 cho biến thể dải phân mục, cao 14px, chỉ 3 vòng cung), mỗi ô vẽ 4 cung tròn góc (bán kính 12→14.5→15px, dùng `Paint()..shader = RadialGradient(...)` hoặc vẽ trực tiếp bằng `drawArc`/`drawCircle` với stop tương ứng) + 1 chấm tròn giữa ô (bán kính 0→2.5→3px). Repaint chỉ khi đổi theme (so sánh màu nền/màu chấm ở `shouldRepaint`).

**4 cách dùng duy nhất** (không thêm cách thứ 5):
1. Băng đầu trang (trang chủ, bảng điều hành) — thẻ trắng đè lên bằng `Transform.translate(offset: Offset(0, -46))` hoặc margin âm tương đương.
2. Dải phân mục cao 14px, biến thể nhỏ (ô 22×22, chỉ 3 vòng cung).
3. Thẻ hero (lương, phép) — thay nền teal đặc bằng hoạ văn.
4. Màn toàn nền (splash, quét khuôn mặt).

Không dán hoạ văn lên thẻ nội dung, nền toàn trang, hay phía sau chữ dài.

## 5. Typography (Source Sans 3, giữ nguyên scale)

| Bậc | Cỡ / weight | Letter-spacing | Dùng |
| --- | --- | --- | --- |
| Số chủ đạo | 38–42px / w800 | −1.6px | Giờ đã làm, lương thực nhận, số chờ duyệt |
| Tiêu đề màn | 19–21px / w800 | −.4px | Tên màn hình |
| Tiêu đề mục | 15px / w800 | −.2px | Đầu mỗi khối |
| Nhãn chữ hoa | 10–11px / w800 | 1.2–1.8px | Nhãn trên số, nhãn trong băng hoạ văn |
| Nội dung | 13–13.5px / w600–700 | — | Hàng danh sách |
| Phụ | 11–12px / w600–700, màu `textSecondary` | — | Thời gian, mô tả, caption |

Mọi số liệu (giờ, tiền, ngày, mã NV, %) dùng `FontFeature.tabularFigures()` trong `TextStyle.fontFeatures`. Không dùng weight 900. Không dùng cỡ chữ < 10px.

## 6. Hình khối & khoảng cách

- Bán kính: thẻ lớn 20–22px · thẻ nhỏ 15–16px · nút 13–17px · nhãn trạng thái 8px · nút tròn chức năng/avatar 50%.
- Viền: 1px `border`; 1.5px khi cần nhấn (thẻ được chọn, dải chờ duyệt). Thẻ cảnh báo: viền trái 4px theo mức độ.
- Bóng: không dùng, trừ thẻ "số dư" đè lên băng hoạ văn — `BoxShadow(color: Color(0x1A0F172A), blurRadius: 24, offset: Offset(0, 8))`.
- Lề ngang màn hình: 16–18px. Khoảng cách giữa thẻ: 9–11px. Giữa khối: 20–22px.
- Chiều cao: CTA chính 54–60px · nút phụ 44–52px · hàng danh sách tối thiểu 44px · nút tròn chức năng 52px · bottom nav 84px.

## 7. Icon mapping — Lucide → Material Symbols

Cần rà soát khi implement từng màn (danh sách dưới là các icon xuất hiện rõ trong mô tả DESIGN.md, bổ sung dần khi build thêm màn):

| Ngữ cảnh | Lucide (gốc) | Material Symbols (dùng) |
| --- | --- | --- |
| Check-in/chấm công | `clock` / `fingerprint` | `schedule` / `fingerprint` |
| Thông báo | `bell` | `notifications` |
| Nghỉ phép | `calendar-days` | `event_available` |
| Tăng ca | `timer` | `timer` |
| Lương | `wallet` / `banknote` | `account_balance_wallet` |
| Phê duyệt | `check-circle` / `x-circle` | `check_circle` / `cancel` |
| Hồ sơ cá nhân | `user` | `person` |
| Cài đặt | `settings` | `settings` |
| Tuyển dụng nội bộ | `briefcase` | `work` |
| Camera/quét mặt | `scan-face` | `face` (hoặc `face_retouching_natural` nếu cần biểu tượng quét) |
| Chevron điều hướng | `chevron-right` | `chevron_right` |
| Mắt ẩn/hiện lương | `eye` / `eye-off` | `visibility` / `visibility_off` |

Icon set: nét 1.9–2.2 tương đương variant `Outlined` của Material Symbols, cỡ 16–21px. Không dùng icon đổ màu (filled/2-tone) trừ khi trạng thái active cần nhấn mạnh (dùng `FILL` axis = 1 của variable font).

## 8. Component spec (giữ nguyên từ DESIGN.md)

- **Băng đầu trang**: hoạ văn + avatar vuông bo 13px màu kem + lời chào + ngày/địa điểm + nút thông báo trong ô `rgba(255,248,236,.18)`, chấm amber khi chưa đọc.
- **Thẻ số dư**: thẻ trắng đè lên băng. Trái: nhãn chữ hoa + số chủ đạo + ca làm. Phải: vòng tiến độ ca 80px (nền `cardSecondary`, nét amber 9px, đầu tròn, % ở giữa). Chân thẻ: giờ vào, giờ ra, CTA chấm công.
- **Hàng chức năng tròn**: 5 nút — 4 chức năng hay dùng (nền trắng, viền, icon teal) + nút "Tất cả" (nền `tileDark`, icon kem). Badge đỏ tròn 18px góc khi có việc cần xử lý.
- **Thẻ nội dung**: trắng, viền, bo 16–18px, padding 13–16px. Trái: nhãn chữ hoa + số. Phải: chevron nếu bấm được.
- **Nhãn trạng thái**: chữ 10.5px/w800, padding 5×9px, bo 8px, nền tint 14%, chữ màu mực đậm tương ứng.
- **Vòng/donut**: vòng tiến độ ca — 1 nét amber trên nền xám (`CustomPaint` + `drawArc`). Donut tổng hợp tháng — 4 cung màu trạng thái (`stroke-dasharray` tương đương `drawArc` nhiều đoạn), số ở giữa.
- **Timeline duyệt**: cột dọc 20px, chấm tròn 18px (xanh+tick cho bước xong, amber đặc cho bước đang chờ), nối vạch 2px. Bên phải: tên bước, người duyệt, mốc thời gian.
- **Bottom sheet**: overlay `rgba(17,24,39,.5)`, tấm trắng bo 26px trên, tay cầm 40×4px, animation trượt lên (`showModalBottomSheet` + `shape`).
- **Toast**: dải teal đặc, chữ trắng, đặt trên bottom nav, tự tắt sau 2.6s.
- **Bottom nav**: 5 tab, nền thẻ, viền trên, tab chọn có gạch 26×3px teal phía trên icon. Nhãn tab 1 và 3 đổi theo vai trò (xem mục 9).

## 9. Cấu trúc thông tin & điều hướng

Bottom nav mặc định (NV): **Trang chủ · Chấm công · Yêu cầu · Lương · Cá nhân**

Theo vai trò:
| Tab | NV | QL | BGĐ |
| --- | --- | --- | --- |
| 1 | Trang chủ | Trang chủ (+ dải chờ duyệt) | **Điều hành** (Bảng điều hành) |
| 3 | Yêu cầu | Yêu cầu (badge) | **Phê duyệt cuối** (badge số đơn) |

Trang chủ theo thứ tự: băng hoạ văn → thẻ "số dư" + CTA chấm công → dải chờ duyệt (nếu QL) → hàng chức năng tròn → dải phân mục → ngày công/phép/tăng ca/muộn → lương tháng (mặc định che) → cập nhật mới.

"Tất cả dịch vụ" chia 4 nhóm: **Chấm công & thời gian** / **Đơn từ** / **Lương & thưởng** / **Nghề nghiệp & hồ sơ** — xem bảng đầy đủ trong DESIGN.md mục 7.

**Lương ở trang chủ mặc định che** (`•••••••• ₫`) với nút mắt để mở — quyết định về quyền riêng tư nơi công cộng, giữ nguyên khi implement.

## 10. Trạng thái bắt buộc thiết kế cho mỗi chức năng chính

mặc định · đang tải (skeleton đúng layout thật) · rỗng (giải thích khi nào có nội dung) · thành công · lỗi (luôn có đường thoát, vd "Liên hệ HR").

Chấm công có 3 trạng thái đổi cả số liệu/nhãn/CTA:

| Trạng thái | Giờ đã làm | Vòng | CTA |
| --- | --- | --- | --- |
| Chưa vào | 0h 00m | 0% | `CHẤM CÔNG VÀO` (amber) |
| Đang làm | 6h 12m | 69% | `CHẤM CÔNG RA` (amber) |
| Xong ca | 8h 34m | 100% | `ĐÃ KẾT THÚC` (nền xám) |

Trạng thái yêu cầu (đơn từ): Chờ duyệt · Đã duyệt · Từ chối · Đã huỷ · Cần bổ sung.

## 11. Viết nội dung (copywriting)

Tiếng Việt tự nhiên, không dịch máy, không thuật ngữ kỹ thuật/kế toán. Nói việc, không nói hệ thống.

- Tốt: "Chưa có giờ ra. Ngày này bị tính thiếu công cho đến khi được sửa."
- Không: "Lỗi dữ liệu chấm công (mã 422)."

Lỗi luôn có đường thoát. Thành công luôn nói rõ việc gì đã xảy ra và ai xử lý tiếp theo. Áp dụng cho toàn bộ chuỗi ARB tiếng Việt trong `lib/l10n/app_vi.arb`.

## 12. Dữ liệu mẫu (dùng cho mock/preview UI trong lúc backend chưa sẵn sàng)

Giữ nguyên bộ nhân vật xuyên suốt từ DESIGN.md mục 15 khi tạo mock data/fixture cho test hoặc Storybook-style preview:

- Nguyễn Minh Tuấn · NV-04821 — Nhân viên chính, Giám sát cửa hàng.
- Lê Thu Hà — Quản lý trực tiếp của Tuấn.
- Lê Minh Quân — Duyệt bước 1 (Giám đốc Nhân sự, timeline).
- Phạm Thu Trang — HR xác nhận bước 2.
- Mốc thời gian mẫu: Thứ Tư 16/09/2026, ca 08:00–17:00, vào lúc 07:56. Lương thực nhận 25.500.000 ₫, thưởng KPI Q3 2.500.000 ₫. Phép năm 12 ngày, còn 6. Ngày 15/09 thiếu giờ ra (sợi chỉ xuyên suốt log/lịch/thông báo/màn sửa công).
