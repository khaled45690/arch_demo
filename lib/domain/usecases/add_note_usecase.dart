import '../../core/result.dart';
import '../../core/usecase.dart';
import '../entities/note.dart';
import '../repositories/i_note_repository.dart';

/// Input parameters for [AddNoteUseCase].
final class AddNoteParams {
  final String title;
  final String content;
  final NoteLabel label;

  const AddNoteParams({
    required this.title,
    required this.content,
    required this.label,
  });
}

/// Validates and creates a new note.
///
/// All validation rules live here — the controller receives a clean [Result]
/// and never handles raw validation itself. Adding a new rule means editing
/// one place, with no UI code touched.
class AddNoteUseCase implements UseCase<Note, AddNoteParams> {
  final INoteRepository _repository;
  const AddNoteUseCase(this._repository);

  @override
  Future<Result<Note>> call(AddNoteParams params) {
    final title = params.title.trim();

    if (title.isEmpty) {
      return Future.value(const Failure('Title cannot be empty.'));
    }
    if (title.length > 100) {
      return Future.value(const Failure('Title must be under 100 characters.'));
    }

    return _repository.addNote(
      title: title,
      content: params.content.trim(),
      label: params.label,
    );
  }
}
