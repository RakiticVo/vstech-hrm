# API Contract — kỳ vọng của mobile team (backend chưa có OpenAPI chính thức)

Backend đang phát triển song song, chưa công bố Swagger/OpenAPI. Tài liệu này là **hợp đồng kỳ vọng** mobile team tự định nghĩa để code trước (kèm mock server/mock data), và sẽ đối chiếu/cập nhật lại khi backend công bố spec thật. Khi có sai khác, **cập nhật file này trước rồi mới sửa code**, không để code và doc lệch nhau.

## 1. Quy ước chung

- Base URL theo 2 môi trường: **`dev`** và **`prod`**, đọc từ `.env` (`API_BASE_URL`).
- Khi `USE_MOCK_DATA=true`, hệ thống sử dụng `MockDioInterceptor` nạp dữ liệu mẫu trực tiếp để phục vụ chế độ Demo độc lập mà không cần kết nối server.
- Response envelope chuẩn:
  ```json
  {
    "success": true,
    "data": { ... },
    "message": "string | null",
    "errorCode": "string | null"
  }
  ```
- Lỗi nghiệp vụ trả `success: false` kèm `errorCode` (dạng `SNAKE_CASE`, vd `LEAVE_QUOTA_EXCEEDED`) + `message` tiếng Việt tự nhiên (theo tinh thần copywriting ở `docs/design-system.md` mục 11) để hiển thị thẳng ra UI khi phù hợp.
- Auth: `Authorization: Bearer <access_token>`. Access token hết hạn ngắn (đề xuất 15–30 phút), refresh token dài hơn — luồng refresh tự động qua Dio interceptor, lưu cả 2 token ở `flutter_secure_storage`.
- Ngày giờ: ISO 8601 UTC (`2026-09-16T00:56:00Z`), mobile tự convert sang giờ VN (UTC+7) khi hiển thị.
- Tiền tệ: số nguyên (đơn vị đồng), không dùng số thực để tránh sai số.
- Phân trang danh sách: `?page=1&pageSize=20`, response kèm `{ "items": [...], "total": 0, "page": 1, "pageSize": 20 }`.

## 2. Auth

| Endpoint | Method | Ghi chú |
| --- | --- | --- |
| `/auth/login` | POST | body: `{ employeeCode, password }` → trả `{ accessToken, refreshToken, user }` |
| `/auth/refresh` | POST | body: `{ refreshToken }` |
| `/auth/logout` | POST | Thu hồi refresh token hiện tại |
| `/auth/device-bind` | POST | Đăng ký thiết bị chính (device fingerprint) — liên quan #18 Device Binding |

`user` object cần có: `id`, `employeeCode`, `fullName`, `avatarUrl`, `role` (`employee` \| `manager` \| `executive`), `departmentId`, `branchId`, `managerId`.

## 3. Attendance (#3, #5, #6, #7)

| Endpoint | Method | Ghi chú |
| --- | --- | --- |
| `/attendance/check-in` | POST | multipart: ảnh/video khuôn mặt + `{ lat, lng, bssid, capturedAt }` |
| `/attendance/check-out` | POST | tương tự check-in |
| `/attendance/today` | GET | trạng thái hiện tại (chưa vào/đang làm/xong) cho Personal Dashboard |
| `/attendance/history` | GET | `?from=&to=&granularity=day\|week\|month` |
| `/attendance/calendar` | GET | `?month=2026-09` → trả mảng ngày kèm status color (5 màu chuẩn ở design-system) |
| `/attendance/regularization` | POST | body: `{ date, actualTimeRange, reason, attachmentUrls[] }` |
| `/attendance/regularization/{id}` | GET/PUT/DELETE | xem/sửa (khi Draft)/huỷ |

Face recognition xử lý hoàn toàn server-side; response check-in/out cần trả về kết quả phân loại (`onTime`/`late`/`earlyLeave`/`sufficientHours`/`insufficientHours`) để mobile hiển thị ngay, không tự tính lại ở client.

## 4. Leave & Overtime (#9, #10)

| Endpoint | Method | Ghi chú |
| --- | --- | --- |
| `/leave/balance` | GET | trả breakdown theo từng loại phép |
| `/leave/requests` | GET/POST | list + tạo mới. POST body: `{ type, startDate, endDate, isHalfDay, reason, delegateToUserId, attachmentUrls[] }` |
| `/leave/requests/{id}` | GET/DELETE | chi tiết / huỷ (khi Pending) |
| `/leave/conflicts` | GET | `?startDate=&endDate=` — mobile gọi trước khi submit để cảnh báo trùng lịch (bổ sung cho check client-side bằng cache local) |
| `/overtime/requests` | GET/POST | tương tự leave, body có `hours`, `rateMultiplier` (150/200/300) tính sẵn ở backend |
| `/overtime/requests/{id}` | GET/DELETE | |

## 5. Payroll & Incentives (#11, #12)

| Endpoint | Method | Ghi chú |
| --- | --- | --- |
| `/payroll/overview` | GET | tổng quan lương hiện tại (theo hợp đồng) |
| `/payroll/payslips` | GET | `?month=2026-09` list phiếu lương |
| `/payroll/payslips/{id}` | GET | chi tiết đầy đủ: earnings[], deductions[], net |
| `/payroll/payslips/{id}/sign` | POST | ký số điện tử xác nhận |
| `/payroll/disputes` | POST | body: `{ payslipId, itemRef, description }` |
| `/incentives/summary` | GET | thưởng doanh số/hoa hồng, tiến độ target (%) |

Toàn bộ endpoint payroll yêu cầu header xác thực bổ sung `X-Biometric-Verified: true` — mobile chỉ gọi các endpoint này SAU khi `local_auth` xác thực thành công trong phiên hiện tại (không gửi kèm dữ liệu sinh trắc, chỉ là cờ xác nhận đã pass local check).

## 6. Requests & Approvals (#14, #15)

| Endpoint | Method | Ghi chú |
| --- | --- | --- |
| `/requests` | GET | Request Center — tổng hợp mọi loại đơn (leave/overtime/correction/dispute), filter theo `type`, `status` |
| `/approvals/pending` | GET | dành cho QL — danh sách đơn cấp dưới đang chờ |
| `/approvals/{requestId}/approve` | POST | body: `{ comment }` |
| `/approvals/{requestId}/reject` | POST | body: `{ reason }` (bắt buộc) |

Mỗi request object cần có `approvalTimeline: [{ step, approverName, status, actedAt }]` đủ 4 bước để render timeline/progress bar đúng như design.

## 7. Dashboard, Notifications, Profile (#13, #16, #17, #18)

| Endpoint | Method | Ghi chú |
| --- | --- | --- |
| `/dashboard/summary` | GET | số liệu tổng hợp cho Personal Dashboard (1 call duy nhất, tránh N+1 từ nhiều feature) |
| `/notifications` | GET | `?unreadOnly=` |
| `/notifications/{id}/read` | POST | |
| `/notifications/read-all` | POST | |
| `/profile/me` | GET/PUT | Employee Profile 360 — PUT chỉ cho phép sửa field cá nhân (không sửa Employment Information) |
| `/profile/change-password` | POST | |
| `/security/devices` | GET/DELETE | quản lý thiết bị đã đăng ký (Device Binding) |

FCM: mobile gửi `fcmToken` lên `/notifications/register-token` sau khi login/refresh token, và `/notifications/unregister-token` khi logout.

## 8. Việc cần làm khi backend công bố OpenAPI thật

1. Diff từng endpoint ở trên với spec thật, cập nhật path/field name nếu khác.
2. Generate lại Retrofit client (`build_runner`) theo response shape thật, đặc biệt kiểm tra envelope `{success, data, message, errorCode}` có đúng không.
3. Cập nhật `docs/api-contract.md` này làm nguồn chân lý mới trước khi sửa code.
