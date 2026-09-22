# Ứng dụng Nhân sự · Hướng thiết kế Gạch bông

Tài liệu tổng hợp cho bộ mockup HRM nhân viên. Mọi màn hình mới phải theo tài liệu này.

---

## 0. Tổng quan

| | |
| --- | --- |
| Sản phẩm | Ứng dụng nhân sự (HRM) trên điện thoại, hướng nhân viên |
| Người dùng | Nhân viên · Quản lý trực tiếp · Ban Giám đốc |
| Hướng thiết kế | **Gạch bông (Saigon tile)** — chốt ngày 16/09/2026 |
| Khung | 390 × 844 px · chạy đúng ở 375×812, 393×852, 430×932 |
| Số màn hình | 29 |
| Ngôn ngữ | Tiếng Việt và tiếng Anh, chuyển qua công tắc |
| Giao diện | Sáng và tối |

Bảng màu teal/amber trong tài liệu này là lựa chọn đã chốt của dự án, thay cho design system mặc định.

### Các file

| File | Vai trò |
| --- | --- |
| `Phone.dc.html` | Toàn bộ 29 màn hình, có state và điều hướng thật. Nhận 5 prop: `screen`, `lang`, `theme`, `role`, `att` |
| `HRM Employee App.dc.html` | Trang trình bày: một điện thoại tương tác + bảng 29 màn hình, kèm 4 công tắc |
| `HRM Employee App-print.dc.html` | Bản in PDF: bìa + các trang 2×2 màn hình. **Đang là 26 màn cũ, cần dựng lại** |
| `DESIGN.md` | Tài liệu này |
| `Style Directions.dc.html` | 6 hướng style đã khám phá (vòng 1 và vòng 2). Giữ để tham khảo |

---

## 1. Tinh thần thiết kế

Cấu trúc như một app ngân hàng: **một con số chủ đạo** ở trên cùng (giờ đã làm, đóng vai "số dư"), **hàng chức năng hay dùng nổi ra ngoài** dưới dạng nút tròn, phần còn lại nằm sau một lần bấm "Tất cả dịch vụ". Nhân viên mở app là thấy ngay việc cần làm, không phải đi tìm.

Chữ ký riêng nằm ở **mảng hoa văn gạch bông** — hoạ tiết gạch bông nhà phố Sài Gòn, vẽ bằng CSS gradient (không dùng ảnh), đặt ở đầu trang và làm dải phân mục. Đây là thứ khiến app không lẫn với bất kỳ HRM nào khác, trong khi phần nội dung vẫn phẳng, sạch và dễ đọc.

Ba điều không đánh đổi: **đọc trong 3 giây · một CTA mỗi màn · chạm được bằng một tay.**

Nhân viên mở app phải trả lời được ngay: hôm nay làm ở đâu, đã chấm công chưa, làm được mấy giờ, cần gửi gì không, còn mấy ngày phép, lương bao nhiêu, có thông báo gì.

---

## 2. Màu

Bảng màu gốc từ brief, có một điều chỉnh: teal đầu trang hạ một bậc để chữ kem trên hoa văn đạt tương phản.

### Sáng

| Vai trò | Mã | Dùng ở đâu |
| --- | --- | --- |
| Teal đậm (hoa văn) | `#0A544E` | Nền băng hoa văn, dải phân mục, nút tròn "Tất cả" |
| Teal chính | `#0F766E` | Mực, icon, số liệu nhấn, viền nút phụ, tab đang chọn |
| Teal nhạt | `#14B8A6` | Trạng thái phụ, link hover |
| Amber CTA | `#F59E0B` | **Chỉ** nút hành động chính, viền, nền tô nhạt, vòng tiến độ ca |
| Amber mực | `#B45309` | Chữ và số màu amber trên nền trắng (`#92400E` khi trên nền tô nhạt) |
| Xanh mực | `#047857` | Chữ và số màu xanh thành công |
| Đỏ mực | `#B91C1C` | Chữ và số màu đỏ |
| Kem | `#FFF8EC` | Chữ và icon trên nền hoa văn |
| Nền | `#F6F4EF` | Nền trang (giấy ấm, không phải xám xanh) |
| Thẻ | `#FFFFFF` | Nền thẻ |
| Thẻ phụ | `#F0EDE5` | Nền ô icon, nền khối trích dẫn |
| Viền | `#E3DFD6` | Viền thẻ, đường kẻ hàng |
| Chữ chính | `#111827` | |
| Chữ phụ | `#5B6572` | |
| Thành công | `#10B981` | Chỉ trạng thái thành công |
| Cảnh báo | `#F59E0B` | Chỉ cảnh báo |
| Lỗi | `#EF4444` | Chỉ lỗi và hành động phá huỷ |

### Tối

Nền `#111827` · thẻ `#1F2937` · thẻ phụ `#263243` · teal `#2DD4BF` · teal nhạt `#5EEAD4` · amber `#FBBF24` · chữ `#F8FAFC` · chữ phụ `#94A3B8` · viền `#374151` · thành công `#34D399` · lỗi `#F87171`. Băng hoa văn giữ `#0A544E`, hoa văn đổi sang `rgba(45,212,191,.16)`.

### Luật màu

- Amber đặc chỉ xuất hiện **một lần** trên mỗi màn hình. Vòng tiến độ ca được tính là nét, không phải nền.
- Xanh lá chỉ cho thành công, đỏ chỉ cho lỗi. Không dùng làm màu trang trí.
- Nền tô màu luôn là `color-mix(in srgb, <màu> 14%, transparent)` — không tự pha hex mới.
- Tách màu **mực** khỏi màu **nét**: amber, xanh và đỏ gốc dùng cho viền, nền tô, thanh tỷ lệ và nút; chữ hoặc số cùng màu phải dùng bậc mực đậm (`#B45309` / `#047857` / `#B91C1C`) mới đạt 4.5:1 — amber trên nền tô nhạt cần đậm thêm một bậc (`#92400E`). Ở chế độ tối các màu gốc đã đủ tương phản nên mực trùng với nét.
- Chữ trên nền hoa văn phải là kem đặc `#FFF8EC`, không dùng opacity.

---

## 3. Hoa văn gạch bông

Một công thức duy nhất, dùng lại ở mọi nơi:

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

Dải phân mục dùng biến thể nhỏ hơn: ô `22px 22px`, cao 14px, chỉ ba vòng cung.

Bốn cách dùng, không có cách thứ năm:

1. **Băng đầu trang** — trang chủ và bảng điều hành. Thẻ trắng đè lên bằng `margin-top:-46px` (hoặc `-38px`).
2. **Dải phân mục** — cao 14px, chia khối lớn trên trang chủ.
3. **Thẻ hero** — lương, phép: thay nền teal đặc bằng hoa văn.
4. **Màn toàn nền** — splash, quét khuôn mặt.

Không dán hoa văn lên thẻ nội dung, nền toàn trang, hay phía sau chữ dài.

Ở màn có hoa văn chạy lên đến đỉnh (trang chủ, bảng điều hành, splash, quét mặt), chữ thanh trạng thái phải chuyển sang kem.

---

## 4. Chữ

Manrope, các nét 500 / 600 / 700 / 800.

| Bậc | Cỡ / nét | Dùng |
| --- | --- | --- |
| Số chủ đạo | 38–42px / 800, letter-spacing −1.6px | Giờ đã làm, lương thực nhận, số chờ duyệt |
| Tiêu đề màn | 19–21px / 800, −.4px | Tên màn hình |
| Tiêu đề mục | 15px / 800, −.2px | Đầu mỗi khối |
| Nhãn chữ hoa | 10–11px / 800, letter-spacing 1.2–1.8px | Nhãn trên số, nhãn trong băng hoa văn |
| Nội dung | 13–13.5px / 700 hoặc 600 | Hàng danh sách |
| Phụ | 11–12px / 600–700, màu chữ phụ | Thời gian, mô tả, caption |

Mọi số liệu (giờ, tiền, ngày, mã nhân viên, phần trăm) đặt `font-variant-numeric: tabular-nums`. Không dùng nét 900, không dùng chữ nhỏ hơn 10px.

---

## 5. Hình khối và khoảng cách

- **Bán kính**: thẻ lớn 20–22px · thẻ nhỏ 15–16px · nút 13–17px · nhãn trạng thái 8px · nút tròn chức năng và avatar 50%.
- **Viền** 1px `#E3DFD6`; 1.5px khi cần nhấn (thẻ được chọn, dải chờ duyệt). Thẻ cảnh báo có viền trái 4px màu theo mức.
- **Bóng**: không dùng, trừ thẻ "số dư" đè lên băng hoa văn — `0 8px 24px rgba(15,23,42,.1)`.
- **Lề ngang** màn hình 16–18px. Khoảng cách giữa thẻ 9–11px, giữa khối 20–22px.
- **Chiều cao**: CTA chính 54–60px · nút phụ 44–52px · hàng danh sách tối thiểu 44px · nút tròn chức năng 52px · bottom nav 84px.

---

## 6. Thành phần

**Băng đầu trang** — hoa văn + avatar vuông bo 13px màu kem + lời chào + ngày/địa điểm + nút thông báo trong ô `rgba(255,248,236,.18)` có chấm amber khi chưa đọc.

**Thẻ số dư** — thẻ trắng đè lên băng. Bên trái: nhãn chữ hoa, số chủ đạo, ca làm. Bên phải: vòng tiến độ ca 80px (nền thẻ phụ, nét amber 9px, đầu tròn, phần trăm ở giữa). Chân thẻ: giờ vào, giờ ra, CTA chấm công.

**Hàng chức năng tròn** — 5 nút: 4 chức năng hay dùng (nền trắng, viền, icon teal) + nút "Tất cả" (nền teal đậm, icon kem). Badge đỏ tròn 18px ở góc khi có việc cần xử lý.

**Thẻ nội dung** — trắng, viền, bo 16–18px, padding 13–16px. Trái: nhãn chữ hoa + số. Phải: mũi chevron nếu bấm được.

**Nhãn trạng thái** — chữ 10.5px/800, padding 5×9px, bo 8px, nền `color-mix` 14%, chữ màu mực đậm.

**Vòng và donut** — vòng tiến độ ca dùng một nét amber trên nền xám. Donut tổng hợp tháng dùng 4 cung màu trạng thái, `stroke-dasharray` + `stroke-dashoffset`, số ở giữa.

**Timeline duyệt** — cột dọc 20px: chấm tròn 18px (xanh + dấu tích cho bước đã xong, amber đặc cho bước đang chờ) nối bằng vạch 2px. Bên phải là tên bước, người duyệt và mốc thời gian.

**Bottom sheet** — nền phủ `rgba(17,24,39,.5)`, tấm trắng bo 26px trên, tay cầm 40×4px, animation trượt lên.

**Toast** — dải teal đặc, chữ trắng, đặt trên bottom nav, tự tắt sau 2.6 giây.

**Bottom nav** — 5 tab, nền thẻ, viền trên, tab đang chọn có gạch 26×3px màu teal phía trên icon. Nhãn tab 1 và 3 đổi theo vai trò.

**Icon** — Lucide, nét 1.9–2.2, cỡ 16–21px. Không dùng icon đổ màu.

---

## 7. Cấu trúc thông tin

Bottom nav: **Trang chủ · Chấm công · Yêu cầu · Lương · Cá nhân**

Trang chủ theo thứ tự: băng hoa văn → thẻ "số dư" + CTA chấm công → dải chờ duyệt (nếu là quản lý) → hàng chức năng tròn → dải phân mục → ngày công/phép/tăng ca/muộn → lương tháng (mặc định che) → cập nhật mới.

Mọi chức năng còn lại nằm ở **Tất cả dịch vụ**, chia 4 nhóm:

| Nhóm | Gồm |
| --- | --- |
| Chấm công & thời gian | Chấm công vào/ra · Lịch công tháng · Nhật ký từng ngày · Ngày lễ |
| Đơn từ | Xin nghỉ phép · Đăng ký tăng ca · Sửa công · Theo dõi yêu cầu |
| Lương & thưởng | Bảng lương tháng · Phiếu lương · Thưởng & ghi nhận · Phụ cấp |
| Nghề nghiệp & hồ sơ | Tuyển dụng nội bộ · Hồ sơ cá nhân · Cài đặt · Phê duyệt |

Lương ở trang chủ **mặc định che** (`•••••••• ₫`) với nút mắt để mở. Dòng chi tiết thưởng cũng ẩn theo. Đây là quyết định về quyền riêng tư khi dùng điện thoại ở nơi công cộng.

---

## 8. Ba cấp vai trò

Không làm app riêng cho từng cấp. Một app, ba lớp quyền.

**Nhân viên** — mặc định. Chấm công, đơn từ, lương, hồ sơ.

**Quản lý** — trang chủ thêm dải chờ duyệt ngay dưới thẻ giờ làm, tab Yêu cầu có badge, và có màn Trung tâm phê duyệt cho duyệt/từ chối ngay trên thẻ. Đây là cấp duyệt thứ nhất.

**Ban Giám đốc (C-level)** — cấp cuối của chu trình. Tab 1 đổi nhãn thành "Điều hành" và trỏ sang **Bảng điều hành**; tab 3 trỏ sang **Phê duyệt cuối** với badge số đơn.

### Chu trình duyệt

```
Nhân viên gửi → Quản lý trực tiếp → HR xác nhận → Giám đốc phê duyệt
```

Thanh tiến độ trên thẻ yêu cầu luôn có **4 đoạn**. Ở màn Phê duyệt cuối, chuỗi này hiện dạng timeline dọc với người duyệt và mốc thời gian từng bước, để giám đốc thấy ai đã xem trước mình.

### Ngôn ngữ theo cấp

Màn Phê duyệt cuối nói bằng ngôn ngữ cấp quyết định: mỗi thẻ nêu **tác động** (chi phí dự kiến, tổng giờ tăng ca, ngân sách năm, số ngày vắng) và trạng thái ngân sách, không chỉ lý do cá nhân. Có nút "Duyệt tất cả" cho các yêu cầu đã đủ ý kiến hai cấp dưới.

### Ngưỡng cần cấp cuối

Bốn loại việc bắt buộc qua Ban Giám đốc: công tác có chi phí · tăng ca vượt dự toán · thêm biên chế ngoài kế hoạch · nghỉ không lương trên 10 ngày.

---

## 9. Ba mức cảnh báo (màn 28)

| Mức | Nét | Mực | Dùng khi |
| --- | --- | --- | --- |
| Khẩn cấp | `#EF4444` | `#B91C1C` | Vi phạm luật, quá hạn SLA |
| Cảnh báo | `#F59E0B` | `#92400E` | Lệch chỉ tiêu, xu hướng xấu |
| Lưu ý | `#E3DFD6` | `#5B6572` | Việc cần theo dõi, chưa gấp |

Mỗi thẻ cảnh báo gồm: nhãn mức, loại rủi ro, số liệu, diễn giải một dòng, chip chi nhánh, chip thời điểm phát sinh, và nút "Giao Phòng Nhân sự xử lý". Bảng điều hành chỉ giữ hai cảnh báo khẩn cấp nhất, còn lại nằm sau nút "Xem tất cả cảnh báo".

---

## 10. Ủy quyền phê duyệt (màn 29)

Form bốn phần: người được ủy quyền (chọn một) → khoảng thời gian (tự tính số ngày) → phạm vi loại đơn (Toàn bộ, hoặc Chọn lọc với công tắc từng loại) → hạn mức giá trị tối đa.

Nguyên tắc: **đơn vượt hạn mức vẫn chờ giám đốc**, không chuyển cho người được ủy quyền. Câu này phải hiện ngay dưới phần hạn mức.

Dưới form là ủy quyền đang chạy (viền xanh, nút thu hồi) và nhật ký các lần đã qua với số đơn đã duyệt và trạng thái hoàn tất/thu hồi sớm.

---

## 11. Trạng thái

Mỗi chức năng quan trọng có: mặc định · đang tải (skeleton đúng layout thật) · rỗng (giải thích khi nào sẽ có nội dung) · thành công · lỗi.

Chấm công có 3 trạng thái đổi cả số liệu, nhãn và CTA:

| Trạng thái | Giờ đã làm | Vòng | CTA |
| --- | --- | --- | --- |
| Chưa vào | 0h 00m | 0% | `CHẤM CÔNG VÀO` amber |
| Đang làm | 6h 12m | 69% | `CHẤM CÔNG RA` amber |
| Xong ca | 8h 34m | 100% | `ĐÃ KẾT THÚC`, nền xám |

Trạng thái yêu cầu: Chờ duyệt · Đã duyệt · Từ chối · Đã huỷ · Cần bổ sung.

---

## 12. Chấm công bằng khuôn mặt

Ba bước, mỗi bước đổi màu viền khung và chữ hướng dẫn:

1. **Đưa mặt vào khung** — viền kem. "Giữ điện thoại ngang mắt, ở nơi đủ sáng."
2. **Đang nhận diện** — viền amber, vạch quét chạy. "Giữ yên khoảng một giây."
3. **Đã xác thực** — viền xanh, dấu tích. Tên và mã nhân viên.

Sau bước 3 tự quay lại màn trước và ghi nhận giờ kèm toast. Dưới cùng: dải xác thực vị trí và **đường thoát thủ công** cho trường hợp camera lỗi hay đeo khẩu trang. Không bao giờ chặn nhân viên chấm công vì lý do kỹ thuật.

---

## 13. Viết nội dung

Tiếng Việt tự nhiên, không dịch máy, không thuật ngữ kế toán. Nói việc, không nói hệ thống.

- Tốt: "Chưa có giờ ra. Ngày này bị tính thiếu công cho đến khi được sửa."
- Không: "Lỗi dữ liệu chấm công (mã 422)."

Lỗi luôn có một đường thoát ("Liên hệ HR"). Thành công luôn nói việc gì đã xảy ra và ai sẽ xử lý tiếp. Caption dưới màn hình trong bảng trình bày: một dòng, nêu quyết định thiết kế chứ không mô tả lại nội dung màn.

---

## 14. Danh sách 29 màn hình

| # | Màn | Vai trò | Ghi chú |
| --- | --- | --- | --- |
| 01 | Splash | — | Nền hoa văn toàn màn |
| 02 | Đăng nhập | — | Mã nhân viên + Face ID |
| 03 | Trang chủ | Nhân viên | Băng hoa văn, thẻ số dư, 5 nút tròn |
| 04 | Trang chủ · quản lý | Quản lý | Thêm dải chờ duyệt |
| 05 | Tất cả dịch vụ | Mọi cấp | Lưới icon 4 nhóm |
| 06 | Chấm công | Nhân viên | Trạng thái lớn + donut tháng + nhật ký ngày |
| 07 | Quét khuôn mặt | Nhân viên | Ba bước, có đường thoát |
| 08 | Lịch công tháng | Nhân viên | 5 màu trạng thái |
| 09 | Ngày lễ | Nhân viên | Cả năm |
| 10 | Trung tâm yêu cầu | Nhân viên | Tab lọc + tiến độ 4 đoạn |
| 11 | Xin nghỉ phép | Nhân viên | Tự tính ngày, cảnh báo trùng |
| 12 | Tăng ca | Nhân viên | Đăng ký + lịch sử |
| 13 | Sửa công | Nhân viên | 3 bước |
| 14 | Lương | Nhân viên | Thực nhận trước |
| 15 | Phiếu lương | Nhân viên | Thu nhập / khoản trừ, tải PDF |
| 16 | Thưởng | Nhân viên | Nêu vì sao được thưởng |
| 17 | Tuyển dụng nội bộ | Nhân viên | |
| 18 | Chi tiết vị trí | Nhân viên | CTA cố định dưới |
| 19 | Thông báo | Mọi cấp | Nhóm, chưa đọc, deep-link |
| 20 | Cá nhân | Mọi cấp | Nhóm danh sách |
| 21 | Phê duyệt (quản lý) | Quản lý | Duyệt trên thẻ |
| 22 | Bảng điều hành | BGĐ | Số toàn công ty + 2 cảnh báo |
| 23 | Phê duyệt cuối | BGĐ | Timeline + tác động ngân sách |
| 24 | Cài đặt | Mọi cấp | |
| 25 | Rỗng | — | |
| 26 | Đang tải | — | Skeleton |
| 27 | Lỗi | — | |
| 28 | Cảnh báo Rủi ro & Tuân thủ | BGĐ | 3 mức ưu tiên |
| 29 | Trung tâm Ủy quyền | BGĐ | Form + đang chạy + nhật ký |

Số thứ tự trong bảng trình bày có thể lệch so với bảng này khi thêm màn mới — bảng trình bày đánh số theo thứ tự hiển thị.

---

## 15. Dữ liệu mẫu

Giữ nhất quán một bộ nhân vật xuyên suốt, để mọi màn hình kể cùng một câu chuyện.

| Người | Vai trò |
| --- | --- |
| Nguyễn Minh Tuấn · NV-04821 | Nhân viên chính, Giám sát cửa hàng, Vận hành |
| Lê Thu Hà | Quản lý trực tiếp của Tuấn · cũng là Giám đốc Vận hành ở góc nhìn BGĐ |
| Lê Minh Quân | Quản lý duyệt bước 1 trong timeline · Giám đốc Nhân sự |
| Phạm Thu Trang | HR xác nhận bước 2 · Trưởng phòng Nhân sự |
| Trần Văn Nam, Phạm Thu Hương, Lý Quốc Dũng, Võ Thị Ánh | Nhân viên trong hàng chờ duyệt |

Mốc thời gian: **Thứ Tư, 16 tháng 9 năm 2026**. Ca 08:00–17:00, vào lúc 07:56. Lương thực nhận 25.500.000 ₫, thưởng KPI quý 3 là 2.500.000 ₫. Phép năm 12 ngày, còn 6. Ngày 15/09 thiếu giờ ra — đây là sợi chỉ xuyên suốt, xuất hiện ở nhật ký ngày, lịch tháng, thông báo, và màn sửa công.

---

## 16. Khi thêm màn hình mới

1. Thêm nhánh `<sc-if>` trong `Phone.dc.html`, đặt trước khối FACE SCAN.
2. Thêm cờ `isXxx:s==='xxx'` và hàm `goXxx` vào `renderVals()`.
3. Thêm tên màn vào mảng `showNav` nếu màn đó cần bottom nav.
4. Thêm chuỗi vào khối `L2`–`L5` cho cả hai ngôn ngữ.
5. Thêm vào `options` của prop `screen` trong `data-props`.
6. Thêm một dòng vào mảng `B` của `HRM Employee App.dc.html` (cả VI và EN) kèm caption một dòng, và cập nhật số màn ở `boardLabel` và `subtitle`.
7. Nếu màn chỉ dành cho một cấp, thêm tên màn vào danh sách gán `role` trong hàm dựng `board`.

Mọi màu lấy từ biến `t.*` trong logic hoặc `var(--*)` trong template — không viết hex trực tiếp, trừ `#0A544E` và `#FFF8EC` của hoa văn.

---

## 17. Việc còn lại

- Bản in PDF (`HRM Employee App-print.dc.html`) đang là 26 màn cũ, chưa có quét khuôn mặt, hai màn BGĐ mới, và các màn ủy quyền.
- Các màn P2 chưa làm: KPI, đào tạo, phúc lợi, phát triển nghề nghiệp, tài liệu công ty, khảo sát, ghi nhận nội bộ.
- Avatar đang là chữ viết tắt vì chưa có ảnh thật.
- Đầu các màn con hiện chỉ có tiêu đề trơn; có thể đưa hoa văn vào để nhất quán hơn với trang chủ.
