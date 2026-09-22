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

**Quyết định đã chốt**: **Không có vai trò BGĐ ở Phase 0/MVP**. Ứng dụng chỉ tập trung vào 2 vai trò: **Nhân viên (NV / ESS)** và **Quản lý trực tiếp (QL / MSS)**. Vai trò BGĐ cùng các màn điều hành (`exec`, `final`) tạm thời hoãn lại (xem [roadmap.md](roadmap.md)).

## C. Chức năng P0 **chưa có màn hình thiết kế** trong bộ 29 màn — **tạm hoãn ở Phase 0**

| Chức năng P0 | Vấn đề & Quyết định |
| --- | --- |
| #1 Giới thiệu nhân tài nội bộ (Referral) | Không có màn nào trong 29 màn khớp với luồng "xem vị trí đang tuyển → chia sẻ QR/link → nhập hồ sơ ứng viên → theo dõi trạng thái". **Quyết định**: Tạm hoãn, người dùng sẽ cung cấp UI sau. |
| #2 Tiếp nhận nhân sự số hoá (Pre-onboarding) | Đối tượng dùng là ứng viên trúng tuyển, chưa có màn thiết kế. **Quyết định**: Tạm hoãn, người dùng sẽ cung cấp UI sau. |
| #8 Lịch làm việc & Ca trực cá nhân (Shift Scheduling) | Ca hôm nay đã có trong `home`, nhưng chưa có màn xem "lịch phân ca cả tuần/tháng" tách biệt với `calendar`. **Quyết định**: Tạm hoãn màn lịch ca riêng, người dùng sẽ cung cấp UI sau. |

**Quyết định đã chốt**: Cả 3 chức năng trên được ghi nhận trong [roadmap.md](roadmap.md) (Phase 6), không triển khai UI ở Phase 0/MVP cho tới khi người dùng cung cấp thiết kế.

## D. Nguồn gốc thiết kế — `docs/source/`

Các file gốc nằm ở [docs/source/](source/): `DESIGN.md`, `Phone.dc.html` (markup/CSS/logic thật của cả 29 màn, ~190 KB), 2 file trình bày `HRM Employee App.dc.html` / `-print.dc.html` (đều `<dc-import>` từ `Phone.dc.html`), và PDF danh sách chức năng.

`docs/design-system.md` được tổng hợp từ `DESIGN.md` + 2 file trình bày; **`Phone.dc.html` chưa được review chi tiết** khi viết tài liệu. Khi làm 1 màn cụ thể, đối chiếu lại markup gốc của màn đó (bố cục chính xác, animation, copy từng dòng) thay vì suy đoán. Lưu ý: các file gốc dùng Manrope/Lucide, còn code Flutter dùng Source Sans 3/Material Symbols theo quyết định đã chốt.
