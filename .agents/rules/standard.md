# 📋 Coding Standards & Quality Guidelines

### 1. Style & Lint Rules
- Follow official **Effective Dart** styling guides (Style, Documentation, Usage, Design).
- Maintain 100% compliance with `analysis_options.yaml` (0 warnings, 0 errors).
- Format all Dart code using standard formatting (`dart format .`).
- Use single quotes for Dart strings unless escaping is needed (`prefer_single_quotes`).

### 2. Clean Code Principles
- **DRY (Don't Repeat Yourself)**: Extract reusable UI components into `src/shared/widgets` and common helper methods into `src/core/utils`.
- **KISS (Keep It Simple, Stupid)**: Avoid over-engineering abstraction layers before there are concrete multiple implementations.
- **Small & Focused Functions**: Functions should do one thing well and fit within a single screen view.

### 3. Logging & Debugging
- **Never use `print()`** in production code. Use `debugPrint()`, `developer.log()`, or a dedicated logging service.
- Strip or disable sensitive data logging (auth tokens, user PII, API secret keys) in release builds.

### 4. Documentation Standards
- Write `///` doc comments for all public classes, methods, top-level functions, and enums.
- Document the "why" and non-obvious design decisions rather than just repeating the code signature.

### 5. Accessibility (a11y) & UX Standards
- Ensure touch targets meet the minimum recommended size (at least 48x48 logical pixels).
- Maintain readable contrast ratios across light and dark color schemes.
- Provide `Semantics` labels and tooltips for icon-only action buttons.
- Ensure all input fields have clear validation feedback and error states.

### 6. Git & Version Control Hygiene
- Atomic commits with clear conventional commit messages: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`.
- Update `TASK.md` and `things-to-avoid.md` as work progresses.
