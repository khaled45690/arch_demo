import '../../core/result.dart';
import '../../core/usecase.dart';
import '../entities/note.dart';
import '../repositories/i_note_repository.dart';

/// Flips the pinned state of a note and returns the updated entity.
class TogglePinUseCase implements UseCase<Note, String> {
  final INoteRepository _repository;
  const TogglePinUseCase(this._repository);

  @override
  Future<Result<Note>> call(String id) => _repository.togglePin(id);
}
