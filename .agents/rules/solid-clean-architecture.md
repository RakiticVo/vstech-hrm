# SOLID Principles & Clean Architecture Rules

This document establishes the mandatory architectural boundaries and SOLID standards for the **vstech-hrm** project. All developers and AI agents must strictly comply with these rules.

---

## 1. Clean Architecture Boundaries

### 1.1 Unidirectional Dependency Rule
```
Presentation  ───►  Domain  ◄───  Data
```
- **The Domain Layer is the Core**:
  - Contains `entities`, `repositories` (abstract interfaces), and `usecases`.
  - **Strictly independent pure Dart**: Never import any packages from `data/`, `presentation/`, or external UI/network packages (`dio`, `retrofit`, `flutter/material.dart`, etc.).
  - Entities are pure Dart classes representing domain models with business rules.
- **The Data Layer**:
  - Contains `datasources`, `models` (DTOs), and `repositories` (concrete implementations).
  - Models extend or map to Entities via `toEntity()` / `fromEntity()`. Responsible for JSON serialization (`@freezed`, `json_serializable`).
  - Repository implementations catch datasource exceptions and convert them into `Either<Failure, Entity>`.
- **The Presentation Layer**:
  - Contains `bloc/cubit`, `screens`, and `widgets`.
  - **Never import** directly from `data/` (no direct calls to data sources or DTO models). Interacts strictly with Domain via `UseCase` or `Bloc`.
  - Widgets contain zero business logic; widgets strictly render UI, handle user gestures, and listen to state.

---

## 2. SOLID Standards in Flutter Clean Architecture

### S — Single Responsibility Principle (SRP)
- **1 UseCase = 1 Business Action**: Named in `<Verb><Noun>UseCase` format (e.g., `SubmitLeaveUseCase`, `GetAttendanceHistoryUseCase`). Contains exactly one public `call(Params params)` method.
- **Bloc / Cubit**: Coordinates state transitions and invokes UseCases. Does not perform data transformations or raw HTTP calls.
- **Screen**: Handles layout structure, responsiveness, and user interactions.
- **Widget Extraction**:
  - Reused in $\ge 2$ places OR contains internal state $\to$ Must be extracted into `presentation/widgets/`.
  - Strict ceiling: **$\le 300$ lines per file**.

### O — Open/Closed Principle (OCP)
- Use **Freezed Sealed Unions** for Events, States, and business discriminators (e.g., `RequestStatus`, `LeaveType`). New types can be introduced without breaking existing code.
- Extend UI styles via `ThemeExtension` (`AppColorsExtension`) rather than hardcoded conditional branches.

### L — Liskov Substitution Principle (LSP)
- All repository implementations (including mock/fake implementations in tests) must honor the exact abstract contract defined in `domain/repositories/` without altering expected return types `Either<Failure, T>`.

### I — Interface Segregation Principle (ISP)
- Never create "God Repositories" combining unrelated features. Each feature owns its dedicated abstract repository.
- Presentation components only receive the specific UseCases they need.

### D — Dependency Inversion Principle (DIP)
- Presentation and Data layers both depend on abstractions defined in the Domain layer.
- All dependencies are managed and resolved via `GetIt` (`injector.dart`), registered as lazy singletons for services/repositories/usecases and factories for blocs/cubits.

---

## 3. Pre-Completion Quality Checklist

Before considering any task or feature complete, verify:
- [ ] Are all system files, markdown files, and code comments in **English**?
- [ ] Is every touched or newly created file **$\le 300$ lines**?
- [ ] Is the `domain` layer completely free from imports of `data/` or external UI/network packages?
- [ ] Does the `presentation` layer avoid direct calls to `data/` or DTO models?
- [ ] Are all UI strings localized via `AppLocalizations` (`context.l10n`) without hardcoded text?
- [ ] Are sizing and spacing responsive via `AppLayout` (`context.w()`, `context.wp()`, `context.gapH()`, `context.custom()`)?
- [ ] Are there **zero `print()` calls**, with all logging routed through `logger`?
- [ ] Do all tests pass (`flutter test`) and analysis reports zero issues (`flutter analyze`)?
