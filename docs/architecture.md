# Architecture — Flutter Clean Architecture + BLoC

## 1. Nguyên tắc tổng quát

- **Feature-first**, mỗi feature tự chứa đủ 3 layer (`data` / `domain` / `presentation`) — không tổ chức theo layer-first toàn app (tức không có `lib/blocs/`, `lib/screens/` chung cho mọi feature).
- **Phụ thuộc chỉ đi 1 chiều**: `presentation` → `domain` ← `data`. `domain` không import bất cứ gì từ `data` hay `presentation` (Dependency Inversion — domain định nghĩa abstract repository interface, `data` implement nó).
- Mỗi feature có BLoC/Cubit riêng, không dùng chung state giữa các feature không liên quan. State thật sự cross-feature (phiên đăng nhập, theme, locale) đặt ở `core/`.
- Mọi lỗi trả về dạng `Either<Failure, T>` (fpdart) từ `data` lên `domain` lên `presentation` — presentation chỉ pattern-match `fold()`, không try-catch runtime exception trực tiếp (trừ ở boundary thấp nhất trong datasource, nơi bắt exception của Dio/plugin và convert sang `Failure`).

## 2. Cấu trúc thư mục đầy đủ

```
lib/
  main.dart                     # entrypoint, khởi tạo DI, Firebase, chạy App widget
  app.dart                      # MaterialApp.router, theme, locale, routerConfig

  core/
    constants/
      app_constants.dart
      api_endpoints.dart         # base URL, path templates (đọc từ .env)
    theme/
      app_colors.dart            # màu tokens từ docs/design-system.md
      app_text_styles.dart       # type scale (Source Sans 3)
      app_theme.dart             # ThemeData sáng/tối
      tile_pattern_painter.dart  # CustomPainter hoạ văn gạch bông
    network/
      dio_client.dart            # cấu hình Dio + interceptors
      auth_interceptor.dart      # gắn JWT, refresh token flow
      logging_interceptor.dart   # pretty_dio_logger, chỉ bật ở dev
      mock_dio_interceptor.dart  # nạp JSON mẫu cho chế độ Demo độc lập (USE_MOCK_DATA=true)
    router/
      app_router.dart            # go_router config
      route_guards.dart          # redirect theo role/auth state
      routes.dart                # tên route dạng const
    di/
      injector.dart              # GetIt setup, đăng ký theo feature
    errors/
      failures.dart              # NetworkFailure, ServerFailure, CacheFailure, ValidationFailure...
      exceptions.dart            # exception tầng datasource trước khi convert sang Failure
    widgets/                     # shared widget dùng ≥ 2 feature (PrimaryButton, StatusChip, AppCard...)
    utils/
      date_formatter.dart
      validators/                # validator dùng chung (email, phone, date range) — pure Dart, test độc lập
    session/
      auth_cubit.dart            # global: trạng thái đăng nhập, role hiện tại
      theme_cubit.dart
      locale_cubit.dart

  features/
    auth/
      data/
        datasources/auth_remote_datasource.dart
        models/login_response_model.dart      # freezed
        repositories/auth_repository_impl.dart
      domain/
        entities/user_entity.dart
        repositories/auth_repository.dart      # abstract
        usecases/login_usecase.dart
        usecases/logout_usecase.dart
      presentation/
        bloc/auth_bloc.dart | auth_event.dart | auth_state.dart
        screens/login_screen.dart
        widgets/employee_id_field.dart

    attendance/
      data/ ...
      domain/ ...
      presentation/
        bloc/attendance_cubit.dart
        bloc/face_scan_cubit.dart              # tách riêng cubit cho flow quét khuôn mặt (3 bước, nhiều state hơn)
        screens/attendance_screen.dart
        screens/face_scan_screen.dart
        screens/attendance_history_screen.dart
        screens/timesheet_calendar_screen.dart
        widgets/attendance_donut_chart.dart
        widgets/attendance_balance_card.dart

    leave/                     # gộp: leave balance + apply leave + leave history
    overtime/                  # apply overtime + OT history
    correction/                # regularization (giải trình công)
    requests/                  # request center (tổng hợp) — có thể phụ thuộc đọc dữ liệu leave/overtime/correction qua use case riêng
    approvals/                 # approval inbox (QL)
    payroll/                   # salary overview + payslip + dispute
    incentives/                # bonus / sales commission
    dashboard/                 # personal dashboard tự phục vụ
    notifications/             # notification center + FCM handling
    profile/                   # employee profile 360
    security_settings/         # device binding, đổi mật khẩu, cài đặt bảo mật
    referral/                  # giới thiệu nhân tài (chưa có màn thiết kế — xem screens-mapping.md)
    onboarding/                # pre-onboarding (chưa có màn thiết kế)
    shift_schedule/            # lịch làm việc & ca trực

  l10n/
    app_vi.arb
    app_en.arb
```

**Quy tắc file trong 1 feature**:
- `screens/xxx_screen.dart`: 1 file = 1 màn hình = 1 class widget gốc (thường `StatelessWidget`/`StatefulWidget` implement `build()` lắp ráp các widget con). Nếu build() quá dài, tách phần thành `Widget _buildHeader()` (private method) **chỉ khi đoạn đó không tái sử dụng ở đâu khác**; nếu tái sử dụng hoặc có state riêng → bắt buộc đưa ra `widgets/`.
- `widgets/`: mỗi widget con dùng lại được (hoặc có state riêng) = 1 file riêng, tên file trùng tên class (snake_case).
- `bloc/`: 3 file chuẩn `<feature>_bloc.dart`, `<feature>_event.dart`, `<feature>_state.dart` (nếu dùng Cubit thì chỉ `<feature>_cubit.dart` + `<feature>_state.dart`).
- Giới hạn 300 dòng/file áp dụng cho **mọi** file trên, không ngoại lệ (kể cả file bloc/state).

## 3. Luồng dữ liệu 1 request điển hình (vd: gửi đơn nghỉ phép)

```
LeaveScreen (presentation)
  → LeaveCubit.submitLeave(...)
    → SubmitLeaveUseCase.call(params)           # domain, pure business rule (vd validate quota trước khi gọi)
      → LeaveRepository.submitLeave(...)        # abstract interface (domain)
        → LeaveRepositoryImpl.submitLeave(...)  # data, implement interface
          → LeaveRemoteDataSource.submitLeave()  # gọi Retrofit API client
            → trả Either<Failure, LeaveRequestEntity>
  ← LeaveCubit emit LeaveState (loading → success/failure)
  ← LeaveScreen rebuild theo BlocBuilder/BlocListener
```

## 4. Dependency Injection (GetIt)

- Đăng ký theo từng feature trong file riêng `features/<feature>/<feature>_injection.dart`, gọi tổng hợp từ `core/di/injector.dart`.
- Thứ tự đăng ký: external (Dio, SharedPreferences, FlutterSecureStorage, FirebaseMessaging...) → core (NetworkInfo...) → mỗi feature (datasource → repository → usecase → bloc/cubit dạng `registerFactory` vì bloc/cubit không nên là singleton).
- Repository và datasource đăng ký `registerLazySingleton`.

## 5. Routing (go_router)

- `ShellRoute` bọc bottom nav 5 tab, nav bar đổi label/route theo `AuthCubit.state.role`. Ở Phase 0/MVP, app chỉ hỗ trợ **2 vai trò**: **Nhân viên (NV)** và **Quản lý trực tiếp (QL)** (vai trò BGĐ tạm hoãn ở giai đoạn này, xem [roadmap.md](roadmap.md)).
- `redirect` ở root router check `AuthCubit` để chặn truy cập route cần đăng nhập, và phân quyền màn hình theo vai trò (QL có thêm dải chờ duyệt và tab Phê duyệt `21 approvals`).
- Deep-link từ push notification: mapping loại notification → route name, xử lý trong `NotificationCubit` khi nhận message ở background/terminated (`firebase_messaging` `onMessageOpenedApp` / `getInitialMessage`).

## 5.1 Quản lý Môi trường (Environments)

- Hệ thống chỉ duy trì **2 môi trường**: **`dev`** và **`prod`** (loại bỏ hoàn toàn `staging` để tinh gọn vận hành).
- Hỗ trợ biến `USE_MOCK_DATA=true` (trong `.env.dev`) để kích hoạt chế độ **Demo độc lập**, giúp chạy đầy đủ tính năng và luồng tương tác mà không cần chờ Backend API thật.

## 6. Testing

- Unit test bắt buộc cho: usecase (business rule), bloc/cubit (state transitions), validator.
- Widget test cho: các screen/widget xử lý logic quan trọng (payroll masking, attendance status switch, approval action).
- Không ép coverage %; ưu tiên test đúng nhánh nghiệp vụ quan trọng (lương, chấm công, phê duyệt) theo quyết định đã chốt.
- Dùng `mocktail` để mock repository/usecase trong bloc test — không cần `mockito` + build_runner riêng cho test.

## 7. Vì sao các lựa chọn này (tóm tắt quyết định)

| Quyết định | Lý do |
| --- | --- |
| BLoC/Cubit thay vì Riverpod | Người dùng đã có kinh nghiệm/ưu tiên pattern BLoC truyền thống, tách rõ event/state |
| GetIt thay vì Riverpod DI | Chốt theo yêu cầu người dùng, không dùng Riverpod cho DI |
| go_router | Cần ShellRoute giữ state bottom nav + redirect theo role + hỗ trợ deep-link chính thức, là lựa chọn khuyến nghị của Flutter team |
| Dio + Retrofit | Cần interceptor (JWT, retry, logging) và giảm boilerplate cho hàng chục endpoint của 25 chức năng P0 |
| Freezed + json_serializable | Tự sinh immutable model, copyWith, equality — khớp với Either<Failure, T> pattern |
| fpdart thay dartz | Thư viện functional được cập nhật tích cực hơn, cùng API Either quen thuộc |
| CustomPainter cho hoạ văn gạch bông | Tái tạo chính xác công thức radial-gradient, scale mượt mọi kích thước màn hình, đổi màu theo theme dễ dàng, không cần asset riêng |
