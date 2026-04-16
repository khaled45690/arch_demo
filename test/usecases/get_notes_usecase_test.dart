import 'package:flutter_test/flutter_test.dart';

import '../../lib/core/result.dart';
import '../../lib/core/usecase.dart';
import '../../lib/domain/entities/note.dart';
import '../../lib/domain/usecases/get_notes_usecase.dart';
import '../mocks/mock_note_repository.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

Note _note(String id, {bool pinned = false, int daysAgo = 0}) => Note(
      id: id,
      title: 'Note $id',
      content: '',
      label: NoteLabel.indigo,
      createdAt: DateTime(2026, 4, 16).subtract(Duration(days: daysAgo)),
      isPinned: pinned,
    );

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  late MockNoteRepository repository;
  late GetNotesUseCase useCase;

  setUp(() {
    repository = MockNoteRepository();
    useCase    = GetNotesUseCase(repository);
  });

  test('returns empty list when there are no notes', () async {
    final result = await useCase(const NoParams());

    expect(result, isA<Success>());
    expect((result as Success).data, isEmpty);
  });

  test('returns Failure when repository fails', () async {
    repository.shouldFail     = true;
    repository.failureMessage = 'Storage error';

    final result = await useCase(const NoParams());

    expect(result, isA<Failure>());
    expect((result as Failure).message, 'Storage error');
  });

  // ── Sorting — this is business logic, lives in the use case ───────────────

  test('pinned notes appear before unpinned notes', () async {
    repository.seedNotes = [
      _note('A', pinned: false),
      _note('B', pinned: true),
      _note('C', pinned: false),
    ];

    final result = await useCase(const NoParams());
    final notes  = (result as Success).data as List<Note>;

    expect(notes.first.id, 'B');          // pinned comes first
    expect(notes.map((n) => n.isPinned),  [true, false, false]);
  });

  test('unpinned notes are sorted newest first', () async {
    repository.seedNotes = [
      _note('old',    daysAgo: 5),
      _note('newest', daysAgo: 0),
      _note('middle', daysAgo: 2),
    ];

    final result = await useCase(const NoParams());
    final ids    = (result as Success<List<Note>>).data.map((n) => n.id).toList();

    expect(ids, ['newest', 'middle', 'old']);
  });

  test('pinned notes are also sorted newest first among themselves', () async {
    repository.seedNotes = [
      _note('pinned-old',    pinned: true, daysAgo: 3),
      _note('pinned-newest', pinned: true, daysAgo: 0),
      _note('unpinned',      pinned: false),
    ];

    final result = await useCase(const NoParams());
    final ids    = (result as Success<List<Note>>).data.map((n) => n.id).toList();

    expect(ids, ['pinned-newest', 'pinned-old', 'unpinned']);
  });

  test('does not mutate the original list from repository', () async {
    final original = [_note('X'), _note('Y')];
    repository.seedNotes = original;

    await useCase(const NoParams());

    // The use case copies before sorting — original order is preserved
    expect(original.map((n) => n.id).toList(), ['X', 'Y']);
  });
}
