# ⚙️ Technical Architecture, State Management & Standards

### 1. Dart 3 & Flutter Language Standards
- **Null Safety & Sound Typing**: Avoid using `dynamic` or unnecessary `Object?`. Use strongly typed models and generics.
- **Pattern Matching & Switch Expressions**: Leverage Dart 3 pattern matching, switch expressions, and destructuring for state inspection and enum mapping.
- **Sealed Classes for State**: Use `sealed class` for UI states (e.g. `Initial`, `Loading`, `Success`, `Failure`) to ensure exhaustive handling.
- **Records**: Use Dart records `(int, String)` for lightweight tuple data where creating a dedicated class is overkill.

### 2. State Management & Architecture
- **Unidirectional Data Flow**: UI dispatches events/actions -> Controller/Notifier processes business logic -> Emits immutable new state -> UI rebuilds reactively.
- **Separation of Concerns**: Never make network calls, parse raw JSON, or execute business logic directly inside UI widget classes.
- **Immutability**: Make state classes immutable using `final` fields and provide `copyWith` methods.

### 3. AI Agent Streaming & Real-Time Communication
- **Stream Management**: AI agent token streaming must handle stream listeners safely, supporting stream pause, resume, and cancellation.
- **Markdown & Code Rendering**: Render agent responses progressively using high-performance Flutter markdown rendering with syntax highlighting.
- **Connection Resilience**: Implement reconnection logic, exponential backoff, and graceful degradation for WebSocket/SSE connections.

### 4. Networking & Error Handling
- **Typed Responses**: Map API responses into strongly typed DTOs/Entities.
- **Result / Either Pattern**: Wrap network and service calls with explicit Success/Failure results rather than letting unhandled exceptions crash the UI.
- **Interceptors**: Log requests/responses in debug mode only. Handle token refreshes and global auth headers centrally.

### 5. Resource & Memory Management
- **Mandatory Disposal**: Always dispose `TextEditingController`, `ScrollController`, `AnimationController`, `FocusNode`, `StreamSubscription`, and `Timer` in `dispose()`.
- **Isolate Offloading**: Run compute-heavy tasks (e.g., large JSON parsing, image manipulation, token calculations) in background isolates via `compute()` or `Isolate.run()`.
- **Widget Tree Optimization**: Prefer `const` constructors everywhere applicable to maximize Flutter widget reuse and minimize rebuild cost.
