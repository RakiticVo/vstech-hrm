---
name: arch-review
description: Review mã nguồn một feature hoặc PR để đảm bảo tuân thủ 100% Clean Architecture boundaries, SOLID Principles, giới hạn 300 dòng/file và quy tắc tách layer. Dùng khi hoàn thành 1 feature hoặc khi người dùng yêu cầu "review kiến trúc"/"kiểm tra SOLID"/"arch-review".
---

# Architecture & SOLID Review Checklist

Đọc `docs/coding-rules.md` trước khi thực hiện.

## 1. Clean Architecture Boundaries (Ranh giới tầng)

- [ ] **Domain Layer**:
  - Không import bất kỳ thứ gì từ `package:dio`, `package:retrofit`, `package:flutter`, hay thư mục `data/`, `presentation/`.
  - Entity là class pure Dart (không có `fromJson`/`toJson`).
  - Repository là `abstract class`, mọi method trả về `Future<Either<Failure, T>>` hoặc `Stream<Either<Failure, T>>`.
  - Mỗi usecase là 1 class riêng biệt có hàm `call(...)`.
- [ ] **Data Layer**:
  - Model kế thừa hoặc map sang Entity qua `toEntity()`.
  - RepositoryImpl bắt toàn bộ exception của datasource/network và chuyển thành `Failure`.
  - Không đưa logic nghiệp vụ tính toán vào RepositoryImpl.
- [ ] **Presentation Layer**:
  - Không import bất kỳ class nào từ `features/<feature>/data/`.
  - Mọi tương tác nghiệp vụ đều thông qua `UseCase` hoặc `Bloc/Cubit`.
  - Widget không chứa logic tính toán nghiệp vụ phức tạp.

## 2. SOLID Principles

- [ ] **S (Single Responsibility)**: Mỗi file, class, method chỉ làm 1 việc duy nhất.
- [ ] **O (Open/Closed)**: Dùng Freezed union cho State/Event/Status để dễ mở rộng.
- [ ] **L (Liskov Substitution)**: Mock repository và Real repository đều implement đúng interface.
- [ ] **I (Interface Segregation)**: Không có God Interface; interface chỉ chứa các method cần thiết.
- [ ] **D (Dependency Inversion)**: Đăng ký GetIt đầy đủ, không khởi tạo trực tiếp implementation cụ thể bên trong UI hay domain.

## 3. Code Quality & Limit Enforcement

- [ ] Không có file nào vượt quá **300 dòng**.
- [ ] Widget con dùng ≥ 2 nơi hoặc có state riêng đã được tách file riêng.
- [ ] Không có lệnh `print()`, mọi log đều qua `logger`.
- [ ] Không hardcode secret, token hay API URL trong source code.
