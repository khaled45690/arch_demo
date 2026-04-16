import 'package:flutter/material.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase.dart';
import '../../../../data/datasources/note_local_datasource.dart';
import '../../../../data/repositories/note_repository_impl.dart';
import '../../../../domain/entities/note.dart';
import '../../../../domain/usecases/add_note_usecase.dart';
import '../../../../domain/usecases/delete_note_usecase.dart';
import '../../../../domain/usecases/get_notes_usecase.dart';
import '../../../../domain/usecases/toggle_pin_usecase.dart';
import '../notes_screen.dart';

/// All business logic for the Notes screen.
///
/// This class contains zero widgets — only state variables and action methods.
/// [NotesScreen] is the thin shell that calls these methods and reads this state
/// inside its [build] method.
abstract class NotesController extends State<NotesScreen> {
  // ── Use cases ────────────────────────────────────────────────────────────────
  late final GetNotesUseCase _getNotes;
  late final AddNoteUseCase _addNote;
  late final DeleteNoteUseCase _deleteNote;
  late final TogglePinUseCase _togglePin;

  // ── UI state ─────────────────────────────────────────────────────────────────
  List<Note> notes = [];
  bool isLoading = true;
  String? errorMessage;

  // ── Lifecycle ────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _wire();
    loadNotes();
  }

  /// Wires the dependency chain: DataSource → Repository → Use Cases.
  ///
  /// In a production app replace this with GetIt or any DI container — the
  /// rest of the code does not change at all.
  void _wire() {
    final dataSource = NoteLocalDataSource();
    final repository = NoteRepositoryImpl(dataSource);
    _getNotes = GetNotesUseCase(repository);
    _addNote = AddNoteUseCase(repository);
    _deleteNote = DeleteNoteUseCase(repository);
    _togglePin = TogglePinUseCase(repository);
  }

  // ── Actions ──────────────────────────────────────────────────────────────────

  Future<void> loadNotes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final result = await _getNotes(const NoParams());
    if (!mounted) return;
    switch (result) {
      case Success(:final data):
        setState(() {
          notes = data;
          isLoading = false;
        });
      case Failure(:final message):
        setState(() {
          errorMessage = message;
          isLoading = false;
        });
    }
  }

  Future<void> addNote(AddNoteParams params) async {
    final result = await _addNote(params);
    if (!mounted) return;
    switch (result) {
      case Success(:final data):
        setState(() {
          final firstUnpinned = notes.indexWhere((n) => !n.isPinned);
          final insertAt = data.isPinned ? 0 : (firstUnpinned < 0 ? notes.length : firstUnpinned);
          notes.insert(insertAt, data);
        });
      case Failure(:final message):
        _showError(message);
    }
  }

  Future<void> deleteNote(String id) async {
    final result = await _deleteNote(id);
    if (!mounted) return;
    switch (result) {
      case Success():
        setState(() => notes.removeWhere((n) => n.id == id));
      case Failure(:final message):
        _showError(message);
    }
  }

  Future<void> togglePin(String id) async {
    final result = await _togglePin(id);
    if (!mounted) return;
    switch (result) {
      case Success(:final data):
        setState(() {
          final i = notes.indexWhere((n) => n.id == id);
          if (i >= 0) notes[i] = data;
          notes.sort((a, b) {
            if (a.isPinned && !b.isPinned) return -1;
            if (!a.isPinned && b.isPinned) return 1;
            return b.createdAt.compareTo(a.createdAt);
          });
        });
      case Failure(:final message):
        _showError(message);
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: const Color(0xFFE11D48)));
  }
}
