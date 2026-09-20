---
name: new-feature
description: Scaffold một feature module mới cho vstech-hrm đúng theo Clean Architecture (data/domain/presentation) + BLoC/Cubit đã chốt trong docs/architecture.md. Dùng khi bắt đầu code 1 chức năng P0 mới chưa có thư mục trong lib/features/.
---

# Scaffold feature mới

Đọc `AGENTS.md` và `docs/architecture.md` trước khi chạy skill này nếu chưa đọc trong phiên hiện tại.

## Input cần hỏi người dùng nếu chưa rõ

1. Tên feature (snake_case, vd `leave`, `overtime`, `payroll`) — tra `docs/prd.md` để map đúng số thứ tự chức năng P0.
2. Dùng Bloc (event/state) hay Cubit (chỉ state) — mặc định Cubit cho flow đơn giản (CRUD 1 chiều), Bloc khi có nhiều event phức tạp/nhiều nguồn trigger (vd `face_scan` có luồng 3 bước, camera stream, timer).
3. Feature này có phụ thuộc đọc dữ liệu từ feature khác không (vd `requests` đọc từ `leave`/`overtime`/`correction`) — nếu có, dùng usecase riêng gọi qua abstract repository của feature kia, không import thẳng data layer của feature kia.

## Cấu trúc phải tạo (theo docs/architecture.md §2)

```
lib/features/<feature>/
  data/
    datasources/<feature>_remote_datasource.dart
    models/<feature>_model.dart          # @freezed, có fromJson/toJson
    repositories/<feature>_repository_impl.dart
  domain/
    entities/<feature>_entity.dart       # @freezed, KHÔNG có fromJson/toJson (domain không biết JSON)
    repositories/<feature>_repository.dart   # abstract class, method trả Future<Either<Failure, T>>
    usecases/<use_case_name>_usecase.dart    # 1 usecase = 1 hành động nghiệp vụ, có class Params riêng nếu >1 tham số
  presentation/
    bloc/<feature>_cubit.dart (hoặc _bloc.dart + _event.dart) + <feature>_state.dart
    screens/<feature>_screen.dart
    widgets/                              # tạo trống, chỉ thêm khi thật sự cần tách theo docs/coding-rules.md
  <feature>_injection.dart                # đăng ký GetIt cho riêng feature này
```

## Checklist khi scaffold xong

- [ ] Repository interface (`domain/repositories/`) không import bất cứ gì từ `dio`/`retrofit`/package network — chỉ khai báo method trả `Either<Failure, Entity>`.
- [ ] Model (`data/models/`) và Entity (`domain/entities/`) là 2 class riêng biệt (không dùng chung 1 class cho cả 2 tầng), có mapper `toEntity()` trong model.
- [ ] `<feature>_injection.dart` đăng ký đủ: datasource (`registerLazySingleton`) → repository (`registerLazySingleton`) → usecase (`registerLazySingleton`) → bloc/cubit (`registerFactory`).
- [ ] Gọi hàm đăng ký feature này từ `core/di/injector.dart`.
- [ ] Thêm route trong `core/router/routes.dart` + `core/router/app_router.dart` nếu có screen mới.
- [ ] Đối chiếu `docs/screens-mapping.md` xem feature này có sẵn màn thiết kế hay thuộc nhóm "chưa có màn hình thiết kế" — nếu thuộc nhóm sau, hỏi người dùng trước khi tự vẽ UI.
- [ ] Không file nào vượt 300 dòng (`docs/coding-rules.md` §2).
- [ ] Validate form (nếu có) dùng `formz`, theo 3 lớp validate đã chốt ở `docs/coding-rules.md` §4.
