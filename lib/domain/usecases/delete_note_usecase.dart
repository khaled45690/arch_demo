import '../../core/result.dart';
import '../../core/usecase.dart';
import '../repositories/i_note_repository.dart';

/// Permanently removes a note by its [id].
class DeleteNoteUseCase implements UseCase<void, String> {
  final INoteRepository _repository;
  const DeleteNoteUseCase(this._repository);

  @override
  Future<Result<void>> call(String id) => _repository.deleteNote(id);
}
