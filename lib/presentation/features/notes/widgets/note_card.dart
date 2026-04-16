import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../domain/entities/note.dart';
import '../../../core/app_colors.dart';

/// Displays a single note with a coloured left accent strip.
///
/// Swipe left to delete. Tap the pin icon to toggle pinned state.
class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;
  final VoidCallback onTogglePin;

  const NoteCard({
    required this.note,
    required this.onDelete,
    required this.onTogglePin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: const _DeleteBackground(),
      child: _NoteCardContent(
        note: note,
        onTogglePin: onTogglePin,
      ),
    );
  }
}

// ── Private sub-widgets (tightly coupled to NoteCard, not reused elsewhere) ──

class _NoteCardContent extends StatelessWidget {
  final Note note;
  final VoidCallback onTogglePin;

  const _NoteCardContent({
    required this.note,
    required this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    final accent = DemoColors.forLabel(note.label);
    return Container(
      decoration: BoxDecoration(
        color: DemoColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: accent, width: 3.5),
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTogglePin,
          splashColor: accent.withValues(alpha: 0.06),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TitleRow(note: note, accent: accent, onTogglePin: onTogglePin),
                if (note.content.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _ContentPreview(content: note.content),
                ],
                const SizedBox(height: 12),
                _CardFooter(note: note, accent: accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  final Note note;
  final Color accent;
  final VoidCallback onTogglePin;

  const _TitleRow({
    required this.note,
    required this.accent,
    required this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
             note.title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: DemoColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onTogglePin,
          child: Icon(
            note.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
            size: 17,
            color: note.isPinned ? accent : DemoColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _ContentPreview extends StatelessWidget {
  final String content;
  const _ContentPreview({required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.inter(
        fontSize: 13,
        color: DemoColors.textSecondary,
        height: 1.5,
      ),
    );
  }
}

class _CardFooter extends StatelessWidget {
  final Note note;
  final Color accent;

  const _CardFooter({required this.note, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          _relativeDate(note.createdAt),
          style: GoogleFonts.inter(fontSize: 11, color: DemoColors.textMuted),
        ),
        if (note.isPinned) ...[
          const SizedBox(width: 8),
          Text(
            '· Pinned',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: accent.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: DemoColors.rose.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.delete_outline_rounded,
        color: DemoColors.rose,
        size: 22,
      ),
    );
  }
}

// ── Pure helper (not a widget) ────────────────────────────────────────────────

String _relativeDate(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inDays < 1) return '${diff.inHours}h ago';
  if (diff.inDays == 1) return 'Yesterday';
  if (diff.inDays < 7) return '${diff.inDays} days ago';
  return '${dt.day}/${dt.month}/${dt.year}';
}
