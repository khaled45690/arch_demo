import 'package:flutter_test/flutter_test.dart';

import '../../lib/core/result.dart';
import '../../lib/domain/entities/note.dart';
import '../../lib/domain/usecases/add_note_usecase.dart';
import '../mocks/mock_note_repository.dart';

void main() {
  late MockNoteRepository repository;
  late AddNoteUseCase useCase;

  setUp(() {
    repository = MockNoteRepository();
    useCase    = AddNoteUseCase(repository);
  });

  // ── Validation — these never reach the repository ─────────────────────────

  test('rejects empty title', () async {
    final result = await useCase(
      const AddNoteParams(title: '', content: 'some content', label: NoteLabel.indigo),
    );

    expect(result, isA<Failure>());
    expect((result as Failure).message, 'Title cannot be empty.');
    // The use case must short-circuit — repository should never be called
    expect(repository.lastAddedTitle, isNull);
  });

  test('rejects whitespace-only title', () async {
    final result = await useCase(
      const AddNoteParams(title: '     ', content: '', label: NoteLabel.rose),
    );

    expect(result, isA<Failure>());
    expect((result as Failure).message, 'Title cannot be empty.');
    expect(repository.lastAddedTitle, isNull);
  });

  test('rejects title over 100 characters', () async {
    final longTitle = 'A' * 101;

    final result = await useCase(
      AddNoteParams(title: longTitle, content: '', label: NoteLabel.amber),
    );

    expect(result, isA<Failure>());
    expect((result as Failure).message, 'Title must be under 100 characters.');
    expect(repository.lastAddedTitle, isNull);
  });

  test('accepts title of exactly 100 characters', () async {
    final edgeTitle = 'A' * 100;

    final result = await useCase(
      AddNoteParams(title: edgeTitle, content: '', label: NoteLabel.emerald),
    );

    expect(result, isA<Success>());
  });

  // ── Transformation — verifies what actually reaches the repository ─────────

  test('trims whitespace from title before saving', () async {
    await useCase(
      const AddNoteParams(
        title: '  Architecture Pattern  ',
        content: 'some content',
        label: NoteLabel.indigo,
      ),
    );

    // The mock captured what was passed to addNote()
    expect(repository.lastAddedTitle, 'Architecture Pattern');
  });

  test('trims whitespace from content before saving', () async {
    await useCase(
      const AddNoteParams(
        title: 'Valid Title',
        content: '  content with spaces  ',
        label: NoteLabel.violet,
      ),
    );

    expect(repository.lastAddedContent, 'content with spaces');
  });

  // ── Repository failure passthrough ────────────────────────────────────────

  test('returns Failure when repository fails', () async {
    repository.shouldFail    = true;
    repository.failureMessage = 'Database unavailable';

    final result = await useCase(
      const AddNoteParams(title: 'Valid', content: '', label: NoteLabel.indigo),
    );

    expect(result, isA<Failure>());
    expect((result as Failure).message, 'Database unavailable');
  });

  // ── Happy path ────────────────────────────────────────────────────────────

  test('returns Success with note on valid input', () async {
    final result = await useCase(
      const AddNoteParams(
        title: 'Use Cases',
        content: 'All business logic lives here.',
        label: NoteLabel.violet,
      ),
    );

    expect(result, isA<Success>());
    final note = (result as Success<Note>).data;
    expect(note.title,   'Use Cases');
    expect(note.content, 'All business logic lives here.');
    expect(note.label,   NoteLabel.violet);
  });
}
