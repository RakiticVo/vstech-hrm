# Coding Rules & Architectural Standards

This document establishes the mandatory architectural and coding conventions for the **vstech-hrm** project. All developers and AI agents must strictly comply with these rules.

---

## 1. Language & Documentation Policy (Strict)

1. **System & Code Files**: All system files, configuration files, rules, markdown documentation (`*.md`), and source code comments **MUST be written in English**.
2. **User Communication**: Team and agent-user communication may be in English or Vietnamese based on user preference, but all repository artifacts, commit messages, and source code files must remain strictly in English.

---

## 2. SOLID Principles in Clean Architecture

- **S — Single Responsibility Principle (SRP)**:
  - Each class and function has only one reason to change.
  - Screen widgets handle layout and listen to state; they **must not** contain business calculation logic.
  - Blocs/Cubits coordinate state and invoke UseCases; they **never** call HTTP clients or DataSources directly.
  - Repository implementations handle datasource calls and exception-to-Failure conversions without embedding business rules.
- **O — Open/Closed Principle (OCP)**:
  - Extend functionality without modifying existing tested code.
  - Use sealed class hierarchies (Freezed unions) for Events, States, and request types.
  - Extend UI styles via `ThemeExtension` (`AppColorsExtension`) rather than conditional branches.
- **L — Liskov Substitution Principle (LSP)**:
  - All repository implementations (including mock/fakes) must honor the exact abstract contract defined in `domain/repositories/` returning `Either<Failure, T>`.
- **I — Interface Segregation Principle (ISP)**:
  - Keep domain repository interfaces focused and cohesive. Avoid monolithic "God repositories".
  - Presentation layers depend only on the specific UseCases they need.
- **D — Dependency Inversion Principle (DIP)**:
  - High-level domain layers never depend on low-level data/presentation layers.
  - All dependencies are registered and resolved via Service Locator (`GetIt`).

---

## 3. Pure Flutter Responsive Architecture (`AppLayout`)

To guarantee seamless visual experiences across compact phones (< 360dp), standard phones (360–414dp), and large phones/tablets (> 414dp), **hardcoded arbitrary pixel widths/heights and paddings are forbidden**.

### 3.1 Device Screen Categories
- **Compact (`DeviceScreenType.compact`)**: Screen width $< 360\text{dp}$ (e.g. iPhone SE, compact Android devices).
- **Normal (`DeviceScreenType.normal`)**: Screen width $360\text{dp} - 414\text{dp}$ (standard modern smartphones).
- **Expanded (`DeviceScreenType.expanded`)**: Screen width $> 414\text{dp}$ (large flagships, foldables, tablets).

### 3.2 Spacing & Sizing Conventions
Use the standardized `AppLayout` helper and `BuildContext` extensions:
```dart
// 1. Spacing gaps:
16.gapH                      // SizedBox(height: 16)
12.gapW                      // SizedBox(width: 12)
context.gapH(16)             // Responsive vertical gap
context.gapHp(5)             // Vertical gap equal to 5% of screen height

// 2. Proportional sizing:
context.wp(90)               // 90% of screen width
context.hp(25)               // 25% of screen height
context.w(30)                // Scaled width based on screen category

// 3. Screen-specific customization (.custom):
context.custom(normal: 16.0, compact: 12.0, expanded: 20.0)

// 4. Responsive Padding:
context.paddingSymmetric(horizontal: 16, vertical: 12)
context.paddingCustom(
  horizontal: context.custom(normal: 16.0, compact: 10.0, expanded: 24.0),
  vertical: 12,
)
```

---

## 4. Zero-Hardcoding Policy (i18n & l10n)

1. **User-Facing Strings**:
   - **Zero hardcoded text strings** in widgets. Every user-visible string must be defined in `lib/l10n/app_vi.arb` (template) and `lib/l10n/app_en.arb`.
   - Access strings concisely via `context.l10n.<key>`.
2. **Numeric Layout Constants**:
   - Do not scatter arbitrary magic numbers. Use `AppLayout`, theme dimensions, or semantic spacing tokens.

---

## 5. File Length & Widget Extraction Limits

1. **Strict 300-Line Limit**: Every `.dart` file must remain **$\le 300$ lines**. No exceptions.
2. **Widget Extraction Threshold**:
   - Reused in $\ge 2$ places $\to$ Must be extracted into a dedicated file under `presentation/widgets/`.
   - Has its own state (`StatefulWidget` or listens to a dedicated bloc/cubit) $\to$ Must be in a separate file.
   - Pure single-use presentation widgets may remain as private helper methods in the screen file only if the total file stays strictly $\le 300$ lines.

---

## 6. Error Handling & Validation

1. **Error Handling**:
   - Datasource catches low-level exceptions (`DioException`, `PlatformException`) and converts them to `Failure`.
   - Domain layer returns `Either<Failure, T>` (fpdart). No unhandled runtime exceptions.
   - Presentation layer maps `Failure` to localized user-friendly messages via `context.l10n`.
2. **Form Validation**:
   - Complex forms use `formz` with 3 validation tiers: Basic (required/format), Date logic, and local conflict checks.
   - Real-time inline validation feedback below each field.

---

## 7. Logging & Security Discipline

1. **No `print()`**: Use `logger` (`PrettyPrinter`) exclusively for application and error logging.
2. **Sensitive Data Protection**: Never log tokens, biometric data, credentials, or payslip details even in debug builds.
3. **Secure Storage**: Tokens and biometrics must always be persisted using `FlutterSecureStorage`.
