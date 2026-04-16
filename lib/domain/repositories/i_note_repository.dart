import '../../core/result.dart';
import '../entities/note.dart';

/// Contract that the data layer must fulfil.
///
/// The domain layer owns this interface — it defines *what* is needed
/// without caring *how* it is implemented (in-memory, SQLite, REST API…).
/// Presentation never imports the concrete implementation.
abstract interface class INoteRepository {
  Future<Result<List<Note>>> getNotes();

  Future<Result<Note>> addNote({
    required String title,
    required String content,
    required NoteLabel label,
  });

  Future<Result<void>> deleteNote(String id);

  Future<Result<Note>> togglePin(String id);
}
