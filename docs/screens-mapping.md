# Đối chiếu 29 màn hình thiết kế ↔ 25 chức năng P0

`DESIGN.md` thiết kế sẵn 29 màn cho toàn bộ Employee App (không giới hạn riêng P0), nên **không map 1:1** với danh sách 25 chức năng P0. Đọc bảng này trước khi bắt đầu bất kỳ màn hình nào để biết: build ngay / build nhưng chức năng rút gọn / tạm bỏ qua / cần thiết kế mới.

## A. Màn hình có sẵn thiết kế, thuộc phạm vi P0 — build ngay

| # | Màn (`screen` prop) | Chức năng P0 tương ứng |
| --- | --- | --- |
| 01 | `splash` | Dùng chung |
| 02 | `login` | Dùng chung (đăng nhập) |
| 03 | `home` (NV) | #13 Personal Dashboard |
| 04 | `home` (QL, +dải chờ duyệt) | #13 Personal Dashboard (biến thể QL) |
| 05 | `services` | Điều hướng tới "Tất cả dịch vụ" — dùng chung |
| 06 | `attendance` | #5 Attendance History (+ #6 Timesheet, xem donut tháng) |
| 07 | `facescan` | #3 AI Face Recognition Core Attendance |
| 08 | `calendar` | #6 Timesheet Calendar |
| 09 | `holidays` | #6 Timesheet Calendar (phần ngày lễ) |
| 10 | `requests` | #15 Request Center |
| 11 | `leave` | #9 Leave Balance + #10 Apply/History Leave |
| 12 | `overtime` | #10 Apply/History Overtime |
| 13 | `correction` | #7 Regularization |
| 14 | `payroll` | #11 Salary Overview |
| 15 | `payslip` | #11 e-Payslip / e-Signature / Dispute |
| 16 | `bonus` | #12 Sales Incentives & Target Tracker |
| 19 | `notifications` | #16 Notification Center (FCM) |
| 20 | `profile` | #17 Employee Profile 360 |
| 21 | `approvals` | #14 Approval Inbox (QL) |
| 24 | `settings` | #18 Device Binding & Security (1 phần) + cài đặt ngôn ngữ/theme |
| 25 | `empty` | Dùng chung |
| 26 | `loading` | Dùng chung |
| 27 | `error` | Dùng chung |

## B. Màn hình có sẵn thiết kế nhưng thuộc P1/P2 — **chưa build**, chỉ ghi nhận route placeholder nếu cần

| # | Màn | Thuộc chức năng | Ghi chú |
| --- | --- | --- | --- |
| 17 | `jobs` (Tuyển dụng nội bộ) | P1 #27 Cổng tin tuyển dụng nội bộ | Không phải #1 (Referral) — dễ nhầm. #1 là chương trình giới thiệu, không phải job board nội bộ. |
| 18 | `job` (Chi tiết vị trí) | P1 #27 | Phụ thuộc màn 17 |
| 22 | `exec` (Bảng điều hành BGĐ) | P1 Executive Glance Dashboard | |
| 23 | `final` (Phê duyệt cuối BGĐ) | P1 Executive Approval Inbox | |
| 28 | `risk` (Cảnh báo Rủi ro & Tuân thủ) | P1 HR Risk & Compliance Alerts | |
| 29 | `delegate` (Trung tâm Uỷ quyền) | P1 Delegation of Authority Center | |

**Quyết định khi implement role BGĐ cho P0**: vì tab 1/tab 3 của BGĐ trỏ sang các màn P1 (`exec`, `final`), trong khi P0 hiện tại chưa build các màn này — cần quyết định tạm thời (hỏi người dùng khi bắt đầu implement role BGĐ):
- Phương án A: BGĐ dùng chung home/requests như QL cho tới khi P1 sẵn sàng.
- Phương án B: build route `exec`/`final` dạng khung rỗng (empty state "Sắp ra mắt") để giữ đúng cấu trúc điều hướng 3 cấp ngay từ đầu.

## C. Chức năng P0 **chưa có màn hình thiết kế** trong bộ 29 màn — cần thiết kế mới hoặc quyết định tạm

| Chức năng P0 | Vấn đề |
| --- | --- |
| #1 Giới thiệu nhân tài nội bộ (Referral) | Không có màn nào trong 29 màn khớp với luồng "xem vị trí đang tuyển → chia sẻ QR/link → nhập hồ sơ ứng viên → theo dõi trạng thái". Màn `jobs`/`job` (mục B) là job board nội bộ cho *nhân viên ứng tuyển*, khác với *giới thiệu người ngoài*. |
| #2 Tiếp nhận nhân sự số hoá (Pre-onboarding) | Đối tượng dùng là **ứng viên trúng tuyển**, có thể chưa có tài khoản nhân viên chính thức — cần làm rõ đây có nằm trong cùng app Employee App hay là 1 flow/app riêng (public link, không cần đăng nhập). Chưa có màn thiết kế. |
| #8 Lịch làm việc & Ca trực cá nhân (Shift Scheduling) | Ca hôm nay đã có trong `home`, nhưng chưa rõ có màn riêng xem "lịch phân ca cả tuần/tháng" tách biệt với `calendar` (vốn là lịch **công** đã chấm, không phải lịch **ca** được phân trước) hay không. |

**Việc cần làm trước khi code 3 mục trên**: hỏi người dùng — thiết kế thêm màn mới theo đúng design system (dùng `docs/design-system.md`), hay tạm thời dùng UI tối giản (list/form chuẩn Material, chưa cần đúng thẩm mỹ Gạch bông) để không chặn tiến độ P0.

## D. Screens dùng `Phone.dc.html` — file gốc chưa được cung cấp

Cả 2 file trình bày (`HRM Employee App.dc.html`, `-print.dc.html`) đều `<dc-import>` từ 1 file `Phone.dc.html` chứa markup/CSS/logic thật của cả 29 màn — file này **chưa có** trong những gì người dùng gửi. `docs/design-system.md` đã tổng hợp đủ token (màu, type, spacing, component spec) từ `DESIGN.md` để bắt đầu code, nhưng khi cần đối chiếu pixel-perfect một chi tiết cụ thể của 1 màn (bố cục chính xác, animation, copy chính xác từng dòng), **hỏi người dùng xin thêm `Phone.dc.html`** thay vì tự suy đoán.
