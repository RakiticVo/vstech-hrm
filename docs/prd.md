# PRD — vstech-hrm Employee App (Phạm vi P0/MVP)

Nguồn gốc: `DANH_SACH_CHUC_NANG_HRM_THEO_UU_TIEN_v2_BGD.pdf` — 71 chức năng cho nền tảng HRM Mobile B2B SaaS, chuẩn hoá 4 trụ cột Tuyển dụng – Công – Lương – Thưởng, phân loại P0 (25, Must Have) / P1 (38, Should Have) / P2 (8, Could Have).

Tài liệu này chỉ mô tả chi tiết **25 chức năng P0**. P1/P2 liệt kê ở cuối làm backlog tham chiếu, chưa lên acceptance criteria.

Vai trò: **NV** Nhân viên (ESS) · **QL** Quản lý (MSS). *(Lưu ý: Vai trò **BGĐ** Ban Giám đốc tạm hoãn ở Phase 0/MVP này, xem [roadmap.md](roadmap.md))*.

---

## Danh sách 25 chức năng P0

### Tuyển dụng

**1. Giới thiệu nhân tài nội bộ (Employee Referral Program)** — NV
- Xem danh mục vị trí đang tuyển toàn tổ chức.
- Trích xuất link/mã QR giới thiệu cá nhân hoá để chia sẻ mạng xã hội.
- Nhập hồ sơ ứng viên: họ tên, SĐT, email, vị trí, chi nhánh mong muốn, upload CV.
- Theo dõi trạng thái hồ sơ real-time: Tiếp nhận → Phỏng vấn → Thử việc → Ký hợp đồng.
- Tự động kích hoạt tiền thưởng giới thiệu thành công.
- **Trạng thái UI**: Chưa có màn hình trong bộ 29 màn — **tạm hoãn ở Phase 0/MVP, người dùng sẽ cung cấp UI sau** (xem [screens-mapping.md](screens-mapping.md) và [roadmap.md](roadmap.md)).

**2. Tiếp nhận nhân sự số hoá (Digital Pre-onboarding)** — NV (ứng viên trúng tuyển)
- Thư chào mừng, sơ đồ tổ chức, checklist việc cần chuẩn bị ngày đầu.
- Số hoá nộp hồ sơ pháp lý: CCCD gắn chip, bằng cấp, chứng chỉ, sơ yếu lý lịch, giấy khám sức khoẻ — tích hợp OCR tự động trích xuất thông tin.
- Ký số điện tử NDA + nội quy lao động.
- Xem thông tin mentor/quản lý trực tiếp, kết nối nhanh.
- **Trạng thái UI**: Chưa có màn hình trong bộ 29 màn — **tạm hoãn ở Phase 0/MVP, người dùng sẽ cung cấp UI sau** (xem [screens-mapping.md](screens-mapping.md) và [roadmap.md](roadmap.md)).

### Chấm công

**3. Chấm công Nhận diện Khuôn mặt AI (AI Face Recognition Core Attendance)** — NV
- Check-in/out tự động bằng AI Face Recognition (xử lý ở backend).
- Liveness Detection chống giả mạo (ảnh in sẵn, phát lại video, mặt nạ 3D, chấm công hộ).
- Xác thực 3 lớp: sinh trắc khuôn mặt + GPS Geofencing + đối soát BSSID Wi-Fi nội bộ.
- Tốc độ nhận diện < 1 giây, phản hồi âm thanh/rung tức thì.
- Tự động phân loại: Đúng giờ / Đi muộn / Về sớm / Đủ công / Thiếu công.
- Màn hình thiết kế: `07 facescan` (Quét khuôn mặt) — 3 bước frame → recognise → verified + đường thoát thủ công.

**4. ~~Chấm công Ngoại tuyến (Offline Check-in Queue)~~ — ĐÃ HOÃN**
- Lý do: xem [CLAUDE.md §10](../CLAUDE.md#10-việc-còn-thiếu--cần-quyết-định-thêm). Không đưa vào scope build hiện tại. Giữ nguyên mô tả gốc để tham chiếu khi resume: lưu trữ hàng đợi local (SQLite/Drift), timestamp + device signature, tự động đồng bộ ngầm khi có mạng.

**5. Lịch sử chấm công chi tiết (Attendance History)** — NV
- Tra cứu theo Ngày/Tuần/Tháng.
- Giờ check-in/out thực tế, số giờ luỹ kế, số phút đi trễ/về sớm, ảnh đối soát khuôn mặt lúc chấm, trạng thái hợp lệ/lý do bất thường.
- Màn hình thiết kế: `06 attendance`.

**6. Bảng công lịch tháng trực quan (Timesheet Calendar)** — NV
- Lịch tháng, mã màu chuẩn hoá: Xanh lá (đủ công tiêu chuẩn), Vàng/Cam (đi muộn/về sớm), Đỏ (thiếu công/nghỉ không phép), Tím (nghỉ phép được duyệt), Xám (nghỉ tuần/lễ tết).
- Bảng tổng hợp tổng công chuẩn, ngày công thực tế, tổng giờ công luỹ kế trong tháng.
- Màn hình thiết kế: `08 calendar` (chỉ 5 màu trạng thái, không biểu đồ) + `09 holidays` (ngày lễ, tách riêng khỏi lịch công).

**7. Điều chỉnh công & Giải trình ngoại lệ (Regularization)** — NV
- Tạo yêu cầu giải trình khi: quên quẹt thẻ/chấm công, lỗi thiết bị/mạng, đi làm nhiệm vụ ngoài hiện trường đột xuất.
- Kê khai: ngày phát sinh, khung giờ thực tế, lý do cụ thể, đính kèm ảnh minh chứng.
- Vòng đời trạng thái: Draft → Pending → Approved / Rejected / Cancelled.
- Màn hình thiết kế: `13 correction` — 3 bước: ngày → vấn đề → giải trình.

**8. Lịch làm việc & Ca trực cá nhân (Shift Scheduling)** — NV
- Xem ca hôm nay, lịch phân bổ theo tuần/tháng.
- Cấu hình linh hoạt mọi loại ca: hành chính, xoay, gãy, đêm, tuần hoàn.
- Chi tiết ca: tên, khung giờ bắt đầu/kết thúc, nghỉ giữa ca, chi nhánh chỉ định.
- **Trạng thái UI**: Ca hôm nay nằm trong `03/04 home`; màn hình lịch phân ca cả tuần/tháng chuyên biệt chưa có thiết kế riêng trong 29 màn — **tạm hoãn ở Phase 0, người dùng sẽ cung cấp UI sau** (xem [roadmap.md](roadmap.md)).

### Nghỉ phép & Tăng ca

**9. Quản lý số dư phép real-time (Leave Balance)** — NV
- Thống kê: tổng phép được hưởng/năm, đã sử dụng, đang chờ duyệt, khả dụng còn lại.
- Phân loại: Phép năm, Nghỉ bệnh BHXH, Việc riêng hưởng nguyên lương, Nghỉ không lương, Thai sản.
- Màn hình thiết kế: một phần của `11 leave`.

**10. Đăng ký nghỉ phép trực tuyến + Lịch sử nghỉ phép + Đăng ký làm thêm giờ + Lịch sử tăng ca** — NV
- Tạo đơn nghỉ nhanh: chọn loại nghỉ, từ ngày–đến ngày, nghỉ cả ngày/nửa ca.
- Nhập lý do, chọn người bàn giao, upload chứng từ y tế nếu có. Tự tính số ngày, cảnh báo trùng lịch (client-side, đối chiếu cache local).
- Danh sách toàn bộ đơn đã tạo: ngày giờ, thời gian nghỉ, loại phép, số ngày, trạng thái (Pending/Approved/Rejected/Cancelled), phản hồi từ quản lý.
- Đăng ký tăng ca: sản xuất, trực lễ tết, dự án cao điểm, kiểm kê. Tự tính tổng giờ OT + hệ số lương (150%/200%/300%).
- Màn hình thiết kế: `11 leave` (Xin nghỉ phép), `12 overtime` (Tăng ca — đăng ký + lịch sử cùng màn), `10 requests` (Trung tâm yêu cầu, tab lọc + tiến độ 4 đoạn).

**11. Tổng quan thu nhập & Lương / Phiếu lương e-Payslip / Ký số xác nhận / Tra soát khiếu nại lương** — NV
- Xem cơ cấu mức thu nhập hiện tại theo hợp đồng: lương cơ bản, phụ cấp cố định, khoản trích nộp, lương thực nhận dự kiến (Net).
- Lớp bảo mật sinh trắc độc lập (Face ID/vân tay/PIN) bắt buộc trước khi mở dữ liệu tài chính; chống chụp màn hình (Secure Flag).
- Bóc tách chi tiết: lương ngày công thực tế, phụ cấp chức danh/chuyên môn/trách nhiệm/ăn trưa-xăng xe, tiền OT, tiền thưởng hiệu suất/doanh số. Giảm trừ: thuế TNCN, BHXH (8%), BHYT (1.5%), BHTN (1%), đoàn phí, tạm ứng/khấu trừ khác.
- Ký chữ ký điện tử xác nhận bảng lương hàng tháng ngay trên di động.
- Tiếp nhận khiếu nại sai lệch số liệu lương trực tiếp từ phiếu lương, tự động điều hướng tới chuyên viên C&B xử lý.
- Màn hình thiết kế: `14 payroll` (thực nhận trước, chi tiết sau), `15 payslip` (tách thu nhập/khoản trừ, nút tải).

**12. Tra cứu thưởng doanh số & hoa hồng real-time / Theo dõi chỉ số doanh số & tiến độ mục tiêu** — NV (áp dụng vai trò kinh doanh)
- Kết nối API với hệ thống POS/CRM/ERP bên ngoài.
- Theo dõi tiền hoa hồng/thưởng bán hàng tích luỹ theo giao dịch/ngày/tuần/tháng.
- Bóc tách: thưởng doanh thu chung chi nhánh, thưởng cá nhân theo nhóm sản phẩm trọng tâm, thưởng hợp đồng dự án mới.
- Thanh tiến độ trực quan tỷ lệ hoàn thành chỉ tiêu; bảng ước tính mức thưởng tương ứng khi đạt 80/100/120% target.
- Màn hình thiết kế: `16 bonus` (nêu rõ vì sao được thưởng).

**13. Màn hình chính Dashboard tự phục vụ (Personal Dashboard)** — NV/QL/BGĐ
- Trung tâm điều phối: avatar, họ tên, mã NV, chức danh, phòng ban/chi nhánh.
- Trạng thái công hôm nay, giờ check-in/out, thời gian làm việc luỹ kế, nút Check-in 1-chạm.
- Thẻ tóm tắt ca làm hôm nay, số phép còn lại, số đơn từ đang chờ xử lý, thông báo khẩn cấp mới nhất từ BGĐ.
- Màn hình thiết kế: `03 home` (NV), `04 home · quản lý` (QL, thêm dải chờ duyệt).

**14. Hộp thư phê duyệt cho Cấp Quản lý (Approval Inbox & Action — MSS)** — QL
- Danh sách request từ nhân viên cấp dưới đang chờ duyệt real-time.
- Xem chi tiết lý do, chứng từ/ảnh minh chứng đính kèm, lịch sử công của nhân viên.
- Thao tác 1-chạm: Approve, Reject (kèm lý do bắt buộc), nhập bình luận trao đổi nội bộ.
- Màn hình thiết kế: `21 approvals` (duyệt/từ chối ngay trên thẻ).

### Vận hành, Dịch vụ, Đơn từ & Hiện trường

**15. Trung tâm quản lý đơn từ hợp nhất (Request Center)** — NV
- Gom toàn bộ đơn từ cốt lõi vào 1 nơi: nghỉ phép, tăng ca, giải trình công, khiếu nại lương.
- Bộ công cụ xử lý: tạo mới, lưu nháp, gửi duyệt, xem chi tiết, huỷ yêu cầu (khi Pending), xem tiến độ luân chuyển phê duyệt + lý do từ chối nếu có.
- Màn hình thiết kế: `10 requests`.

**16. Trung tâm Thông báo & Push Notification (FCM)** — NV/QL/BGĐ
- Tiếp nhận thông báo tức thời: kết quả phê duyệt đơn từ, nhắc chấm công đầu/cuối ca, thông báo phát hành phiếu lương mới, thông báo khẩn từ công ty.
- Quản lý thông báo: phân loại chung/cá nhân, lọc đã đọc/chưa đọc, đánh dấu đọc tất cả.
- Màn hình thiết kế: `19 notifications` (có nhóm, dấu chưa đọc, deep-link).

**17. Hồ sơ nhân viên 360° (Employee Profile)** — NV
- Personal Information: họ tên, ảnh thẻ, ngày sinh, giới tính, CCCD, email, SĐT, địa chỉ, liên hệ khẩn cấp.
- Employment Information: mã NV, chức vụ, phòng ban/chi nhánh, quản lý trực tiếp, ngày vào làm, loại hợp đồng, địa điểm làm việc.
- Đổi mật khẩu định kỳ, đăng nhập sinh trắc Face ID/Touch ID, đăng xuất an toàn.
- Màn hình thiết kế: `20 profile` (nhóm danh sách, không đổ hết dữ liệu).

**18. Bảo mật tài khoản & Ràng buộc thiết bị (Device Binding)** — NV
- Giới hạn 1 tài khoản nhân viên chỉ được phép chấm công trên duy nhất 1 thiết bị di động chính đã đăng ký.
- Tích hợp phát hiện thiết bị can thiệp root/jailbreak hoặc giả lập vị trí (Mock GPS) chống gian lận chấm công hộ.
- Màn hình thiết kế: một phần của `24 settings` (bảo mật).

---

## Đối chiếu nhanh với các trạng thái/màn dùng chung

Các màn sau không map 1:1 vào 1 chức năng cụ thể mà dùng chung cho toàn app, bắt buộc thiết kế cho mọi flow chính (attendance, leave, overtime, requests, payroll...):

- `01 splash`, `02 login`
- `25 empty`, `26 loading`, `27 error`, (thành công dùng chung pattern "Success" mô tả ở DESIGN.md mục 11, không có màn riêng trong bản in nhưng có trong bản tương tác `success`)
- `24 settings` (cài đặt ngôn ngữ, theme, bảo mật, nhắc chấm công)

## Backlog P1 (38 chức năng, chưa lên acceptance criteria)

Tuyển dụng: Đề xuất bổ sung nhân lực, Cổng tin tuyển dụng nội bộ, Lịch phỏng vấn & phiếu chấm điểm, Theo dõi hoa hồng giới thiệu.
Chấm công: Lockscreen/Home widget 1-chạm, Đổi ca linh hoạt, Lịch nghỉ phép tổng hợp đội nhóm, Quản lý quỹ giờ OT & nghỉ bù, Đăng ký làm ngoài văn phòng (On Duty), Đăng ký công tác dài ngày, Quản lý công tác phí & hoàn ứng (OCR), Đăng ký WFH, Đơn xin xác nhận công, Timesheet dự án/lệnh sản xuất.
Lương: Lịch sử thay đổi lương & xuất PDF, Nhận lương sớm linh hoạt (EWA).
Thưởng: Tra cứu BHXH & khai báo thuế, Thưởng thi đua & chiến dịch kinh doanh, Đánh giá năng lực định kỳ.
Đơn từ: Đơn thâm niên cống hiến, Đơn thôi việc & bàn giao số, Đơn điều chuyển công tác.
Tài sản: Quản lý tài sản & công cụ cấp phát.
Dịch vụ HR: HR Helpdesk, Yêu cầu cập nhật hồ sơ, Kho tài liệu cá nhân, Danh bạ nhân viên, Team Overview, Yêu cầu đổi thiết bị.
Hiện trường: Báo cáo hình ảnh hiện trường (watermark GPS), Kiểm toán tiêu chuẩn cơ sở.
Truyền thông: Bảng tin doanh nghiệp, Thư viện cẩm nang/quy chế.
Hệ thống: Cài đặt hệ thống mở rộng.
Ban Giám đốc: Hộp thư phê duyệt cuối, Executive Glance Dashboard, Risk & Compliance Alerts, Delegation of Authority Center.

## Backlog P2 (8 chức năng)

KPI/OKR toàn diện, Kudos & Recognition, Microlearning, Career Path & Competency Map, Pulse Survey/eNPS, Feedback & Whistleblowing, AI Conversational Assistant, Flexible Benefits & Health Wellness.
