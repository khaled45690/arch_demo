import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../domain/entities/note.dart';
import '../../../../domain/usecases/add_note_usecase.dart';
import '../../../core/app_colors.dart';
import 'drag_handle.dart';
import 'label_picker.dart';
import 'note_submit_button.dart';
import 'note_text_field.dart';

/// Modal bottom sheet for creating a new note.
///
/// Local input state lives here — it is not business logic.
/// On submit it calls [onAdd] with [AddNoteParams] and lets the controller's
/// use case handle validation and persistence.
class AddNoteBottomSheet extends StatefulWidget {
  final void Function(AddNoteParams params) onAdd;
  const AddNoteBottomSheet({required this.onAdd, super.key});

  @override
  State<AddNoteBottomSheet> createState() => _AddNoteBottomSheetState();
}

class _AddNoteBottomSheetState extends State<AddNoteBottomSheet> {
  final _titleCtrl   = TextEditingController();
  final _contentCtrl = TextEditingController();
  NoteLabel _label   = NoteLabel.indigo;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DragHandle(),
          const SizedBox(height: 20),
          Text(
            'New Note',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: DemoColors.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 24),
          LabelPicker(
            selected: _label,
            onChanged: (l) => setState(() => _label = l),
          ),
          const SizedBox(height: 20),
          NoteTextField(
            controller: _titleCtrl,
            hintText: 'Title',
            autofocus: true,
          ),
          const SizedBox(height: 12),
          NoteTextField(
            controller: _contentCtrl,
            hintText: 'Note (optional)',
            maxLines: 4,
            minLines: 3,
            textColor: DemoColors.textSecondary,
            fontSize: 13,
            lineHeight: 1.6,
          ),
          const SizedBox(height: 28),
          NoteSubmitButton(
            label: _label,
            onTap: _submit,
          ),
        ],
      ),
    );
  }

  void _submit() {
    widget.onAdd(
      AddNoteParams(
        title: _titleCtrl.text,
        content: _contentCtrl.text,
        label: _label,
      ),
    );
  }
}
