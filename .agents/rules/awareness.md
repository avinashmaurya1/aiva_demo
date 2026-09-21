# 🔄 Project Awareness & Context Rules

### Context & Initialization
- **Always read `PLANNING.md`** at the start of a new conversation or when initiating any new architectural planning.
- **Check `TASK.md`** before starting a new task. If the task isn't listed, add it with a brief description and today's date.
- **Use consistent naming conventions, file structure, and architecture patterns** as described in `PLANNING.md`.

### 🧱 Code Structure & Modularity
- **Never create a file longer than 500 lines of code.** If a file approaches this limit, refactor by splitting it into sub-widgets, separate controllers, helper services, or focused modules.
- **Organize code into clearly separated modules**, grouped by feature or responsibility (Feature-First / Layered Architecture).
- **Use clear, consistent imports** (prefer package-level imports or consistent relative imports within sub-features).

### 🚦 Vibe Coding 4-Phase Lifecycle
1. **Planning Phase**:
   - Understand requirements before touching code.
   - Clarify UI, architecture, and state decisions.
   - Update `PLANNING.md` with architectural additions and Mermaid diagrams.
   - Break feature down into actionable tasks in `TASK.md`.
2. **Implementation Phase**:
   - Write clean, type-safe, modular Flutter/Dart code.
   - Keep files under 500 lines.
   - If a mistake or bug is identified, fix it and log the rule in `things-to-avoid.md`.
3. **Test Phase**:
   - Verify UI rendering, responsive layouts, error states, and logic.
   - Run `flutter analyze` and `flutter test`.
4. **Document Phase**:
   - Mark completed tasks in `TASK.md` immediately with completion timestamp.
   - Add/update README or API documentation.

### ✅ Task Completion
- **Mark completed tasks in `TASK.md` immediately** after finishing them.
- **Add new sub-tasks or TODOs** discovered during development to `TASK.md` under the "Discovered During Work" section.
