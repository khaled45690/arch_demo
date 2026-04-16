import '../../core/result.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/i_note_repository.dart';
import '../datasources/note_local_datasource.dart';
import '../dto/note_dto.dart';

/// Concrete implementation of [INoteRepository].
///
/// Translates between raw storage data (DTOs/Maps) and domain [Note] entities.
/// The domain layer never sees this class — it only knows [INoteRepository].
class NoteRepositoryImpl implements INoteRepository {
  final NoteLocalDataSource _dataSource;
  const NoteRepositoryImpl(this._dataSource);

  @override
  Future<Result<List<Note>>> getNotes() async {
    try {
      final raw = await _dataSource.getAll();
      return Success(raw.map((d) => NoteDto.fromJson(d).toEntity()).toList());
    } catch (e) {
      return Failure('Could not load notes: $e');
    }
  }

  @override
  Future<Result<Note>> addNote({
    required String title,
    required String content,
    required NoteLabel label,
  }) async {
    try {
      final note = Note(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        content: content,
        label: label,
        createdAt: DateTime.now(),
      );
      await _dataSource.add(NoteDto.fromEntity(note).toJson());
      return Success(note);
    } catch (e) {
      return Failure('Could not save note: $e');
    }
  }

  @override
  Future<Result<void>> deleteNote(String id) async {
    try {
      await _dataSource.delete(id);
      return const Success(null);
    } catch (e) {
      return Failure('Could not delete note: $e');
    }
  }

  @override
  Future<Result<Note>> togglePin(String id) async {
    try {
      final raw = await _dataSource.findById(id);
      if (raw == null) return const Failure('Note not found.');
      final updated = NoteDto.fromJson(raw)
          .toEntity()
          .copyWith(isPinned: !(raw['is_pinned'] as bool? ?? false));
      await _dataSource.update(NoteDto.fromEntity(updated).toJson());
      return Success(updated);
    } catch (e) {
      return Failure('Could not update note: $e');
    }
  }
}
