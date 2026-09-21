# 📂 Project Structure and File Organization Guidelines

### Directory & Architectural Structure

This project follows a **Feature-First Clean Architecture** designed for scalability, maintainability, and clean separation of concerns.

```text
lib/
├── main.dart                   # Application entry point
├── app.dart                    # MaterialApp / Root widget configuration
└── src/
    ├── core/                   # Global, foundational logic shared across all features
    │   ├── constants/          # App constants (strings, assets, api endpoints)
    │   ├── error/              # Failure objects, exceptions, error handlers
    │   ├── network/            # HTTP/Dio client, interceptors, websockets
    │   ├── routing/            # App routes, navigation guards
    │   ├── theme/              # Color palette, typography, light & dark theme definitions
    │   ├── utils/              # Helper utilities, extensions, formatters
    │   └── services/           # Platform services (storage, audio, permissions, etc.)
    │
    ├── features/               # Modular business features (self-contained modules)
    │   ├── <feature_name>/
    │   │   ├── data/           # Data layer (API calls, DB queries, DTOs/models)
    │   │   │   ├── datasources/
    │   │   │   ├── models/
    │   │   │   └── repositories/
    │   │   ├── domain/         # Domain layer (business entities, interfaces)
    │   │   │   ├── entities/
    │   │   │   └── repositories/
    │   │   └── presentation/   # Presentation layer (UI and State)
    │   │       ├── controllers/ # State management / Notifiers / Blocs
    │   │       ├── screens/     # Full-screen page widgets
    │   │       └── widgets/     # Feature-specific sub-widgets
    │
    └── shared/                 # Reusable UI widgets and models across features
        ├── widgets/            # Custom buttons, input fields, loading states, dialogs
        └── models/             # Universal data models
```

### 🏷️ Naming Conventions

1. **Files & Folders**: `snake_case.dart`
   - Screens: `[name]_screen.dart` or `[name]_view.dart` (e.g. `chat_screen.dart`)
   - Widgets: `[name]_[component].dart` (e.g. `message_bubble.dart`, `agent_avatar.dart`)
   - Controllers/State: `[name]_controller.dart` or `[name]_notifier.dart`
   - Models: `[name]_model.dart`
   - Repositories: `[name]_repository.dart`
2. **Classes, Enums & Typedefs**: `PascalCase` (e.g., `ChatScreen`, `AgentState`, `MessageModel`)
3. **Variables, Methods & Parameters**: `camelCase` (e.g., `sendMessage()`, `isLoading`, `agentResponse`)
4. **Constants**: `lowerCamelCase` as per Effective Dart (e.g., `kDefaultPadding`, `apiBaseUrl`)
5. **Private Members**: Prefix with underscore `_` (e.g., `_buildHeader()`, `_internalState`)

### 📏 File Size & Modularity Limits
- **Maximum 500 lines per file**: Extract large build methods into dedicated private/public sub-widgets.
- **Single Responsibility**: One primary class per file. Keep helper extensions or localized small enums in the same file only if tightly coupled.
