# Bảng Quy hoạch Thư viện (Dependencies Matrix) theo Clean Architecture

Tài liệu này chuẩn hoá toàn bộ thư viện sử dụng trong dự án **vstech-hrm**, phân loại chặt chẽ theo các tầng của Clean Architecture và nguyên tắc SOLID.

---

## 1. Phân loại Thư viện theo Tầng Kiến trúc

### 1.1 Tầng Domain (Nghiệp vụ Cốt lõi — Pure Dart)
> **Nguyên tắc**: Tầng Domain độc lập 100% với Flutter framework và các dịch vụ bên ngoài. Tuyệt đối không import thư viện UI hay Network vào đây.

| Thư viện | Mục đích | Lý do lựa chọn theo SOLID |
| --- | --- | --- |
| `fpdart` | `Either<Failure, T>`, `Option`, `fold()` | Xử lý lỗi functional xuyên suốt, không throw exception runtime, đảm bảo Type Safety. |
| `equatable` | So sánh giá trị Entity | So sánh theo thuộc tính (value equality) mà không cần phụ thuộc code generation ở tầng Domain. |

### 1.2 Tầng Data (Truy xuất Dữ liệu, Network, Serialization)
> **Nguyên tắc**: Chịu trách nhiệm giao tiếp với nguồn dữ liệu ngoài (REST API, Local Cache, Secure Storage) và map sang Domain Entity.

| Thư viện | Mục đích | Vai trò kiến trúc |
| --- | --- | --- |
| `dio` | HTTP Client | Quản lý request/response, gắn Interceptors (Auth, Retry, Logging, Mock). |
| `retrofit` | Type-safe REST Client | Định nghĩa API interface rõ ràng, sinh code client tự động. |
| `freezed_annotation` | Annotation cho Model DTO | Khai báo immutable Data Transfer Objects (DTO). |
| `json_annotation` | Annotation cho JSON Serialization | Cung cấp metadata để sinh hàm `fromJson` / `toJson`. |
| `flutter_secure_storage` | Lưu trữ an toàn (Keychain / Keystore) | Lưu trữ JWT Access Token, Refresh Token, mã PIN mã hoá (không dùng SharedPreferences cho dữ liệu nhạy cảm). |
| `path_provider` | Quản lý thư mục hệ thống | Lưu trữ cache tệp đính kèm và ảnh minh chứng. |

### 1.3 Tầng Presentation (Giao diện & Quản lý Trạng thái)
> **Nguyên tắc**: Chỉ hiển thị giao diện và lắng nghe state từ BLoC; không chứa logic nghiệp vụ tính toán.

| Thư viện | Mục đích | Vai trò kiến trúc |
| --- | --- | --- |
| `flutter_bloc` | State Management (BLoC/Cubit) | Tách biệt hoàn toàn UI và State. Mỗi feature có BLoC/Cubit riêng biệt (Single Responsibility). |
| `go_router` | Điều hướng & Routing | `ShellRoute` quản lý bottom nav 5 tab, route guards phân quyền theo vai trò (NV, QL), hỗ trợ deep-link. |
| `formz` | Form Validation | Chuẩn hoá 3 lớp validate: cơ bản, logic ngày tháng, cảnh báo trùng lịch; hiển thị lỗi inline real-time. |
| `google_fonts` | Typography (Source Sans 3) | Tải và áp dụng font Source Sans 3 đồng bộ toàn app. |
| `material_symbols_icons` | Icon Set đồng nhất | Sử dụng bộ icon Material Symbols thay thế Lucide ban đầu. |

### 1.4 Tầng Core, Hạ tầng Kỹ thuật & Quyền Thiết bị
> **Nguyên tắc**: Cung cấp tiện ích dùng chung, dịch vụ bảo mật và giao tiếp với phần cứng thiết bị.

| Thư viện | Mục đích | Vai trò bảo mật & vận hành |
| --- | --- | --- |
| `get_it` | Dependency Injection (DI) | Service Locator đăng ký phụ thuộc theo nguyên tắc Dependency Inversion. |
| `flutter_dotenv` | Quản lý biến môi trường | Đọc cấu hình từ `.env` cho 2 môi trường: `dev` và `prod`. |
| `logger` | Logging có cấu trúc | Ghi log chuyên nghiệp với PrettyPrinter; tuyệt đối không dùng `print()`. |
| `pretty_dio_logger` | HTTP Traffic Logger | Ghi log chi tiết request/response mạng (chỉ bật ở `dev`). |
| `local_auth` | Sinh trắc học cục bộ | Xác thực mở khoá app và bảo vệ màn hình Phiếu lương. |
| `camera` | Truy cập Camera | Chụp ảnh/video phục vụ tính năng quét khuôn mặt AI chấm công. |
| `geolocator` | Vị trí địa lý (GPS) | Lấy toạ độ đối soát Geofencing khi chấm công. |
| `network_info_plus` | Thông tin mạng (BSSID) | Lấy BSSID Wi-Fi nội bộ đối soát chấm công hiện trường. |
| `screen_protector` | Chống chụp/quay màn hình | Bật cờ cấm screenshot riêng tại màn Phiếu lương (`15 payslip`). |
| `safe_device` | Phát hiện can thiệp thiết bị | Kiểm tra máy root/jailbreak và Mock Location chống gian lận. |
| `intl` | Quốc tế hoá (i18n) & Định dạng | Hỗ trợ 2 ngôn ngữ (Việt - Anh) và format ngày giờ/tiền tệ. |

### 1.5 Dev Dependencies & Testing
| Thư viện | Mục đích |
| --- | --- |
| `very_good_analysis` | Bộ lint chuẩn nghiêm ngặt nhất cho Flutter (enforce code style, no-print). |
| `build_runner` | Engine thực thi sinh mã nguồn tự động cho Freezed, JsonSerializable, Retrofit. |
| `freezed` | Generator sinh immutable models, `copyWith`, và sealed union states/events. |
| `json_serializable` | Generator sinh hàm serialize/deserialize JSON. |
| `retrofit_generator` | Generator sinh implementation cho Retrofit REST clients. |
| `flutter_test` | Framework kiểm thử unit test và widget test. |
| `bloc_test` | Framework chuyên dụng kiểm thử các bước chuyển đổi trạng thái BLoC/Cubit. |
| `mocktail` | Thư viện mock test hiện đại với type-safety, không cần code generation. |

---

## 2. Ma trận Cho phép Import theo Tầng (Dependency Rules Matrix)

| Tầng gọi \ Tầng được import | Domain | Data | Presentation | Core | Third-party Network / UI |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Domain** | ✅ | ❌ **CẤM** | ❌ **CẤM** | ⚠️ Hạn chế (chỉ Failures) | ❌ **CẤM** (`dio`, `flutter`) |
| **Data** | ✅ (Entity/Repo Interface) | ✅ | ❌ **CẤM** | ✅ (DioClient, Error) | ✅ (`dio`, `retrofit`, `secure_storage`) |
| **Presentation** | ✅ (UseCase, Entity) | ❌ **CẤM** | ✅ | ✅ (Theme, Router, DI) | ✅ (`bloc`, `formz`, `google_fonts`) |
| **Core** | ✅ (Failures) | ⚠️ (Chỉ ở DI root `injector.dart`) | ❌ | ✅ | ✅ (GetIt, Logger) |
