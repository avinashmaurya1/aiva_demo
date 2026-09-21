# 📋 TASK.md - AIVA AI Agent Mobile Task Board

> **Active Sprint & Development Tasks**  
> *Initialized: 2026-09-21*

---

## 🚀 Active Tasks
- [x] **[2026-09-21] Phase 1: Authentication Module (Email/Credentials Login)**
  - [x] Create comprehensive architectural plan in `implementation_plan.md`
  - [x] Update `PLANNING.md` with AgenticBox backend API specifications
  - [x] Add necessary pub dependencies (`http`, `shared_preferences`, `intl`) to `pubspec.yaml`
  - [x] Scaffold `lib/src/core/` (constants, theme, network client, formatters)
  - [x] Implement `features/auth/` Domain layer (`AuthToken`, `UserProfile`, `AuthRepository`, `LoginUseCase`, `GetBootstrapUseCase`)
  - [x] Implement `features/auth/` Data layer (`AuthRemoteDataSource` calling `POST /api/auth/login` and `GET /api/auth/bootstrap`, `AuthLocalDataSource` with secure token caching, `AuthRepositoryImpl`)
  - [x] Implement `features/auth/` Presentation layer (`AuthBloc`, `AuthEvent`, `AuthState`, `LoginScreen` with Company ID, Username, Password)
  - [x] Verify Auth flow with automated tests and zero `flutter analyze` warnings

- [x] **[2026-09-21] Phase 2: Real-Time SSE Chat Streaming Engine**
  - [x] Implement `SseClient` (`POST /api/chat/stream` with Bearer auth, chunk reader, and `\n\n` event delimiter parser)
  - [x] Map SSE wire events (`session`, `message`, `tool_call`, `tool_response`, `done`, `error`) into strongly typed Dart classes
  - [x] Implement `features/chat/` Domain & Data layers (`ChatRepository`, `ChatMessage`)
  - [x] Implement `ChatBloc` handling token accumulation, session continuity (`session_id`), and tool execution status
  - [x] Build `ChatScreen` with auto-scrolling message list, input bar, and live streaming bubbles

- [x] **[2026-09-21] Phase 3: Generative UI Action Cards (Ixigo-like Flight & Travel Cards)**
  - [x] Implement Artifact detection in `tool_response` and client service (`GET /api/artifacts/{id}`)
  - [x] Create `FlightResultCard` with airline badge, flight number, departure/arrival timeline, duration, price in ₹ INR
  - [x] Create `HotelResultCard` with image, rating, location, and amenities chips
  - [x] Create quick suggestion pills for 1-tap travel searches
  - [x] Test end-to-end user flow: Login -> Open Chat -> Stream search query -> View Ixigo cards -> Continue turn

---

## 📌 Backlog (Roadmap Tasks)

### 📜 Phase 4: History, Session Persistence & Polish
- [ ] **[2026-09-21] Session Management & History Drawer**
  - [ ] Integrate `GET /api/chat/sessions` and `GET /api/chat/sessions/{id}` to restore past chat turns
  - [ ] Build session history drawer / screen with date grouping and search
  - [ ] Implement token refresh worker (`POST /api/auth/refresh`)

---

## 🔍 Discovered During Work (Living TODOs)
> *Note: Add sub-tasks, edge cases, and technical debt discovered during development here with timestamps.*

- [x] *[2026-09-21]* Ensure all currency amounts are displayed with formatted ₹ INR with comma separators.
- [x] *[2026-09-21]* Verify file size limit (< 500 lines per file) across all newly created widgets.

---

## ✅ Completed Tasks
- [x] **[2026-09-21]** Vibe Coding Workflow & Rules Setup initialized for Antigravity.
- [x] **[2026-09-21]** Architectural planning and system design for Ixigo-like Agentic Travel Search & Booking.
- [x] **[2026-09-21]** Authentication Module (Email/Credentials Login + Session Bootstrap + Persistent Token Caching).
- [x] **[2026-09-21]** Real-time SSE Chat Streaming Engine (`POST /api/chat/stream`) with auto-session continuity.
- [x] **[2026-09-21]** Ixigo-inspired Generative UI travel cards (`FlightResultCard`, `HotelResultCard`, `BookingCard`, `ArtifactRenderer`).



---

## 🔍 Discovered During Work (Living TODOs)
> *Note: Add sub-tasks, edge cases, and technical debt discovered during development here with timestamps.*

- [ ] *[2026-09-21]* Ensure all currency amounts are displayed with formatted ₹ INR with comma separators.
- [ ] *[2026-09-21]* Validate passenger details (age, contact phone, email) before confirming bookings.
- [ ] *[2026-09-21]* Verify file size limit (< 500 lines per file) across all newly created widgets.

---

## ✅ Completed Tasks
- [x] **[2026-09-21]** Vibe Coding Workflow & Rules Setup initialized for Antigravity.
- [x] **[2026-09-21]** Architectural planning and system design for Ixigo-like Agentic Travel Search & Booking.

