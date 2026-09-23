# vstech-hrm — Canonical Agent Context

> This file is the canonical context source for any AI coding agent working on this repository — Antigravity, Claude Code, ChatGPT/Codex, Cursor, Copilot, OpenCode, Aider, etc. Read this file before undertaking any task. Deeper architectural and operational details are documented in `docs/*.md`.
>
> Remote repository: https://github.com/RakiticVo/vstech-hrm. All agents must strictly comply with the architectural rules and conventions specified here and in `docs/`.

---

## 0. Mandatory Rules & Discipline (Non-Negotiable)

1. **Language Policy**:
   - All system files, configuration files, rules, markdown documentation (`*.md`), and source code comments **MUST be written in English**.
   - User interaction and chat communication may be in English or Vietnamese based on user preference, but all repository files, commit messages, and artifacts must remain strictly in English.
2. **Clean Architecture & SOLID**:
   - Strict unidirectional dependency: `presentation → domain ← data`.
   - The `domain` layer is pure Dart (strictly no imports from `data/`, `presentation/`, or external UI/network packages).
   - `1 UseCase = 1 Business Action`.
   - Dependencies resolved via `GetIt` (`injector.dart`).
   - Sealed class hierarchies via Freezed unions for Events, States, and union models.
3. **Zero-Hardcoding Policy (i18n & l10n)**:
   - **No hardcoded text strings** in UI widgets. All strings must be defined in `lib/l10n/app_vi.arb` and `lib/l10n/app_en.arb`, accessed via `context.l10n.<key>`.
   - No magic numeric layout constants. All sizing must use `AppLayout` or theme tokens.
4. **Pure Flutter Responsive Design (`AppLayout`)**:
   - All screens and widgets must adapt responsively across Compact (< 360dp, e.g. iPhone SE), Normal (360–414dp), and Expanded (> 414dp) screens.
   - Use `AppLayout` utilities (`context.w()`, `context.wp()`, `context.h()`, `context.hp()`, `context.custom()`, `AppGap`).
5. **Strict File Size Ceiling**:
   - **Maximum 300 lines per `.dart` file**. No exceptions. Extract subwidgets and helpers whenever a file approaches 250 lines.
6. **Logging & Security**:
   - **No `print()`**: Use `logger` (`PrettyPrinter`) exclusively.
   - Never log tokens, biometric vectors, or payslip details. Sensitive data must be persisted via `FlutterSecureStorage`.

---

## 1. Product Overview

B2B SaaS HRM mobile application, specifically the **Employee App** module serving employees (NV / ESS) and direct managers (QL / MSS) on Android and iOS. The core business revolves around 4 pillars: **Recruitment – Time & Attendance – Payroll – Rewards**.

- **Phase Scope**: Core P0 features, including **Offline Check-in Queue** (with on-device 128-D vector matching $\ge 85\%$) and **Shift Scheduling** (7-day week capsules, shift swap, overtime request, and month grid).
- **Target Roles**: 
  - **Employee (NV / ESS)**: Punch in/out, shift schedule, leave/overtime/correction requests, payslips, profile.
  - **Manager (QL / MSS)**: Additional approval strip on Home, "Approvals" bottom navigation tab with pending request badges, 1-touch approve/reject.
- **Approval Workflow**: 4-stage pipeline: `Employee Submits → Direct Manager → HR Confirmation → Director Approval`.
- **UI Design System**: "Saigon Tile" (Gạch bông Sài Gòn) aesthetics using custom Canvas painters (`TilePatternPainter`), deep teal `#0F766E`, amber `#F59E0B`, cream `#FFF8EC`, and Source Sans 3 typography.

---

## 2. Technology Stack

| Category | Selection | Notes |
| :--- | :--- | :--- |
| Framework | Flutter (Dart 3.5+) | Android (minSdk 26) & iOS (14.0+), Portrait only |
| Architecture | Clean Architecture, Feature-First | `lib/core/` and `lib/features/<feature>/` |
| State Management | BLoC / Cubit (`flutter_bloc`) | Feature-scoped Blocs & Cubits |
| Dependency Injection | GetIt | Service locator (`injector.dart`) |
| Routing | `go_router` | Declarative routing with `ShellRoute` & `authRedirectGuard` |
| Networking | `dio` + `retrofit` | JWT auth interceptors, retry, pretty logger |
| Error Handling | `fpdart` | `Either<Failure, T>` across all layers |
| Responsive System | Pure Flutter `AppLayout` | `.w()`, `.wp()`, `.h()`, `.hp()`, `.custom()`, `AppGap` |
| Localization | Flutter `intl` + ARB | Vietnamese (`app_vi.arb`) & English (`app_en.arb`) |
| Biometrics | `local_auth` + `camera` | App login lock & AI Face Scan capture |
| Offline Biometrics | Cosine Similarity ($\ge 85\%$) | 128-D embedding stored via `FlutterSecureStorage` |
| Security | `flutter_secure_storage` + `screen_protector` | Anti-screenshot on payslip screens |
| Testing | `flutter_test`, `bloc_test`, `mocktail` | Pure unit and widget testing |

---

## 3. Directory Layout

```
lib/
  core/
    di/              # GetIt injector
    errors/          # Failure & AppException classes
    extensions/      # l10n and utility extensions
    network/         # Dio client & interceptors
    responsive/      # AppLayout, responsive extensions & gap helpers
    router/          # GoRouter, AppShell, AppRoutes, guards
    services/        # OfflineAttendanceService, permissions
    session/         # AuthCubit, UserSession, LocaleCubit, ThemeCubit
    theme/           # AppColorsExtension, AppTextStyles, TilePatternPainter
    widgets/         # Shared core widgets (TileHeaderBanner, AmberCtaButton, etc.)
  features/
    <feature>/
      data/          # datasources, models (DTOs), repository implementations
      domain/        # entities, repository interfaces, usecases
      presentation/  # bloc/cubit, screens (<=300 lines), widgets (<=300 lines)
  l10n/              # app_vi.arb, app_en.arb (generated via flutter gen-l10n)
test/                # Mirrors lib/ structure with unit and bloc tests
```

---

## 4. Work Session Kickoff Checklist

When starting a session or receiving a new task:
1. Verify `git status` and ensure the working tree is clean.
2. Confirm the active branch adheres to GitFlow (`feature/<scope>-<description>`).
3. Check code health via `flutter analyze` and `flutter test`.
4. Ensure any new file adheres to the $\le 300$ lines rule, zero-hardcoding policy, and English documentation standards.
