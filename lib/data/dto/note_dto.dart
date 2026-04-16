import '../../domain/entities/note.dart';

/// Data Transfer Object — owns all JSON serialisation.
///
/// Conversion between raw Maps and domain [Note] entities happens here only.
/// The [Note] entity itself has zero knowledge of JSON or any storage format.
class NoteDto {
  final String id;
  final String title;
  final String content;
  final String label;
  final String createdAt;
  final bool isPinned;

  const NoteDto({
    required this.id,
    required this.title,
    required this.content,
    required this.label,
    required this.createdAt,
    required this.isPinned,
  });

  // ── Deserialise ─────────────────────────────────────────────────────────────

  factory NoteDto.fromJson(Map<String, dynamic> json) => NoteDto(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        label: json['label'] as String,
        createdAt: json['created_at'] as String,
        isPinned: json['is_pinned'] as bool? ?? false,
      );

  // ── Serialise ───────────────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'label': label,
        'created_at': createdAt,
        'is_pinned': isPinned,
      };

  // ── Domain conversion ───────────────────────────────────────────────────────

  Note toEntity() => Note(
        id: id,
        title: title,
        content: content,
        label: NoteLabel.values.byName(label),
        createdAt: DateTime.parse(createdAt),
        isPinned: isPinned,
      );

  factory NoteDto.fromEntity(Note note) => NoteDto(
        id: note.id,
        title: note.title,
        content: note.content,
        label: note.label.name,
        createdAt: note.createdAt.toIso8601String(),
        isPinned: note.isPinned,
      );
}
