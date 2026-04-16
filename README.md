# Clean Flutter Architecture

> A production-ready architecture pattern that combines **Clean Architecture** layering with Flutter's native `setState` — no BLoC, no Riverpod, no extra dependencies.

---

## The Core Idea

Most Flutter architecture debates focus on *state management*. This pattern focuses on something more fundamental: **where logic lives**.

The rule is simple:

```
Presentation  →  Domain  ←  Data
```

Every arrow points **inward toward Domain**. Domain knows nothing about Flutter, HTTP, or any database. That one constraint keeps the whole system testable and maintainable.

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                       PRESENTATION                              │
│                                                                 │
│   ┌──────────────────────────────────────────────┐              │
│   │  Screen  (StatefulWidget — build() only)     │              │
│   └───────────────────────┬──────────────────────┘              │
│                           │  extends                            │
│   ┌───────────────────────▼──────────────────────┐              │
│   │  Abstract Controller  (extends State<Screen>)│              │
│   │  · state variables                           │              │
│   │  · action methods                            │              │
│   │  · calls use cases, updates setState()       │              │
│   └───────────────────────┬──────────────────────┘              │
└───────────────────────────┼─────────────────────────────────────┘
                            │  calls
┌───────────────────────────▼─────────────────────────────────────┐
│                         DOMAIN                                  │
│               (pure Dart — zero Flutter imports)                │
│                                                                 │
│   ┌─────────────────┐     ┌──────────────────────────────────┐  │
│   │   Use Cases     │     │   Repository Interfaces          │  │
│   │  · validation   │     │   (contracts only, no impl)      │  │
│   │  · business     │     └──────────────────────────────────┘  │
│   │    logic        │                                           │
│   │  · sorting      │     ┌──────────────────────────────────┐  │
│   └─────────────────┘     │   Entities / Models              │  │
│                           │   (pure Dart data classes)       │  │
│                           └──────────────────────────────────┘  │
└───────────────────────────┬─────────────────────────────────────┘
                            │  implements
┌───────────────────────────▼─────────────────────────────────────┐
│                           DATA                                  │
│                                                                 │
│   ┌─────────────────┐     ┌──────────────────────────────────┐  │
│   │  Repository     │     │   Data Sources                   │  │
│   │  Impl           │     │   (HTTP · SQLite · Hive · Memory)│  │
│   └─────────────────┘     └──────────────────────────────────┘  │
│                                                                 │
│   ┌──────────────────────────────────────────────────────────┐  │
│   │  DTOs / Mappers  (JSON ↔ Entity conversion lives here)   │  │
│   └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## File Structure

```
lib2/
├── main.dart                          ← entry point (flutter run -t lib2/main.dart)
│
├── core/
│   ├── result.dart                    ← sealed Result<T> (Success / Failure)
│   └── usecase.dart                   ← UseCase<T, Params> interface + NoParams
│
├── domain/                            ← pure Dart, zero framework dependencies
│   ├── entities/
│   │   └── note.dart                  ← Note entity + NoteLabel enum
│   ├── repositories/
│   │   └── i_note_repository.dart     ← abstract interface (contract only)
│   └── usecases/
│       ├── get_notes_usecase.dart     ← fetch + sort (pinned first)
│       ├── add_note_usecase.dart      ← validate + create
│       ├── delete_note_usecase.dart   ← remove by id
│       └── toggle_pin_usecase.dart   ← flip pinned state
│
├── data/                              ← implements domain contracts
│   ├── dto/
│   │   └── note_dto.dart              ← JSON ↔ Note entity mapping
│   ├── datasources/
│   │   └── note_local_datasource.dart ← in-memory store (swap for SQLite/Hive)
│   └── repositories/
│       └── note_repository_impl.dart  ← implements INoteRepository
│
└── presentation/
    ├── core/
    │   ├── app_colors.dart
    │   └── app_theme.dart
    └── features/
        └── notes/
            ├── notes_screen.dart          ← build() only, zero logic
            ├── controller/
            │   └── notes_controller.dart  ← all state + actions
            └── widgets/
                ├── note_card.dart
                ├── add_note_bottom_sheet.dart
                └── empty_state.dart
```

---

## Layer by Layer

### Core — `Result<T>`

Every use case and repository method returns a `Result<T>`. No `try/catch` leaks into the UI.

```dart
sealed class Result<T> { const Result(); }

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final String message;
  const Failure(this.message);
}
```

Pattern-match exhaustively in the controller — the compiler forces you to handle both cases:

```dart
switch (result) {
  case Success(:final data):    setState(() => notes = data);
  case Failure(:final message): _showError(message);
}
```

---

### Domain — Use Cases

All business logic lives here. This file imports nothing except other domain classes:

```dart
class AddNoteUseCase implements UseCase<Note, AddNoteParams> {
  final INoteRepository _repository;
  const AddNoteUseCase(this._repository);

  @override
  Future<Result<Note>> call(AddNoteParams params) {
    final title = params.title.trim();

    // ← validation lives here, not in the controller
    if (title.isEmpty) return Future.value(const Failure('Title cannot be empty.'));
    if (title.length > 100) return Future.value(const Failure('Title must be under 100 characters.'));

    return _repository.addNote(title: title, content: params.content.trim(), label: params.label);
  }
}
```

Adding a new rule means editing **one file**. No UI code is touched.

---

### Domain — Repository Interface

The domain layer defines *what* it needs. The data layer decides *how*:

```dart
abstract interface class INoteRepository {
  Future<Result<List<Note>>> getNotes();
  Future<Result<Note>> addNote({ required String title, required String content, required NoteLabel label });
  Future<Result<void>> deleteNote(String id);
  Future<Result<Note>> togglePin(String id);
}
```

---

### Data — Repository Implementation

Implements the contract. Translates between raw storage and domain entities:

```dart
class NoteRepositoryImpl implements INoteRepository {
  final NoteLocalDataSource _dataSource;

  @override
  Future<Result<List<Note>>> getNotes() async {
    try {
      final raw = await _dataSource.getAll();
      return Success(raw.map((d) => NoteDto.fromJson(d).toEntity()).toList());
    } catch (e) {
      return Failure('Could not load notes: $e');
    }
  }
}
```

Swap `NoteLocalDataSource` for a REST client or SQLite — the domain and presentation layers do not change.

---

### Presentation — Abstract Controller

Separates logic from UI at the file level. The screen file cannot contain business logic because it has nothing to contain it in:

```dart
// notes_controller.dart — zero widgets
abstract class NotesController extends State<NotesScreen> {
  List<Note> notes = [];
  bool isLoading = true;

  Future<void> addNote(AddNoteParams params) async {
    final result = await _addNote(params);       // ← calls use case
    switch (result) {
      case Success(:final data): setState(() => notes.insert(0, data));
      case Failure(:final message): _showError(message);
    }
  }
}

// notes_screen.dart — zero logic
class _NotesScreenState extends NotesController {
  @override
  Widget build(BuildContext context) { ... }   // ← reads state, calls methods
}
```

---

### Dependency Wiring

Dependencies are wired once in `initState`. In production replace with **GetIt** — nothing else changes:

```dart
void _wire() {
  final dataSource = NoteLocalDataSource();  // ← swap for any impl
  final repository = NoteRepositoryImpl(dataSource);
  _getNotes  = GetNotesUseCase(repository);
  _addNote   = AddNoteUseCase(repository);
}
```

---

## Why Not BLoC or Riverpod?

| Concern | This Pattern | BLoC | Riverpod |
|---|---|---|---|
| Business logic testability | ✅ Use cases are pure Dart | ✅ | ✅ |
| Boilerplate per feature | **Low** | High (Event + State + Bloc + Builder) | Medium |
| Learning curve | **Native Flutter** | High | Medium |
| State sharing across screens | Via global state | Via BlocProvider | Via providers |
| Framework dependency | **None** | `flutter_bloc` | `riverpod` |

BLoC and Riverpod solve **state sharing and reactivity**. This pattern solves **layering and testability**. They are orthogonal — you can combine this layering with either library if your app needs cross-screen reactive state.

---

## Running the Demo

```bash
# From the project root
flutter run -t lib2/main.dart
```

The seeded notes explain the architecture — read them in the running app.

---

## Testing a Use Case (pure Dart, no Flutter)

```dart
void main() {
  test('AddNoteUseCase rejects empty titles', () async {
    final repo = MockNoteRepository();           // ← simple mock, no widget tree
    final useCase = AddNoteUseCase(repo);

    final result = await useCase(
      const AddNoteParams(title: '', content: '', label: NoteLabel.indigo),
    );

    expect(result, isA<Failure>());
    expect((result as Failure).message, 'Title cannot be empty.');
  });
}
```

No `pumpWidget`, no `testWidgets`, no `BuildContext`. Just Dart.

---

## Key Principles

1. **Dependency rule** — arrows always point inward toward Domain. Domain imports nothing outside itself.
2. **One job per layer** — Domain validates and transforms. Data fetches and maps. Presentation renders and reacts.
3. **Result over exceptions** — `Success` and `Failure` are values, not control flow. Pattern-match on them.
4. **Use cases are the API** — the controller never touches a repository directly. Every action goes through a use case.
5. **Entities are pure** — `Note` has no `fromJson`. JSON lives in the DTO in the data layer.
