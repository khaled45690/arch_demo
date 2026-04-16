import '../../lib/core/result.dart';
import '../../lib/domain/entities/note.dart';
import '../../lib/domain/repositories/i_note_repository.dart';

/// Manual mock for [INoteRepository].
///
/// No mockito, no code generation — just a plain Dart class.
/// Configure [shouldFail] to simulate repository errors.
/// Read [lastAddedTitle] / [lastAddedContent] to verify what was passed in.
class MockNoteRepository implements INoteRepository {
  // ── Configuration ─────────────────────────────────────────────────────────
  bool shouldFail;
  String failureMessage;
  List<Note> seedNotes;

  // ── Call capture (read after calling the use case) ────────────────────────
  String? lastAddedTitle;
  String? lastAddedContent;
  NoteLabel? lastAddedLabel;

  MockNoteRepository({
    this.shouldFail = false,
    this.failureMessage = 'Repository error',
    List<Note>? seedNotes,
  }) : seedNotes = seedNotes ?? [];

  // ── INoteRepository ───────────────────────────────────────────────────────

  @override
  Future<Result<List<Note>>> getNotes() async {
    if (shouldFail) return Failure(failureMessage);
    return Success(List.from(seedNotes));
  }

  @override
  Future<Result<Note>> addNote({
    required String title,
    required String content,
    required NoteLabel label,
  }) async {
    // Capture what was actually passed — used to verify trimming, etc.
    lastAddedTitle   = title;
    lastAddedContent = content;
    lastAddedLabel   = label;

    if (shouldFail) return Failure(failureMessage);

    return Success(Note(
      id: 'mock-id',
      title: title,
      content: content,
      label: label,
      createdAt: DateTime(2026, 4, 16),
    ));
  }

  @override
  Future<Result<void>> deleteNote(String id) async {
    if (shouldFail) return Failure(failureMessage);
    return const Success(null);
  }

  @override
  Future<Result<Note>> togglePin(String id) async {
    if (shouldFail) return Failure(failureMessage);
    final note = seedNotes.firstWhere((n) => n.id == id);
    return Success(note.copyWith(isPinned: !note.isPinned));
  }
}
