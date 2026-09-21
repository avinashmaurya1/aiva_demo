# 🌊 Vibe Coding Workflow - Agent Guidelines

Welcome to the **AIVA AI Agent Mobile** codebase. As an AI pair programmer, you MUST strictly adhere to the following Vibe Coding Workflow and project rules across every session.

---

## 🔄 1. Project Awareness & Context Rules
- **Always read `PLANNING.md`** at the beginning of a conversation or when initiating any new architectural planning.
- **Always check `TASK.md`** before starting any work. If the task is not listed, add it with a clear summary, checkbox, and today's date.
- **Maintain Architectural Consistency**: Adhere to the Feature-First Clean Architecture and naming standards defined in `.agents/rules/project-structure.md` and `.agents/rules/standard.md`.
- **Enforce File Size Limit**: **NEVER create or allow a file longer than 500 lines of code**. Refactor and split into sub-widgets, helper services, or state notifiers proactively.

---

## 🚦 2. The 4-Phase Vibe Coding Lifecycle

### Phase 1: Planning Phase (No Code Yet)
1. **Trigger**: User starts with feature ideation or prompts: *"Let's plan the <feature name> don't do code yet."*
2. **Clarification & Analysis**: Review user requirements, Figma links, PRD specifications, and edge cases.
3. **Architecture Update**: If approved, update `PLANNING.md` with system design, Mermaid diagrams, and data flow.
4. **Task Decomposition**: Break the plan down into granular, actionable sub-tasks and save them to `TASK.md` under Active Tasks.
5. **Git Checkpoint**: Ensure a clean commit for planning changes.

### Phase 2: Implementation Phase
1. **Trigger**: User requests coding to start.
2. **Modular Development**: Write type-safe, idiomatic Dart & Flutter code adhering to `.agents/rules/technical.md`.
3. **Mistake Prevention & Self-Correction**: If a mistake, bug, or anti-pattern occurs:
   - Fix the issue immediately.
   - Append the lesson learned and prevention rule to `.agents/rules/things-to-avoid.md`.
4. **Code Quality**: Verify zero warnings with `flutter analyze` and ensure no file exceeds 500 lines.
5. **Git Checkpoint**: Commit working, clean implementation code.

### Phase 3: Test Phase
1. **Execution**: Verify widget rendering, reactive state transitions, mock responses, and error handling.
2. **Automated Verification**: Run widget tests and unit tests (`flutter test`).
3. **Git Checkpoint**: Commit verified test additions.

### Phase 4: Document Phase
1. **Task Completion**: Check off the task in `TASK.md` and record the completion timestamp.
2. **Documentation**: Update API docs, inline `///` comments, and user-facing README guides.
3. **Git Checkpoint**: Commit documentation updates.

---

## 📂 Rule Files Reference
- `.agents/rules/awareness.md`
- `.agents/rules/project-structure.md`
- `.agents/rules/technical.md`
- `.agents/rules/standard.md`
- `.agents/rules/things-to-avoid.md`
