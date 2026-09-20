# Quy tắc SOLID & Clean Architecture (Bắt buộc cho mọi Agent)

Tài liệu này là quy chuẩn bắt buộc áp dụng khi viết mã nguồn Dart/Flutter trong dự án **vstech-hrm**. Mọi agent phải tuân thủ nghiêm ngặt các nguyên tắc dưới đây.

---

## 1. Ranh giới Clean Architecture (Architectural Boundaries)

### 1.1 Nguyên tắc phụ thuộc 1 chiều (Dependency Rule)
```
Presentation  ───►  Domain  ◄───  Data
```
- **Tầng Domain là trung tâm**:
  - Chứa `entities`, `repositories` (abstract interface), `usecases`.
  - **Tuyệt đối không import** bất kỳ package nào từ `data/`, `presentation/`, hoặc thư viện ngoài liên quan đến network/UI (`dio`, `retrofit`, `flutter/material.dart`...).
  - Entity là pure Dart class (chỉ chứa dữ liệu và logic nghiệp vụ thuần tuý, không chứa `fromJson`/`toJson`).
- **Tầng Data**:
  - Chứa `datasources`, `models` (DTO), `repositories` (implementation).
  - Model kế thừa hoặc map sang Entity qua hàm `toEntity()` và `fromEntity()`. Model chịu trách nhiệm serialize/deserialize JSON (`@freezed`, `json_serializable`).
  - Repository Implementation bắt toàn bộ ngoại lệ từ datasource và chuyển đổi sang `Either<Failure, Entity>`.
- **Tầng Presentation**:
  - Chứa `bloc/cubit`, `screens`, `widgets`.
  - **Tuyệt đối không import** trực tiếp class từ `data/` (không gọi trực tiếp DataSource hay Model DTO). Chỉ tương tác với Domain qua `UseCase` hoặc `Bloc`.
  - Không chứa logic nghiệp vụ tính toán trong Widget; Widget chỉ render UI và lắng nghe State.

---

## 2. Chuẩn SOLID trong Flutter Clean Architecture

### S — Single Responsibility Principle (Đơn trách nhiệm)
- **1 Usecase = 1 Hành động nghiệp vụ**: Đặt tên dạng `<Verb><Noun>UseCase` (vd: `SubmitLeaveUseCase`, `GetAttendanceHistoryUseCase`). Chỉ có 1 method public `call(Params params)`.
- **Bloc/Cubit**: Chỉ điều phối state và gọi Usecase; không chứa logic biến đổi dữ liệu phức tạp, không gọi HTTP client trực tiếp.
- **Screen**: Chỉ lo bố cục giao diện và bắt sự kiện người dùng.
- **Tách Widget con**:
  - Dùng ở ≥ 2 nơi HOẶC có state riêng → bắt buộc tách file riêng trong `presentation/widgets/`.
  - Giới hạn cứng: **≤ 300 dòng/file**, không có ngoại lệ.

### O — Open/Closed Principle (Mở rộng thay vì sửa đổi)
- Dùng **Freezed Sealed Unions** cho `Event`, `State`, và các phân loại nghiệp vụ (vd: trạng thái đơn từ `RequestStatus`, loại nghỉ `LeaveType`). Khi thêm loại mới, chỉ cần khai báo thêm factory mà không làm vỡ code cũ.
- Giao diện mở rộng theme qua `ThemeExtension` (`AppColorsExtension`), không dùng chuỗi điều kiện `if (isDark)`.

### L — Liskov Substitution Principle (Thay thế tương đương)
- Các bản implementation của repository (kể cả `MockLeaveRepository` hay `LeaveRepositoryImpl`) phải tuân thủ chính xác contract định nghĩa ở `domain/repositories/` mà không làm thay đổi kỳ vọng về kiểu trả về `Either<Failure, T>`.

### I — Interface Segregation Principle (Phân tách giao diện)
- Không tạo God Repository (không gộp chung Chấm công, Nghỉ phép, Lương vào 1 interface lớn). Mỗi feature sở hữu abstract repository riêng biệt.
- Presentation chỉ nhận Usecase mà nó thực sự cần, không nhận toàn bộ Repository to lớn.

### D — Dependency Inversion Principle (Đảo ngược phụ thuộc)
- Tầng Presentation và Data đều phụ thuộc vào abstraction (interface ở Domain).
- Mọi dependency được khởi tạo và cung cấp qua Service Locator `GetIt` (`injector.dart`), đăng ký dạng lazy singleton cho datasource/repository/usecase và factory cho bloc/cubit.

---

## 3. Checklist tự kiểm tra trước khi hoàn thành code

- [ ] File mới tạo có dưới 300 dòng không?
- [ ] Tầng `domain` có bị lọt import từ `data/` hay thư viện ngoài không?
- [ ] Tầng `presentation` có gọi thẳng `data/` hay model DTO thay vì Entity không?
- [ ] Usecase có trả về `Either<Failure, Entity>` không?
- [ ] Form nhập liệu có dùng `formz` với 3 lớp validate không?
- [ ] Không có `print()`, mọi log đều dùng `logger`?
