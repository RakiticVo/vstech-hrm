# Security Requirements (đặc thù HRM)

HRM xử lý dữ liệu nhạy cảm bậc cao: lương, thông tin cá nhân (CCCD), dữ liệu sinh trắc học. Các yêu cầu dưới đây là **bắt buộc cho P0**, không phải "nice to have".

## 1. Xác thực & phiên đăng nhập

- Đăng nhập: mã nhân viên + mật khẩu → JWT access token (ngắn hạn) + refresh token (dài hạn).
- Token lưu ở `flutter_secure_storage` (Keychain iOS / Keystore Android) — **tuyệt đối không** `SharedPreferences`.
- Refresh token tự động qua Dio interceptor khi access token hết hạn (401) — retry request gốc sau khi refresh thành công, logout nếu refresh cũng fail.
- Đăng xuất: xoá token khỏi secure storage + unregister FCM token + clear toàn bộ cache local nhạy cảm (bloc/cubit reset về trạng thái ban đầu).

## 2. Sinh trắc học cục bộ (local_auth) — khác AI Face Recognition chấm công

- Dùng cho: mở khoá app (tuỳ chọn), và **bắt buộc** trước khi mở màn Lương/Phiếu lương (theo yêu cầu "lớp bảo mật sinh trắc độc lập" trong PRD #11).
- Flow: `local_auth.authenticate()` → nếu thành công, set flag trong session (không lưu qua app restart) → gắn header `X-Biometric-Verified: true` cho các call payroll trong phiên hiện tại (xem `docs/api-contract.md` §5).
- Fallback: nếu thiết bị không hỗ trợ/không đăng ký sinh trắc học, cho phép nhập mã PIN riêng của app (lưu hash trong secure storage, không lưu plaintext) — cần xác nhận với người dùng khi implement màn Cài đặt bảo mật.
- **Không nhầm lẫn** với AI Face Recognition chấm công (#3) — cái đó xử lý server-side qua ảnh/video capture bằng package `camera`, không dùng `local_auth`.

## 3. Chấm công chống gian lận (#3, #18)

- Mobile capture ảnh/video qua `camera`, gửi kèm:
  - GPS (`geolocator`) — backend đối soát Geofencing quanh cơ sở làm việc.
  - BSSID Wi-Fi (`network_info_plus`) — backend đối soát mạng nội bộ.
- **Device Binding**: đăng ký thiết bị chính lúc đăng nhập lần đầu (`device_info_plus` lấy fingerprint thiết bị, gửi lên `/auth/device-bind`). Backend chặn chấm công nếu request đến từ thiết bị khác thiết bị đã đăng ký cho tài khoản đó.
- **Phát hiện root/jailbreak & Mock Location**: dùng `safe_device` (hoặc `freerasp`) check lúc mở app và trước mỗi lần chấm công. Nếu phát hiện thiết bị bất thường → hiển thị cảnh báo rõ ràng (theo tinh thần copywriting: nói việc, có đường thoát "Liên hệ HR") và có thể chặn chấm công tuỳ cấu hình backend (không hardcode chặn cứng ở client — để backend quyết định qua response, mobile chỉ gửi kèm cờ `isDeviceCompromised: true/false` để backend tự quyết).

## 4. Chống lộ dữ liệu lương qua màn hình

- Bật `screen_protector` (chặn screenshot/screen recording) riêng cho các screen trong `features/payroll/` — không bật toàn app (tránh ảnh hưởng trải nghiệm chụp màn hình các màn khác không nhạy cảm).
- Màn hình chính (Personal Dashboard) có ô lương **mặc định che** (`•••••••• ₫`), người dùng bấm icon mắt để hiện — không tự bật secure flag ở dashboard vì đây không phải màn payroll đầy đủ, chỉ cần che số liệu là đủ theo DESIGN.md.

## 5. Logging & data hygiene

- Không log token, dữ liệu sinh trắc, nội dung phiếu lương ra `logger` dù ở debug mode (xem `docs/coding-rules.md` §5).
- `pretty_dio_logger` tắt hoàn toàn ở build release (`kReleaseMode` check).
- File `.env` thật **không commit** — chỉ commit `.env.example` với key rỗng/placeholder, thêm `.env` vào `.gitignore` ngay từ commit đầu tiên.

## 6. Quyền truy cập thiết bị (permission_handler)

Xin quyền đúng lúc cần (contextual, không xin hết lúc mở app lần đầu):
- Camera: ngay trước khi mở màn Quét khuôn mặt.
- Location: ngay trước lần chấm công đầu tiên, giải thích rõ lý do (dùng cho đối soát vị trí làm việc).
- Notification: xin sau khi user đã thấy giá trị của app (vd sau lần chấm công đầu tiên), không xin ngay ở splash/login.
- Storage/Photos: chỉ khi user chủ động chọn đính kèm ảnh minh chứng cho đơn từ.

## 7. Checklist bảo mật trước khi coi 1 tính năng liên quan là "xong"

- [ ] Token/dữ liệu nhạy cảm không xuất hiện trong log, kể cả debug build.
- [ ] Request payroll có gắn `X-Biometric-Verified` đúng flow.
- [ ] Request chấm công có gửi kèm GPS + BSSID + device fingerprint.
- [ ] Màn payroll có bật secure flag chống screenshot.
- [ ] Không có secret/API key hardcode trong source — mọi thứ qua `.env`.
- [ ] Quyền thiết bị được xin đúng lúc, có giải thích rõ lý do bằng tiếng Việt tự nhiên.
