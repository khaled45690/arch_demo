import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../../domain/usecases/add_note_usecase.dart';
import 'controller/notes_controller.dart';
import 'widgets/add_note_bottom_sheet.dart';
import 'widgets/empty_state.dart';
import 'widgets/note_card.dart';
import 'widgets/notes_app_bar.dart';
import 'widgets/notes_error_view.dart';
import 'widgets/notes_fab.dart';

/// Full-screen notes list.
///
/// This file contains only [build] — every action and piece of state
/// lives in [NotesController].
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends NotesController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DemoColors.background,
      appBar: NotesAppBar(
        noteCount: notes.length,
        isLoading: isLoading,
      ),
      floatingActionButton: NotesFab(
        onPressed: () => _showAddSheet(context),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: DemoColors.indigo,
          strokeWidth: 2,
        ),
      );
    }

    if (errorMessage != null) {
      return NotesErrorView(
        message: errorMessage!,
        onRetry: loadNotes,
      );
    }

    if (notes.isEmpty) return const EmptyState();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      itemCount: notes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 15),
      itemBuilder: (_, i) => NoteCard(
        note: notes[i],
        onDelete: () => deleteNote(notes[i].id),
        onTogglePin: () => togglePin(notes[i].id),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: DemoColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => AddNoteBottomSheet(
        onAdd: (AddNoteParams params) {
          Navigator.of(context).pop();
          addNote(params);
        },
      ),
    );
  }
}
