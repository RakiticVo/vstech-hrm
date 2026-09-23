# BÁO CÁO NGHIỆP VỤ & KỸ THUẬT CHI TIẾT
# 04 CHỨC NĂNG BỔ SUNG & MỞ RỘNG GIAI ĐOẠN P0 (MVP)
## Nền Tảng Quản Trị Nhân Lực VSTech HRM Mobile — Khối Nhà Máy & Sản Xuất

---

| Thuộc tính | Chi tiết |
| :--- | :--- |
| **Cơ quan ban hành** | Ban Dự Án Nền Tảng Chuyển Đổi Số VSTech HRM |
| **Kính gửi** | Hội Đồng Quản Trị & Ban Giám Đốc (BGD) |
| **Tài liệu căn cứ** | 1. `DANH_SACH_CHUC_NANG_HRM_THEO_UU_TIEN_v2_BGD.pdf`<br>2. `BAO_CAO_BO_SUNG_CHUC_NANG_P0_HRM_MOBILE_CHI_TIET.md` |
| **Trọng tâm báo cáo** | **Tập trung chuyên sâu vào đúng 04 chức năng bổ sung/mở rộng trong giai đoạn P0** |
| **Môi trường ứng dụng** | Nhà máy, Xí nghiệp sản xuất quy mô **~3.000 công nhân viên** |
| **Nền tảng** | Flutter Mobile (Android / iOS) & Web Quản Trị (Admin Portal) |
| **Phiên bản** | 2.1 - Focused Executive Edition |
| **Ngày lập báo cáo** | 23/09/2026 |

---

## MỤC LỤC TỔNG THỂ

1. [TỔNG QUAN & CĂN CỨ BỔ SUNG 04 CHỨC NĂNG VÀO P0](#1-tổng-quan--căn-cứ-bổ-sung-04-chức-năng-vào-p0)
2. [CHỨC NĂNG 1: CỘNG ĐỒNG NỘI BỘ CHÍNH THỨC TOÀN DOANH NGHIỆP](#2-chức-năng-1-cộng-đồng-nội-bộ-chính-thức-toàn-doanh-nghiệp)
3. [CHỨC NĂNG 2: QUẢN LÝ VÒNG ĐỜI & KÝ HỢP ĐỒNG ĐIỆN TỬ SỐ HÓA](#3-chức-năng-2-quản-lý-vòng-đời--ký-hợp-đồng-điện-tử-số-hóa)
4. [CHỨC NĂNG 3: CẢNH BÁO & HÀNG ĐỢI CHẤM CÔNG NGOẠI TUYẾN CHƯA GỬI](#4-chức-năng-3-cảnh-báo--hàng-đợi-chấm-công-ngoại-tuyến-chưa-gửi)
5. [CHỨC NĂNG 4: TỔNG HỢP CÔNG THEO CA TRONG TUẦN CỦA TỔ / NHÓM](#5-chức-năng-4-tổng-hợp-công-theo-ca-trong-tuần-của-tổ--nhóm)
6. [MA TRẬN PHÂN QUYỀN (RBAC) DÀNH RIÊNG CHO 04 PHÂN HỆ BỔ SUNG](#6-ma-trận-phân-quyền-rbac-dành-riêng-cho-04-phân-hệ-bổ-sung)
7. [MA TRẬN RỦI RO VẬN HÀNH & GIẢI PHÁP KIỂM SOÁT KỸ THUẬT](#7-ma-trận-rủi-ro-vận-hành--giải-pháp-kiểm-soát-kỹ-thuật)
8. [KẾ HOẠCH TRIỂN KHAI & TIÊU CHÍ NGHIỆM THU (DEFINITION OF DONE)](#8-kế-hoạch-triển-khai--tiêu-chí-nghiệm-thu-definition-of-done)

---

## 1. TỔNG QUAN & CĂN CỨ BỔ SUNG 04 CHỨC NĂNG VÀO P0

### 1.1. Căn Cứ Điều Chỉnh Phạm Vi
Trong tài liệu danh mục 71 chức năng v2 ban đầu trình Ban Giám Đốc:
- Nhóm P0 được định hình gồm 25 tính năng tác nghiệp cá nhân tối thiểu.
- Tuy nhiên, qua khảo sát thực tế tại các cụm nhà máy và xí nghiệp có quy mô **~3.000 lao động**, môi trường sản xuất công nghiệp bộc lộ **4 bài toán vận hành sống còn** mà danh mục P0 ban đầu chưa đáp ứng được.

Ban Dự án quyết định **tập trung bổ sung và nâng cấp đúng 04 chức năng** vào danh mục P0 cốt lõi:

```
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                     04 CHỨC NĂNG BỔ SUNG & MỞ RỘNG TRỌNG TÂM TRONG P0                           │
├────────────────────────────────┬───────────────────────────┬───────────────────────────────────┤
│ Tên chức năng bổ sung          │ Nguồn gốc trong danh mục  │ Lý do đưa vào P0                  │
├────────────────────────────────┼───────────────────────────┼───────────────────────────────────┤
│ 1. Cộng đồng nội bộ chính thức │ Chuyển từ P1 (STT #57)    │ Kênh phát ngôn chính thống, xóa bỏ│
│    toàn doanh nghiệp           │ xuống P0                  │ Zalo tự phát, an toàn thông tin.  │
├────────────────────────────────┼───────────────────────────┼───────────────────────────────────┤
│ 2. Quản lý vòng đời & Ký hợp   │ Nâng cấp từ P1 (STT #51)  │ Xử lý biến động 3.000 công nhân,  │
│    đồng điện tử số hóa         │ thành P0 độc lập          │ ký số di động, cắt giảm chi phí.  │
├────────────────────────────────┼───────────────────────────┼───────────────────────────────────┤
│ 3. Cảnh báo & Hàng đợi chấm    │ Mở rộng chiều sâu kỹ thuật│ Xưởng kim loại/tầng hầm mất mạng, │
│    công ngoại tuyến chưa gửi   │ từ P0 hiện hữu (STT #4)   │ cơ chế zero-data-loss, chống trừ  │
│                                │                           │ lương oan trước ngày khóa sổ công.│
├────────────────────────────────┼───────────────────────────┼───────────────────────────────────┤
│ 4. Tổng hợp công theo ca tuần  │ Rút gọn phạm vi P1        │ Vũ khí hiện trường cho Tổ trưởng, │
│    của tổ / nhóm               │ (STT #53 - Team Overview) │ nắm quân số 3 ca, kiểm soát chênh │
│                                │ đưa vào P0                │ lệch kế hoạch vs đi làm thực tế.  │
└────────────────────────────────┴───────────────────────────┴───────────────────────────────────┘
```

---

## 2. CHỨC NĂNG 1: CỘNG ĐỒNG NỘI BỘ CHÍNH THỨC TOÀN DOANH NGHIỆP
*(Chuyển từ P1 #57 xuống P0 — Nền tảng truyền thông kỷ luật số)*

### 2.1. Mục Tiêu Nghiệp Vụ
- Xóa bỏ triệt để các nhóm Zalo/Facebook tự phát trong xưởng sản xuất; ngăn ngừa rò rỉ hình ảnh dây chuyền, đơn giá sản phẩm và bí mật kinh doanh.
- Thiết lập kênh thông báo khẩn cấp (PCCC, bão lũ, sự cố kỹ thuật, lịch tăng ca bù) tiếp cận tức thời đến 100% trong số 3.000 công nhân.
- Lan tỏa chính sách thi đua, gương công nhân sản xuất giỏi, phong trào 5S và văn hóa doanh nghiệp.

### 2.2. Quy Tắc Nghiệp Vụ Cốt Lõi (Business Rules)
1. **Kiểm soát quyền đăng bài nghiêm ngặt**:
   - Công nhân thông thường (`EMPLOYEE`) **tuyệt đối không hiển thị nút tạo bài viết trên Mobile**.
   - Công nhân chỉ có quyền: **Xem bài viết, Thả cảm xúc (Reaction), Viết bình luận (Comment), và Báo cáo vi phạm (Report)**.
   - Quyền soạn bài, đăng bài, lên lịch phát hành thuộc về `HR_ADMIN`, Ban Giám Đốc và Quản lý được phân quyền.
2. **Cơ chế xác nhận bắt buộc "Tôi đã đọc" (Mandatory Read Acknowledgment)**:
   - Áp dụng cho các thông báo an toàn lao động, nội quy xưởng, điều chỉnh đơn giá sản phẩm (`is_read_ack_required = true`).
   - Công nhân bắt buộc phải cuộn đọc hết nội dung văn bản mới kích hoạt nút bấm: `[ Tôi đã đọc và hiểu rõ nội dung ]`.
   - Hệ thống tự động ghi nhận vết kiểm toán: `User ID`, `Post ID`, `Timestamp`.
   - Bảng điều khiển Web Admin hiển thị tỷ lệ đọc (%) thời gian thực theo từng phân xưởng và tổ sản xuất.
3. **Phân loại bài viết & Thứ tự ưu tiên trên Feed**:
   - **Bài viết khẩn cấp (Emergency)**: Luôn hiển thị vị trí số 1 trên Dashboard và đầu Feed, viền đỏ cảnh báo, bỏ qua chế độ im lặng (Quiet Hours) của điện thoại để gửi Push Notification.
   - **Bài viết ghim (Pinned)**: Tối đa 3 bài ghim nằm ngay dưới bài khẩn cấp.
   - **Bài bắt buộc đọc chưa xác nhận**: Nằm ở vị trí ưu tiên cao trong luồng bài viết thường cho đến khi công nhân xác nhận.
   - **Bài viết thường (News/Post)**: Xếp theo thứ tự thời gian mới nhất.
4. **Cơ chế bình luận đa cấp & Kiểm duyệt nội dung**:
   - Bình luận hỗ trợ thảo luận theo chuỗi (Threaded Comments) nhưng **giới hạn hiển thị 2 cấp thụt lề trên điện thoại** để tránh vỡ giao diện màn hình nhỏ. Các phản hồi sâu hơn hiển thị nhãn `@Tên người được trả lời`.
   - Bộ lọc tự động ẩn các bình luận chứa từ khóa phản cảm, kích động.
   - Khi có báo cáo vi phạm từ người dùng, HR/Admin có thể xóa mềm (Soft-delete) ngay trên Web. Nội dung gốc và lý do xóa được lưu vĩnh viễn trong Audit Log.

### 2.3. Ranh Giới Nghiệp Vụ Mobile App & Web Admin

```
┌────────────────────────────────────────────────────────┬────────────────────────────────────────────────────────┐
│                    TRÊN MOBILE APP                     │                    TRÊN WEB ADMIN                      │
├────────────────────────────────────────────────────────┼────────────────────────────────────────────────────────┤
│ • Lướt đọc bảng tin, bài viết kèm hình ảnh, video, PDF │ • Soạn thảo nội dung bằng trình soạn thảo Rich Text    │
│ • Tìm kiếm bài viết theo từ khóa, lọc theo chuyên mục  │ • Tải lên tệp đính kèm dung lượng lớn, video hướng dẫn │
│ • Thả biểu tượng cảm xúc (Like, Heart, Clap...)        │ • Lên lịch xuất bản tự động, thiết lập ngày hết hạn bài│
│ • Viết bình luận, phản hồi chuỗi, tag tên đồng nghiệp  │ • Bật cờ bài viết khẩn cấp hoặc bài viết bắt buộc đọc  │
│ • Bấm nút xác nhận "Tôi đã đọc" đối với thông báo an toàn│ • Kiểm duyệt nội dung: Ẩn/xóa bình luận, khóa bình luận│
│ • Báo cáo nội dung vi phạm hoặc sai lệch sự thật       │ • Xem báo cáo tỷ lệ công nhân đã đọc bài theo từng tổ  │
└────────────────────────────────────────────────────────┴────────────────────────────────────────────────────────┘
```

### 2.4. Tiêu Chí Nghiệm Thu (Acceptance Criteria)
- **COM-AC-001**: Tài khoản công nhân mở app tuyệt đối không thấy nút "Tạo bài viết". Mọi API tạo bài từ quyền `EMPLOYEE` đều bị máy chủ từ chối với mã lỗi 403 Forbidden.
- **COM-AC-002**: Bài viết khẩn cấp luôn nổi lên đầu trang và gửi push notification đến thiết bị kể cả khi thiết bị đang ở khung giờ hạn chế thông báo.
- **COM-AC-003**: Khi công nhân ấn "Tôi đã đọc", giao diện chuyển trạng thái "Đã xác nhận", không cho ấn lại và số liệu xác nhận trên Web Admin tăng tức thì.

---

## 3. CHỨC NĂNG 2: QUẢN LÝ VÒNG ĐỜI & KÝ HỢP ĐỒNG ĐIỆN TỬ SỐ HÓA
*(Nâng cấp từ P1 #51 thành P0 Độc Lập — Số hóa 100% hồ sơ pháp lý)*

### 3.1. Mục Tiêu Nghiệp Vụ
- Giải quyết bài toán biến động nhân sự lớn (15–25%/năm) của nhà máy 3.000 công nhân: Chấm dứt tình trạng in ấn, luân chuyển và lưu trữ hàng vạn văn bản giấy.
- Cho phép người lao động xem và ký số trực tiếp trên điện thoại: Hợp đồng thử việc, Hợp đồng lao động, Phụ lục lương, Thỏa thuận bảo mật (NDA), Cam kết an toàn lao động.

### 3.2. Quy Trình Vận Hành & Vòng Đời Hợp Đồng

```
 ┌────────────────────────────────────────────────────────────────┐
 │ 1. KHỞI TẠO: HR tạo hợp đồng từ file PDF/mẫu trên Web Admin    │
 └───────────────────────────────┬────────────────────────────────┘
                                 │
 ┌───────────────────────────────▼────────────────────────────────┐
 │ 2. PHÊ DUYỆT ĐA CẤP: Quản lý xưởng ➔ Ban Giám Đốc phê duyệt    │
 └───────────────────────────────┬────────────────────────────────┘
                                 │
 ┌───────────────────────────────▼────────────────────────────────┐
 │ 3. THÔNG BÁO: Gửi Push Notification đến điện thoại công nhân   │
 └───────────────────────────────┬────────────────────────────────┘
                                 │
 ┌───────────────────────────────▼────────────────────────────────┐
 │ 4. ĐỌC TÀI LIỆU: Bắt buộc cuộn đọc toàn bộ nội dung PDF        │
 └───────────────────────────────┬────────────────────────────────┘
                                 │
        ┌────────────────────────┴────────────────────────┐
        │                                                 │
 [Công nhân đồng ý]                             [Công nhân thắc mắc]
        │                                                 │
 ┌──────▼─────────────────────────┐             ┌─────────▼──────────────────────┐
 │ Xác thực Face ID / Mã PIN      │             │ Gửi Yêu Cầu Chỉnh Sửa / Từ Chối│
 └──────┬─────────────────────────┘             │ (Bắt buộc nhập lý do chi tiết) │
        │                                       └─────────┬──────────────────────┘
 ┌──────▼─────────────────────────┐                       │
 │ Vẽ nét chữ ký cảm ứng trên app │             ┌─────────▼──────────────────────┐
 └──────┬─────────────────────────┘             │ HR tiếp nhận & ra phiên bản mới│
        │                                       └────────────────────────────────┘
 ┌──────▼─────────────────────────────────────────────────────────┐
 │ 5. HOÀN TẤT & KHÓA BẤT BIẾN:                                   │
 │ • Đại diện doanh nghiệp ký số                                  │
 │ • Hệ thống đóng mã băm SHA-256 chống sửa đổi                   │
 │ • File xuất có Watermark: [Họ tên] - [MSNV] - [Thời điểm tải]  │
 └────────────────────────────────────────────────────────────────┘
```

### 3.3. Các Biện Pháp An Toàn Thông Tin Bắt Buộc
1. **Xác thực sinh trắc học trước khi mở và ký**:
   - Khi công nhân bấm vào xem hợp đồng, ứng dụng yêu cầu quét vân tay/Face ID hoặc nhập mã PIN bảo mật cá nhân.
   - Ngăn chặn tình trạng đồng nghiệp mượn điện thoại xem trộm bảng lương hoặc ký hộ.
2. **Chặn chụp ảnh màn hình (Anti-Screenshot Protection)**:
   - Trên Android: Bật cờ bảo mật hệ điều hành `FLAG_SECURE`, cấm hoàn toàn hành vi chụp màn hình hoặc quay video màn hình.
   - Trên iOS: Áp dụng cơ chế làm mờ/che phủ giao diện (Screen Obfuscation) khi ứng dụng chuyển sang chế độ đa nhiệm (App Switcher).
3. **Đóng dấu bản quyền định danh (Dynamic Watermark Injection)**:
   - Khi người lao động tải tệp PDF về máy, hệ thống tự động chèn chữ mờ in chéo toàn bộ trang:  
     `NGUYỄN VĂN A - MSNV: 08412 - ĐÃ KÝ NGÀY 23/09/2026 14:30`.
   - Chống phát tán hợp đồng và thông tin thu nhập lên mạng xã hội.
4. **Bảo toàn tính bất biến (Document Immutability)**:
   - Tài liệu khi đã hoàn tất ký kết sẽ được gán mã băm toàn vẹn SHA-256 và lưu trữ bất biến. Tuyệt đối không cho phép ghi đè. Mọi thay đổi về chế độ bắt buộc phải lập Phụ lục hợp đồng mới.

### 3.4. Ranh Giới Nghiệp Vụ Mobile App & Web Admin

```
┌────────────────────────────────────────────────────────┬────────────────────────────────────────────────────────┐
│                    TRÊN MOBILE APP                     │                    TRÊN WEB ADMIN                      │
├────────────────────────────────────────────────────────┼────────────────────────────────────────────────────────┤
│ • Danh mục hợp đồng cá nhân: Cần ký, Hiệu lực, Hết hạn │ • Tạo hợp đồng hàng loạt từ file PDF hoặc biểu mẫu sẵn │
│ • Trình đọc PDF bảo mật cao, ghi nhận tiến độ cuộn đọc │ • Cấu hình các trường dữ liệu tự động điền (Merge tags)│
│ • Xác thực sinh trắc học (Face ID/Fingerprint/PIN)     │ • Thiết lập luồng phê duyệt và thứ tự các bên ký       │
│ • Bàn vẽ chữ ký cảm ứng mượt mà trực tiếp trên màn hình│ • Ban Giám Đốc ký số phê duyệt tập trung nhiều hợp đồng│
│ • Chức năng gửi Yêu cầu chỉnh sửa hoặc Từ chối ký      │ • Giám sát tiến độ ký kết toàn xưởng, lọc người chưa ký│
│ • Tải tệp hợp đồng hoàn tất có chứa Watermark bảo mật  │ • Tự động gửi thông báo nhắc nhở các trường hợp sắp hạn│
└────────────────────────────────────────────────────────┴────────────────────────────────────────────────────────┘
```

### 3.5. Tiêu Chí Nghiệm Thu (Acceptance Criteria)
- **CON-AC-001**: Nhân viên chỉ xem được duy nhất hợp đồng của chính mình. Cấp quản lý chỉ xem được hợp đồng khi nằm trong luồng phê duyệt được cấu hình.
- **CON-AC-002**: Nút "Ký hợp đồng" chỉ sáng lên khi công nhân đã cuộn đọc 100% nội dung tài liệu và vượt qua bước xác thực sinh trắc học.
- **CON-AC-003**: File PDF tải về máy bắt buộc phải chứa Watermark thông tin cá nhân và thời điểm tải.

---

## 4. CHỨC NĂNG 3: CẢNH BÁO & HÀNG ĐỢI CHẤM CÔNG NGOẠI TUYẾN CHƯA GỬI
*(Mở rộng chiều sâu kỹ thuật từ P0 #4 — Bảo vệ 100% ngày công cho công nhân)*

### 4.1. Mục Tiêu Nghiệp Vụ
- Giải quyết triệt để đặc thù nhà xưởng sản xuất: Kết cấu mái tôn, khung thép dày và tầng hầm gây mất sóng 4G/5G hoặc gián đoạn mạng Wi-Fi.
- Đảm bảo công nhân quẹt thẻ điểm danh mượt mà tại hiện trường; dữ liệu được lưu an toàn trong hàng đợi cục bộ và **tự động đồng bộ lên server khi bắt đúng sóng Wi-Fi của công ty**.
- Loại bỏ hoàn toàn nguy cơ công nhân bị trừ lương oan do quên đồng bộ dữ liệu trước ngày chốt sổ công (Timesheet Cutoff).

### 4.2. Chính Sách Kết Nối Khắt Khe: CHỈ ĐỒNG BỘ QUA WI-FI CÔNG TY
- **Nguyên tắc**: Ứng dụng **tuyệt đối không gửi dữ liệu chấm công ngoại tuyến qua 4G/5G hoặc mạng Wi-Fi bên ngoài**.
- **Lý do nghiệp vụ**: Sóng Wi-Fi nội bộ nhà máy (thông qua địa chỉ định danh BSSID) đóng vai trò là chốt xác thực kép chứng minh công nhân đang có mặt thực tế tại cơ sở làm việc. Cho phép đồng bộ qua 4G tại nhà sẽ tạo lỗ hổng gian lận vị trí.

### 4.3. Thang Đo Cảnh Báo Trực Quan Theo Thời Gian (Aging Warning Ladder)

```
┌───────────────────────────┬───────────────────┬──────────────┬──────────────────────────────────────────────────┐
│ Khoảng thời gian tồn đọng │ Mức độ cảnh báo   │ Màu sắc UI   │ Hành động hệ thống & Biện pháp can thiệp         │
├───────────────────────────┼───────────────────┼──────────────┼──────────────────────────────────────────────────┤
│ Dưới 24 giờ               │ Thông báo thường  │ Vàng         │ Hiện Banner trên Dashboard & màn hình Chấm công. │
│ Từ 24 đến 72 giờ          │ Cảnh báo vừa      │ Cam          │ Gửi Push Notification nhắc kết nối Wi-Fi xưởng.  │
│ Trên 72 giờ (> 3 ngày)    │ Nghiêm trọng      │ Đỏ           │ Đưa vào danh sách cảnh báo của Tổ trưởng / QL ca.│
│ Trên 7 ngày               │ Sự vụ tồn đọng    │ Đỏ sẫm       │ HR/IT tiếp nhận hỗ trợ kiểm tra thiết bị trực tiếp│
│ Trước khóa công 3 ngày    │ Nhắc nhở chốt sổ  │ Cam đậm      │ Thông báo khẩn cấp toàn bộ các bên liên quan.    │
│ Trước khóa công 1 ngày    │ Bắt buộc xử lý    │ Đỏ nhấp nháy │ Khóa màn hình nhắc nhở, bắt buộc đồng bộ ngay.   │
└───────────────────────────┴───────────────────┴──────────────┴──────────────────────────────────────────────────┘
```

### 4.4. Trải Nghiệm Giao Diện Người Dùng (UX) & Chốt Chặn An Toàn
1. **Banner cảnh báo dính (Sticky Banner)**:
   - Khi phát sinh lượt chấm công ngoại tuyến, app hiển thị thông báo nổi trong **10 giây**, sau đó thu gọn thành Banner cố định trên Dashboard và màn hình Chấm công.
   - Banner hiển thị rõ: Số lượt chờ gửi, thời điểm lượt cũ nhất, nguyên nhân (chờ Wi-Fi công ty) kèm 2 nút bấm: `[ Đồng bộ ngay ]` và `[ Xem chi tiết ]`.
   - **Banner không thể bị tắt bỏ** nếu hàng đợi vẫn còn dữ liệu chưa có xác nhận thành công (ACK) từ máy chủ.
2. **Khóa đăng xuất bảo vệ dữ liệu (Logout Block)**:
   - Hệ thống **tuyệt đối chặn thao tác Đăng xuất** nếu thiết bị còn lượt công ngoại tuyến chưa gửi. Người dùng bắt buộc phải kết nối Wi-Fi nhà máy để đồng bộ sạch hàng đợi trước khi thoát tài khoản.
3. **Kiểm tra hàng đợi khi đổi thiết bị (Device Change Check)**:
   - Cán bộ IT/Quản lý khi duyệt mở khóa máy mới cho công nhân sẽ kiểm tra trạng thái máy cũ. Nếu còn dữ liệu kẹt, máy mới sẽ bị tạm giữ quyền điểm danh cho đến khi xử lý dứt điểm.
4. **Cam kết lưu trữ vận hành 30 ngày (30-day Retention SLA)**:
   - Hàng đợi trên máy tuyệt đối không tự động xóa sau bất kỳ khoảng thời gian nào. Ngưỡng 30 ngày là mốc bắt buộc IT/HR can thiệp xử lý ngoại lệ, không phải lệnh tự xóa dữ liệu.
5. **Cơ chế Idempotency chống trùng lặp**:
   - Mỗi lượt chấm công mang một mã UUID định danh duy nhất. Dù mạng chập chờn gửi lại nhiều lần, máy chủ chỉ ghi nhận đúng 1 bản ghi duy nhất.

### 4.5. Ranh Giới Nghiệp Vụ Mobile App & Web Admin

```
┌────────────────────────────────────────────────────────┬────────────────────────────────────────────────────────┐
│                    TRÊN MOBILE APP                     │                    TRÊN WEB ADMIN                      │
├────────────────────────────────────────────────────────┼────────────────────────────────────────────────────────┤
│ • Lưu trữ hàng đợi mã hóa AES-256 trong Secure Storage │ • Theo dõi tổng số lượt công tồn đọng toàn nhà máy     │
│ • Hiển thị Sticky Banner cảnh báo đa cấp theo thời gian│ • Cấu hình danh sách địa chỉ Wi-Fi (BSSID) hợp lệ      │
│ • Màn hình danh sách hàng đợi: Chi tiết từng lượt công │ • Cấu hình mốc thời gian cảnh báo (24h, 72h, khóa công)│
│ • Tiến trình đồng bộ thời gian thực (x/y lượt)         │ • Báo cáo danh sách công nhân có nguy cơ mất công      │
│ • Chặn đăng xuất khi hàng đợi chưa gửi hết             │ • Xử lý ngoại lệ các trường hợp lỗi đồng bộ thiết bị   │
└────────────────────────────────────────────────────────┴────────────────────────────────────────────────────────┘
```

### 4.6. Tiêu Chí Nghiệm Thu (Acceptance Criteria)
- **OFF-AC-001**: Thiết bị bật 4G hoặc kết nối Wi-Fi quán cafe ngoài công ty thì hệ thống không bao giờ tự ý gửi payload chấm công; banner hiển thị rõ "Đang chờ kết nối Wi-Fi nhà máy".
- **OFF-AC-002**: Khi đồng bộ 10 lượt mà 8 lượt thành công, 2 lượt bị lỗi: Hệ thống chỉ xóa 8 lượt đã có ACK, giữ nguyên 2 lượt lỗi và cập nhật banner còn "2 lượt chưa gửi".
- **OFF-AC-003**: Người dùng bấm Đăng xuất khi còn 1 lượt chưa gửi thì hệ thống chặn lại và hiển thị cảnh báo đỏ yêu cầu đồng bộ trước.

---

## 5. CHỨC NĂNG 4: TỔNG HỢP CÔNG THEO CA TRONG TUẦN CỦA TỔ / NHÓM
*(Rút gọn từ P1 #53 vào P0 — Vũ khí chỉ huy sản xuất của Tổ trưởng)*

### 5.1. Mục Tiêu Nghiệp Vụ
- Giải quyết bài toán cân đối quân số dây chuyền đầu mỗi ca làm việc cho Tổ trưởng và Quản lý ca trực tiếp (quản lý 30–50 công nhân/tổ).
- Cho phép Tổ trưởng chỉ mất 10 giây trên điện thoại là nắm được toàn bộ bức tranh tuần: Ai làm ca nào, ai đi ca sáng, ai trực ca đêm, ai đi làm ca gãy hoặc đang nghỉ bù.
- Đối chiếu ngay lập tức giữa **Ca kế hoạch được phân** và **Ca thực tế đi làm**, phát hiện sớm sai lệch trước ngày chốt bảng lương.

### 5.2. Quy Tắc Tính Toán Nghiệp Vụ Sản Xuất
1. **Đơn vị tổng hợp cốt lõi**:
   - Tổng hợp theo **Số lượt làm từng loại ca** trong tuần thay vì chỉ đếm tổng số giờ làm việc.
   - Ví dụ hiển thị trên thẻ công nhân:  
     `Ca 1 (Sáng): 3 lượt | Ca 2 (Chiều): 2 lượt | Ca 3 (Đêm): 1 lượt | Nghỉ: 1 ngày`.
2. **Quy tắc ca qua đêm (Overnight Shift Rule)**:
   - Ca làm việc bắt đầu từ **22:00 tối thứ Hai** và kết thúc lúc **06:00 sáng thứ Ba** được tính trọn vẹn vào **ngày thứ Hai** (ngày bắt đầu ca làm việc) theo đúng chuẩn mực hạch toán ca kíp.
3. **Quy tắc làm 2 ca trong ngày (Double Shift)**:
   - Trường hợp công nhân làm ca chính và tăng cường thêm 1 ca phụ trong cùng một ngày, hệ thống ghi nhận là **02 lượt ca riêng biệt** để đảm bảo chi trả đầy đủ phụ cấp ca kíp và tiền làm thêm giờ.
4. **Quy tắc ca gãy (Split Shift)**:
   - Ca gãy (như khối phục vụ nhà ăn, lái xe đưa đón) là một loại ca đặc thù có khoảng nghỉ dài giữa ca, được ghi nhận là một loại ca độc lập, không bị tách thành 2 ca riêng lẻ.
5. **Đổi ca trực**:
   - Chỉ khi đơn xin đổi ca giữa 2 công nhân được Quản lý phê duyệt trên hệ thống thì lịch ca mới được cập nhật trên bảng tổng hợp.

### 5.3. Trải Nghiệm Giao Diện Người Dùng Trên Điện Thoại (Mobile UX)
- **Chế độ xem thuần túy (Read-only on Mobile)**: Ứng dụng điện thoại chỉ dùng để xem, lọc, kiểm tra và xuất báo cáo. Việc xếp ca, đổi ca hàng loạt cho 3.000 công nhân được thực hiện trên Web Admin để tránh nhầm lẫn.
- **Thao tác vuốt chuyển tuần mượt mà**: Hỗ trợ vuốt ngang để xem tuần trước / tuần sau hoặc chọn nhanh từ lịch.
- **Bộ lọc đa tầng theo quyền**: Cho phép lọc nhanh theo Phân xưởng, Dây chuyền, Tổ sản xuất, Chức danh.
- **Tính năng khoan sâu (Drill-down)**:
  - Bấm vào tên công nhân $\rightarrow$ Mở chi tiết 7 ngày trong tuần: Ngày nào làm ca gì, giờ Check-in/Check-out thực tế, chênh lệch bao nhiêu phút, trạng thái đơn giải trình.
  - Bấm vào số lượt của một ca cụ thể (ví dụ: *Ca đêm: 2 lượt*) $\rightarrow$ Lọc ra ngay 2 ngày công nhân làm ca đêm đó.
- **Xuất báo cáo hiện trường**: Cho phép Tổ trưởng kết xuất bảng tổng hợp ca tuần ra tệp **PDF hoặc Excel** trực tiếp từ điện thoại để gửi qua Zalo/Email cho Quản đốc phân xưởng.

### 5.4. Ranh Giới Nghiệp Vụ Mobile App & Web Admin

```
┌────────────────────────────────────────────────────────┬────────────────────────────────────────────────────────┐
│                    TRÊN MOBILE APP                     │                    TRÊN WEB ADMIN                      │
├────────────────────────────────────────────────────────┼────────────────────────────────────────────────────────┤
│ • Xem bảng tổng hợp ca tuần của tổ/nhóm được phân công │ • Xếp ca làm việc tự động hoặc hàng loạt cho 3.000 ng  │
│ • Thẻ công nhân: Tổng ngày công, số lượt từng loại ca  │ • Cấu hình danh mục loại ca: Ca 1, Ca 2, Ca đêm, Ca gãy│
│ • Khoan sâu (Drill-down) chi tiết 7 ngày trong tuần    │ • Cấu hình chu kỳ tuần làm việc theo từng nhà máy      │
│ • Lọc theo phân xưởng, tổ, bộ phận, tìm kiếm tên/MSNV  │ • Điều chỉnh lịch ca làm việc hàng loạt khi có sự cố   │
│ • Xuất file báo cáo tổng hợp ca tuần (PDF / Excel)     │ • Kết xuất bảng công tổng hợp chuyển sang phần mềm lương│
└────────────────────────────────────────────────────────┴────────────────────────────────────────────────────────┘
```

### 5.5. Tiêu Chí Nghiệm Thu (Acceptance Criteria)
- **SFT-AC-001**: Ca làm việc qua đêm từ 22:00 thứ Hai đến 06:00 thứ Ba phải được ghi nhận chuẩn xác vào ngày thứ Hai; tổng hợp tuần chứa ngày thứ Hai tăng thêm 1 lượt ca đêm.
- **SFT-AC-002**: Tổ trưởng chỉ xem được công nhân thuộc tổ mình phụ trách; không thể can thiệp sửa ca hay xếp lại lịch trên điện thoại.
- **SFT-AC-003**: File PDF và Excel xuất ra từ app phản ánh chính xác dữ liệu theo bộ lọc và thời điểm tra cứu.

---

## 6. MA TRẬN PHÂN QUYỀN (RBAC) DÀNH RIÊNG CHO 04 PHÂN HỆ BỔ SUNG

Ma trận phân định quyền hạn chi tiết cho 06 vai trò trên hệ thống đối với 04 phân hệ bổ sung:

```
┌────────────────────────────────────────────────────────┬─────┬─────┬─────┬─────┬─────┬─────┐
│ MÃ QUYỀN HẠN CHI TIẾT (PERMISSION CODE)                │ EMP │ TML │ MGR │ RGM │ HRA │ BGD │
├────────────────────────────────────────────────────────┼─────┼─────┼─────┼─────┼─────┼─────┤
│ 1. CỘNG ĐỒNG NỘI BỘ                                    │     │     │     │     │     │     │
│ • community.post.view (Đọc bảng tin & bài viết)        │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │
│ • community.comment.create (Bình luận, phản hồi chuỗi) │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │
│ • community.read_ack.confirm (Xác nhận "Tôi đã đọc")   │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │
│ • community.report.create (Báo cáo nội dung vi phạm)   │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │
│ • community.post.create (Tạo bài viết mới trên Web)    │  —  │  —  │  —  │  —  │  ✓  │  ✓* │
│ • community.post.pin (Ghim bài viết quan trọng)        │  —  │  —  │  —  │  —  │  ✓  │  ✓  │
│ • community.content.moderate (Kiểm duyệt, xóa bài xấu) │  —  │  —  │  —  │  —  │  ✓  │  —  │
│ • community.read_ack.summary (Xem thống kê tỷ lệ đọc)  │  —  │  —  │  ✓* │  ✓* │  ✓  │  ✓  │
├────────────────────────────────────────────────────────┼─────┼─────┼─────┼─────┼─────┼─────┤
│ 2. HỢP ĐỒNG ĐIỆN TỬ                                    │     │     │     │     │     │     │
│ • contract.view_own (Xem hợp đồng của bản thân)        │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │
│ • contract.sign_own (Ký số hợp đồng cá nhân)           │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │
│ • contract.revision.request (Gửi yêu cầu chỉnh sửa)    │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │
│ • contract.approve (Duyệt theo luồng quản lý phân xưởng│  —  │  —  │  ✓  │  ✓  │  ✓  │  —  │
│ • contract.final_approve (Ban Giám Đốc phê duyệt cuối) │  —  │  —  │  —  │  —  │  —  │  ✓  │
│ • contract.create_manage (Tạo mẫu, gửi hợp đồng hàng lo│  —  │  —  │  —  │  —  │  ✓  │  —  │
│ • contract.audit.view (Xem vết kiểm toán & bảo mật)    │  —  │  —  │  —  │  —  │  ✓  │  ✓  │
├────────────────────────────────────────────────────────┼─────┼─────┼─────┼─────┼─────┼─────┤
│ 3. CHẤM CÔNG NGOẠI TUYẾN                               │     │     │     │     │     │     │
│ • attendance.offline.view_own (Xem hàng đợi của mình)  │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │
│ • attendance.offline.sync_own (Đồng bộ hàng đợi của mìn│  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │
│ • attendance.offline.team_view (Xem tồn đọng của tổ)   │  —  │  ✓  │  ✓  │  ✓  │  ✓  │  —  │
│ • attendance.offline.admin_view (Giám sát toàn nhà máy)│  —  │  —  │  —  │  —  │  ✓  │  ✓  │
│ • attendance.offline.override_logout (Đặc quyền bypass)│  —  │  —  │  —  │  —  │  ✓  │  —  │
├────────────────────────────────────────────────────────┼─────┼─────┼─────┼─────┼─────┼─────┤
│ 4. TỔNG HỢP CÔNG CA TUẦN                               │     │     │     │     │     │     │
│ • shift.summary.team_view (Xem tổng hợp ca của tổ/nhóm)│  —  │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │
│ • shift.summary.multi_level (Lọc xem nhiều phân xưởng) │  —  │  —  │  ✓  │  ✓  │  ✓  │  ✓  │
│ • shift.summary.export (Xuất báo cáo PDF/Excel từ app) │  —  │  ✓  │  ✓  │  ✓  │  ✓  │  ✓  │
│ • shift.schedule.manage (Xếp ca, sửa ca trên Web)      │  —  │  —  │  ✓* │  ✓* │  ✓  │  —  │
└────────────────────────────────────────────────────────┴─────┴─────┴─────┴─────┴─────┴─────┘
Ký hiệu:
• EMP: Công nhân / Nhân viên (Employee)
• TML: Tổ trưởng / Quản lý ca (Team Lead)
• MGR: Quản đốc phân xưởng (Manager)
• RGM: Giám đốc khối / Quản lý vùng (Regional Manager)
• HRA: Cán bộ Nhân sự / Quản trị hệ thống (HR Admin)
• BGD: Ban Giám Đốc / C-level
• [✓]: Có quyền truy cập | [—]: Không có quyền | [*]: Phụ thuộc phân quyền ủy quyền theo doanh nghiệp
```

---

## 7. MA TRẬN RỦI RO VẬN HÀNH & GIẢI PHÁP KIỂM SOÁT KỸ THUẬT

| STT | Rủi ro vận hành trọng yếu | Phân hệ ảnh hưởng | Mức độ | Giải pháp kiểm soát kỹ thuật & Quy trình dự phòng |
| :---: | :--- | :--- | :---: | :--- |
| **01** | **Mất điện hoặc sự cố Wi-Fi nhà máy dài ngày** | Chấm công ngoại tuyến | **Cao** | Thiết kế quy trình mở khóa khẩn cấp (*Emergency Sync Override*): Cho phép đồng bộ qua 4G có mã OTP ủy quyền từ Giám đốc nhà máy và lưu vết Audit Log. |
| **02** | **Công nhân đổi máy hoặc gỡ ứng dụng khi còn hàng đợi** | Chấm công ngoại tuyến | **Cao** | Chặn đăng xuất tuyệt đối khi hàng đợi chưa rỗng; Quản trị viên từ chối phê duyệt thiết bị mới nếu hàng đợi máy cũ chưa được giải phóng. |
| **03** | **Tranh chấp pháp lý về chữ ký điện tử trên màn hình** | Hợp đồng điện tử | **Cao** | Lưu vết toàn diện: Tọa độ GPS, địa chỉ IP, ảnh sinh trắc học lúc ký, thời gian server UTC và mã băm SHA-256 niêm phong file. |
| **04** | **Phát tán bảng lương và phụ cấp ra bên ngoài** | Hợp đồng điện tử | **Trung bình**| Chặn chụp ảnh màn hình hệ điều hành (`FLAG_SECURE`) và tự động chèn Watermark đè chéo thông tin cá nhân khi tải file. |
| **05** | **Tin đồn tiêu cực hoặc bình luận phản cảm trên bảng tin** | Cộng đồng nội bộ | **Trung bình**| Không cấp quyền đăng bài cho công nhân; tích hợp bộ lọc từ khóa tự động; HR có công cụ xóa mềm ngay khi nhận báo cáo vi phạm. |
| **06** | **Nghẽn mạng khi 1.000 công nhân cùng đồng bộ lúc tan ca** | Chấm công ngoại tuyến | **Trung bình**| Áp dụng cơ chế Exponential Backoff kèm Jitter ngẫu nhiên; gửi dữ liệu theo từng đợt nhỏ (batch 5-10 records) để chống nghẽn server. |

---

## 8. KẾ HOẠCH TRIỂN KHAI & TIÊU CHÍ NGHIỆM THU (DEFINITION OF DONE)

### 8.1. Lộ Trình Triển Khai Chi Tiết Cho 04 Phân Hệ
- **Tuần 1 - 2 (Sprint 1)**:
  - Triển khai phân hệ **Hàng đợi & Cảnh báo Chấm công Ngoại tuyến** (Lưu trữ mã hóa AES-256, Sticky Banner, logic chỉ đồng bộ qua Wi-Fi công ty, cơ chế khóa đăng xuất).
- **Tuần 3 - 4 (Sprint 2)**:
  - Triển khai phân hệ **Cộng đồng Nội bộ** (Giao diện bảng tin, chi tiết bài viết, bình luận 2 tầng, tính năng xác nhận "Tôi đã đọc", phân loại bài khẩn cấp).
  - Triển khai phân hệ **Tổng hợp công theo ca tuần** (Thẻ công nhân, logic tính ca qua đêm/ca gãy/2 ca một ngày, khoan sâu chi tiết, xuất PDF/Excel).
- **Tuần 5 - 6 (Sprint 3)**:
  - Triển khai phân hệ **Hợp đồng Điện tử & Ký số** (Trình đọc PDF bảo mật, cấm chụp màn hình, bàn vẽ chữ ký, sinh trắc học, đóng dấu Watermark và mã băm SHA-256).
  - Tích hợp Ma trận phân quyền RBAC và kiểm tra cô lập đa tenant.
- **Tuần 7 (Sprint 4)**:
  - Kiểm thử tải mô phỏng 3.000 công nhân đồng thời; đóng gói và nghiệm thu chính thức P0 MVP Release.

### 8.2. Tiêu Chí Nghiệm Thu Tổng Thể (Definition of Done - DoD)
1. **Chất lượng mã nguồn**:
   - Mã nguồn đạt chuẩn tuyệt đối: `flutter analyze` 0 lỗi (Zero Warnings / Zero Issues).
   - Tuân thủ nguyên tắc Clean Architecture & Pure Flutter Responsive (`AppLayout`).
   - Không tệp `.dart` nào vượt quá giới hạn **300 dòng code**.
   - 100% nhãn giao diện dùng Localization (Việt - Anh), không hardcode chuỗi ký tự.
2. **Khả năng hoạt động ngoại tuyến & An toàn dữ liệu**:
   - Kiểm thử thực tế ngắt mạng trong xưởng kín: Dữ liệu chấm công lưu an toàn và tự động đồng bộ khi bắt đúng Wi-Fi công ty. Không phát sinh bản ghi trùng.
   - Thao tác đăng xuất bị khóa hoàn toàn khi hàng đợi chưa rỗng.
3. **Bảo mật & Hiệu năng**:
   - Hợp đồng không thể chụp ảnh màn hình; file tải về có đầy đủ Watermark.
   - Tốc độ tải bảng tổng hợp ca tuần cho tổ 50 người đạt dưới **0.8 giây**.

---

### KẾT LUẬN & KIẾN NGHỊ
04 phân hệ bổ sung trên là những mảnh ghép mang tính chất **quyết định sự sống còn** cho việc ứng dụng phần mềm HRM vào thực tế tại các nhà máy và xí nghiệp có hàng ngàn lao động.

Ban Dự án kính trình Ban Giám Đốc xem xét và thông qua đặc tả chi tiết của **04 chức năng bổ sung này** để đội ngũ kỹ thuật tiến hành triển khai hoàn thiện sản phẩm theo đúng lộ trình cam kết.

*Trân trọng kính trình!*

**TM. BAN DỰ ÁN VSTECH HRM**  
*Trưởng Ban Chuyển Đổi Số Doanh Nghiệp*
