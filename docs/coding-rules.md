# Coding Rules

## 1. SOLID — áp dụng cụ thể vào Flutter Clean Architecture

- **S — Single Responsibility**: 1 class/function chỉ có 1 lý do để thay đổi.
  - Screen widget chỉ lo layout + lắng nghe bloc/cubit, **không** chứa business logic (tính toán ngày phép, format tiền tệ phức tạp...) — logic đó thuộc usecase hoặc pure function trong `core/utils/`.
  - Bloc/Cubit chỉ điều phối state, gọi usecase — **không** tự gọi Dio/datasource trực tiếp.
  - Repository implementation chỉ lo convert exception → Failure và gọi datasource — **không** chứa business rule (vd validate quota phép thuộc usecase, không thuộc repository).
- **O — Open/Closed**: thêm loại đơn từ mới (vd thêm "Đơn công tác" ở P1) không sửa code xử lý đơn nghỉ phép hiện có — dùng abstract `RequestType` hoặc sealed class (Freezed union) để mở rộng.
- **L — Liskov Substitution**: mọi implementation của 1 abstract repository phải thay thế được cho nhau mà không phá vỡ hành vi gọi phía trên (vd `FakeLeaveRepository` dùng trong test phải tuân đúng contract như `LeaveRepositoryImpl`).
- **I — Interface Segregation**: interface repository nhỏ, theo đúng nhu cầu 1 feature — không gộp 1 "God repository" cho nhiều feature không liên quan (vd không gộp `LeaveRepository` và `PayrollRepository` làm 1).
- **D — Dependency Inversion**: `domain` định nghĩa abstract repository; `presentation` và `data` đều phụ thuộc vào abstraction đó qua GetIt, không phụ thuộc trực tiếp implementation cụ thể. Không import class trong `data/` từ `presentation/`.

## 2. Quy tắc file & tách widget (bắt buộc)

1. **Giới hạn 300 dòng/file** — áp dụng mọi file `.dart` (screen, widget, bloc, state, repository...). Vượt quá → bắt buộc tách, không có ngoại lệ vì "code đang chạy tốt".
2. **Ngưỡng tách widget con ra file riêng**:
   - Dùng ở **≥ 2 nơi** → bắt buộc file riêng trong `presentation/widgets/`.
   - Có **state riêng** (StatefulWidget, hoặc lắng nghe bloc/cubit riêng của chính nó) → bắt buộc file riêng, kể cả chỉ dùng 1 lần.
   - Chỉ hiển thị thuần (StatelessWidget không state, không lắng nghe bloc riêng) và **chỉ dùng đúng 1 lần trong đúng 1 màn** → được phép giữ làm private method `Widget _buildXxx(BuildContext context)` ngay trong file màn hình đó, miễn tổng file vẫn ≤ 300 dòng.
3. **Không giới hạn cứng số lượng function/method trong 1 file** — chỉ cần mỗi function đảm nhiệm đúng 1 việc (SRP) và tổng file tuân thủ luật #1.
4. Đặt tên file trùng tên class chính, `snake_case.dart` (vd class `AttendanceDonutChart` → `attendance_donut_chart.dart`).
5. Enforcement: **chỉ ghi rõ rule trong CLAUDE.md/skill để Claude Code tự tuân thủ** khi viết code mới — không setup `custom_lint` riêng cho việc này (CI hiện tại chỉ chạy `flutter analyze` theo bộ `very_good_analysis` mặc định).

## 3. Error handling

- Tầng `datasource`: bắt exception cụ thể (`DioException`, `PlatformException`...) và convert ngay sang `Failure` phù hợp (`NetworkFailure`, `ServerFailure(code, message)`, `CacheFailure`...). Không để exception thô lọt lên `repository`.
- Tầng `repository`/`usecase`: trả `Either<Failure, T>` (fpdart). Không throw.
- Tầng `presentation`: `result.fold(onLeft: (failure) => emit state lỗi, onRight: (data) => emit state thành công)`. Không try-catch runtime ở đây trừ lỗi lập trình thật sự bất ngờ (assertion).
- Message lỗi hiển thị ra UI phải qua bước map `Failure` → chuỗi tiếng Việt tự nhiên (theo tinh thần copywriting ở `docs/design-system.md` §11), không hiển thị message kỹ thuật thô từ backend.

## 4. Validation (formz)

- Mỗi field nhập liệu quan trọng = 1 `FormzInput<Value, Error>` riêng (vd `LeaveReasonInput`, `DateRangeInput`).
- 3 lớp validate theo đúng quyết định đã chốt:
  1. **Cơ bản**: required, định dạng (email/SĐT nếu có), độ dài ký tự — validate ngay trong `FormzInput.validator`.
  2. **Logic ngày tháng**: ngày kết thúc ≥ ngày bắt đầu, không chọn ngày quá khứ cho nghỉ phép/tăng ca — validate ở tầng `FormzInput` hoặc 1 pure validator riêng trong `core/utils/validators/` để test độc lập.
  3. **Cảnh báo trùng lịch**: đối chiếu với dữ liệu **đã cache local** (vd danh sách nghỉ phép đã duyệt đang giữ trong bloc/repository cache) — hiển thị cảnh báo ngay, không chờ round-trip API. Vẫn gọi API `/leave/conflicts` khi submit thật để backend xác nhận lại (nguồn tin cậy cuối cùng).
  4. Logic nghiệp vụ phức tạp hơn (vd tổng OT vượt trần tháng, ngân sách phòng ban) — **không** cố validate ở client, để backend trả lỗi qua `errorCode` và hiển thị message tương ứng.
- Hiển thị lỗi: **inline, real-time** ngay dưới field khi user rời field (`onChanged` debounce ~300ms hoặc `onFocusLost`) — không đợi bấm Submit mới hiện toàn bộ lỗi.
- Nút Submit chỉ enable khi toàn bộ `FormzInput` liên quan ở trạng thái `valid` (dùng `Formz.validate([...])`).

## 5. Logging

- Dùng `logger` (cấu hình `PrettyPrinter`) cho mọi log nghiệp vụ/lỗi/lifecycle — cấm dùng `print()` (bật lint rule `avoid_print` nếu `very_good_analysis` chưa bật sẵn).
- Dùng `pretty_dio_logger` làm interceptor riêng cho Dio, chỉ bật khi `kDebugMode` hoặc `Env.current == Environment.dev` — tắt hoàn toàn ở build release để tránh lộ dữ liệu nhạy cảm qua log.
- **Không bao giờ log** access token, refresh token, dữ liệu sinh trắc, hoặc nội dung phiếu lương ra logger dù ở debug mode.

## 6. Naming convention

- File: `snake_case.dart`. Class: `PascalCase`. Biến/hàm: `camelCase`. Hằng số: `camelCase` (theo chuẩn Dart, không `SCREAMING_CASE`) trừ khi là giá trị enum-like ở `core/constants/`.
- Bloc event: `<Feature><Action>Event` hoặc dùng sealed class (Freezed) `<Feature>Event` với factory con. Bloc state: tương tự `<Feature>State`.
- Route name: `const` string đặt trong `core/router/routes.dart`, không hardcode string path rải rác trong widget.
