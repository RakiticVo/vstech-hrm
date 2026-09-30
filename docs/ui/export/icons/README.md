# Bộ icon HRM

Lưới 24×24 · nét 2px · đầu nét tròn · màu `currentColor` (đổi màu bằng thuộc tính color / tint).

- `outline/`: bản nét, dùng cho mọi chỗ.
- `filled/`: bản đặc cho tab đang chọn ở thanh điều hướng đáy (home, attendance, requests, payroll, profile, approvals).

Kích thước khuyến nghị: 20px trong nút và dòng danh sách, 24px ở thanh điều hướng, 17–18px trong chip.
Màu: phụ trợ `#5B6572`, chính `#0F766E` (sáng) / `#2DD4BF` (tối).

Flutter: dùng gói `flutter_svg` → `SvgPicture.asset('assets/icons/outline/home.svg', colorFilter: ColorFilter.mode(color, BlendMode.srcIn))`.

Nguồn: hình nét dựa trên Lucide (giấy phép ISC, dùng thương mại tự do, giữ ghi chú giấy phép). Bản đặc vẽ riêng cho dự án.

| Tên file | Tiếng Việt | English | Nhóm | Bản đặc |
|---|---|---|---|---|
| `home` | Trang chủ | Home | Điều hướng | có
| `attendance` | Chấm công | Attendance | Điều hướng | có
| `requests` | Yêu cầu | Requests | Điều hướng | có
| `payroll` | Lương | Payroll | Điều hướng | có
| `profile` | Cá nhân | Profile | Điều hướng | có
| `approvals` | Phê duyệt | Approvals | Điều hướng | có
| `services` | Tất cả dịch vụ | All services | Điều hướng |
| `bell` | Thông báo | Notifications | Điều hướng |
| `search` | Tìm kiếm | Search | Điều hướng |
| `back` | Quay lại | Back | Điều hướng |
| `chevron-right` | Mở | Chevron right | Điều hướng |
| `chevron-down` | Mở rộng | Chevron down | Điều hướng |
| `plus` | Thêm | Add | Điều hướng |
| `close` | Đóng | Close | Điều hướng |
| `check` | Xong | Check | Điều hướng |
| `more` | Thêm tuỳ chọn | More | Điều hướng |
| `filter` | Lọc | Filter | Điều hướng |
| `face-scan` | Quét khuôn mặt | Face scan | Chấm công & ca làm |
| `check-in` | Chấm công vào | Check in | Chấm công & ca làm |
| `check-out` | Chấm công ra | Check out | Chấm công & ca làm |
| `location` | Vị trí GPS | GPS location | Chấm công & ca làm |
| `wifi` | Wi-Fi | Wi-Fi | Chấm công & ca làm |
| `offline` | Mất mạng | Offline | Chấm công & ca làm |
| `sync` | Đồng bộ | Sync | Chấm công & ca làm |
| `calendar` | Lịch công | Calendar | Chấm công & ca làm |
| `shift` | Lịch ca | Shift schedule | Chấm công & ca làm |
| `shift-swap` | Đổi ca | Shift swap | Chấm công & ca làm |
| `holiday` | Ngày lễ | Holidays | Chấm công & ca làm |
| `late` | Đi muộn | Late | Chấm công & ca làm |
| `leave` | Nghỉ phép | Leave | Đơn từ & phê duyệt |
| `overtime` | Tăng ca | Overtime | Đơn từ & phê duyệt |
| `correction` | Sửa công | Correction | Đơn từ & phê duyệt |
| `dispute` | Khiếu nại lương | Salary dispute | Đơn từ & phê duyệt |
| `approve` | Duyệt | Approve | Đơn từ & phê duyệt |
| `reject` | Từ chối | Reject | Đơn từ & phê duyệt |
| `pending` | Chờ duyệt | Pending | Đơn từ & phê duyệt |
| `attach` | Đính kèm | Attach | Đơn từ & phê duyệt |
| `camera` | Chụp ảnh | Camera | Đơn từ & phê duyệt |
| `comment` | Ý kiến | Comment | Đơn từ & phê duyệt |
| `payslip` | Phiếu lương | Payslip | Lương & thưởng |
| `lock` | Khoá | Lock | Lương & thưởng |
| `fingerprint` | Vân tay | Fingerprint | Lương & thưởng |
| `sign` | Ký điện tử | E-sign | Lương & thưởng |
| `download` | Tải xuống | Download | Lương & thưởng |
| `bonus` | Thưởng | Bonus | Lương & thưởng |
| `commission` | Hoa hồng | Commission | Lương & thưởng |
| `target` | Chỉ tiêu | Target | Lương & thưởng |
| `coin` | Tiền | Money | Lương & thưởng |
| `jobs` | Tuyển dụng nội bộ | Internal jobs | Tuyển dụng & hội nhập |
| `refer` | Giới thiệu ứng viên | Refer | Tuyển dụng & hội nhập |
| `qr` | Mã QR | QR code | Tuyển dụng & hội nhập |
| `share` | Chia sẻ | Share | Tuyển dụng & hội nhập |
| `onboarding` | Hội nhập | Onboarding | Tuyển dụng & hội nhập |
| `org-chart` | Sơ đồ tổ chức | Org chart | Tuyển dụng & hội nhập |
| `checklist` | Việc cần làm | Checklist | Tuyển dụng & hội nhập |
| `mentor` | Người hướng dẫn | Mentor | Tuyển dụng & hội nhập |
| `documents` | Hồ sơ & tài liệu | Documents | Hồ sơ, bảo mật & hỗ trợ |
| `id-card` | Căn cước | ID card | Hồ sơ, bảo mật & hỗ trợ |
| `dependants` | Người phụ thuộc | Dependants | Hồ sơ, bảo mật & hỗ trợ |
| `device` | Thiết bị | Device | Hồ sơ, bảo mật & hỗ trợ |
| `shield` | Bảo mật | Security | Hồ sơ, bảo mật & hỗ trợ |
| `shield-alert` | Cảnh báo bảo mật | Security alert | Hồ sơ, bảo mật & hỗ trợ |
| `it-support` | Hỗ trợ IT | IT support | Hồ sơ, bảo mật & hỗ trợ |
| `phone` | Gọi điện | Call | Hồ sơ, bảo mật & hỗ trợ |
| `mail` | Email | Email | Hồ sơ, bảo mật & hỗ trợ |
| `settings` | Cài đặt | Settings | Hồ sơ, bảo mật & hỗ trợ |
| `language` | Ngôn ngữ | Language | Hồ sơ, bảo mật & hỗ trợ |
| `dark-mode` | Giao diện tối | Dark mode | Hồ sơ, bảo mật & hỗ trợ |
| `logout` | Đăng xuất | Sign out | Hồ sơ, bảo mật & hỗ trợ |
| `info` | Thông tin | Info | Hồ sơ, bảo mật & hỗ trợ |
| `warning` | Cảnh báo | Warning | Hồ sơ, bảo mật & hỗ trợ |
