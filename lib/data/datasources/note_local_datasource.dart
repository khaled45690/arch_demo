import '../../domain/entities/note.dart';

/// In-memory data store, seeded with example notes.
///
/// In a real app this would be SQLite, Hive, or a remote REST API.
/// Swap this class out without touching the domain or presentation layers.
class NoteLocalDataSource {
  final List<Map<String, dynamic>> _store;

  NoteLocalDataSource() : _store = _seed();

  // ── Public API ──────────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getAll() async => List.from(_store);

  Future<Map<String, dynamic>> add(Map<String, dynamic> data) async {
    _store.insert(0, data);
    return data;
  }

  Future<void> delete(String id) async =>
      _store.removeWhere((n) => n['id'] == id);

  Future<Map<String, dynamic>?> findById(String id) async {
    try {
      return _store.firstWhere((n) => n['id'] == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> update(Map<String, dynamic> data) async {
    final i = _store.indexWhere((n) => n['id'] == data['id']);
    if (i >= 0) _store[i] = data;
  }

  // ── Seed data ───────────────────────────────────────────────────────────────
  // The content of the notes explains the architecture — read them in the app.

  static List<Map<String, dynamic>> _seed() {
    final now = DateTime.now();
    return [
      {
        'id': '1',
        'title': 'Architecture Pattern',
        'content':
            'Clean Architecture layering with Flutter\'s native setState. No BLoC, no Riverpod — just clear boundaries between layers.',
        'label': NoteLabel.indigo.name,
        'created_at': now.subtract(const Duration(days: 3)).toIso8601String(),
        'is_pinned': true,
      },
      {
        'id': '2',
        'title': 'Use Cases',
        'content':
            'All business logic and validation lives here. Pure Dart — fully testable without a widget tree or Flutter dependency.',
        'label': NoteLabel.violet.name,
        'created_at': now.subtract(const Duration(days: 2)).toIso8601String(),
        'is_pinned': false,
      },
      {
        'id': '3',
        'title': 'Repository Pattern',
        'content':
            'Domain defines the interface. Data implements it. Presentation never imports the concrete class — only the contract.',
        'label': NoteLabel.rose.name,
        'created_at': now.subtract(const Duration(days: 1)).toIso8601String(),
        'is_pinned': false,
      },
      {
        'id': '4',
        'title': 'The Result Type',
        'content':
            'Sealed class with Success and Failure variants. Pattern-match in your controller — no try/catch leaking into the UI.',
        'label': NoteLabel.amber.name,
        'created_at': now.toIso8601String(),
        'is_pinned': false,
      },
    ];
  }
}
