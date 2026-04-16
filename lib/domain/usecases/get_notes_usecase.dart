import '../../core/result.dart';
import '../../core/usecase.dart';
import '../entities/note.dart';
import '../repositories/i_note_repository.dart';

/// Returns all notes sorted: pinned first, then newest first.
///
/// Sorting is business logic — it belongs here, not in the repository
/// (which just fetches data) and not in the controller (which just updates UI).
class GetNotesUseCase implements UseCase<List<Note>, NoParams> {
  final INoteRepository _repository;
  const GetNotesUseCase(this._repository);

  @override
  Future<Result<List<Note>>> call(NoParams params) async {
    final result = await _repository.getNotes();
    return switch (result) {
      Success(:final data) => Success(
          [...data]..sort((a, b) {
            if (a.isPinned && !b.isPinned) return -1;
            if (!a.isPinned && b.isPinned) return 1;
            return b.createdAt.compareTo(a.createdAt);
          }),
        ),
      Failure() => result,
    };
  }
}
