# 🚫 Things to Avoid (Anti-Patterns & Pitfalls)

### 1. Architecture & File Sizing Anti-Patterns
- **Files > 500 lines**: Strictly forbidden. Always decompose large files into dedicated sub-widgets, helper classes, or state notifiers.
- **God Widgets / Giant Build Methods**: Do not write 300+ line `build()` methods. Break complex UI into separate `StatelessWidget` / `StatefulWidget` files or extracted widgets.
- **Business Logic in UI**: Never place API calls, database operations, or complex data transformations directly inside widgets.
- **Global Mutable State**: Never use global mutable variables or singleton instances that hold volatile state across the app.

### 2. Flutter & Dart Specific Mistakes
- **Async Context Leaks**: Never use `BuildContext` across an `await` without verifying `if (!context.mounted) return;`.
- **Unbounded Layout Errors**: Never place unconstrained scrollable widgets (e.g., `ListView`, `GridView`) directly inside a `Column` without wrapping in `Expanded` or setting `shrinkWrap: true` + `physics: const NeverScrollableScrollPhysics()`.
- **Memory Leaks**: Never create a `TextEditingController`, `AnimationController`, `ScrollController`, `FocusNode`, `StreamSubscription`, or `Timer` without calling `.dispose()` or `.cancel()` in the state's `dispose()` method.
- **Swallowed Exceptions**: Never use empty `catch (e) {}` blocks. Always handle or log exceptions with context.
- **Hardcoding UI Values**: Avoid magic numbers and hardcoded colors/strings in widgets. Use theme tokens (`Theme.of(context)`), dimension constants, and localization/strings files.
- **Unnecessary Rebuilds**: Avoid calling `setState()` at the root level when only a small leaf widget needs updating. Avoid omitting `const` on immutable widgets.

---

### 🧠 Learned Mistakes & Bug Fixes (Living Log)
> *Note: When an AI mistake or bug occurs during development, document the root cause and prevention rule here immediately.*

1. **[Date: 2026-09-21] Initial Setup**:
   - *Rule*: Never exceed 500 lines per file; enforce modular widget tree architecture from day 1.
   - *Rule*: Always verify `mounted` before using `BuildContext` after asynchronous operations.
