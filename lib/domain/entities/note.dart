/// A single note — the core domain entity.
///
/// Pure Dart: no JSON, no Flutter, no framework dependencies.
/// This is the single source of truth for what a "Note" means in this app.
class Note {
  final String id;
  final String title;
  final String content;
  final NoteLabel label;
  final DateTime createdAt;
  final bool isPinned;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.label,
    required this.createdAt,
    this.isPinned = false,
  });

  Note copyWith({
    String? title,
    String? content,
    NoteLabel? label,
    bool? isPinned,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      label: label ?? this.label,
      createdAt: createdAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}

/// Visual colour tag assigned to a note.
enum NoteLabel { indigo, rose, amber, emerald, violet }
