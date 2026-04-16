import 'package:flutter/material.dart';

import '../../domain/entities/note.dart';

abstract final class DemoColors {
  // ── Background scale ────────────────────────────────────────────────────────
  static const background = Color(0xFF090B10);
  static const surface    = Color(0xFF111318);
  static const card       = Color(0xFF181B24);
  static const border     = Color(0xFF232633);

  // ── Typography ──────────────────────────────────────────────────────────────
  static const textPrimary   = Color(0xFFF0F2FF);
  static const textSecondary = Color(0xFF7B7F96);
  static const textMuted     = Color(0xFF3E4257);

  // ── Label palette ───────────────────────────────────────────────────────────
  static const indigo  = Color(0xFF4F46E5);
  static const rose    = Color(0xFFE11D48);
  static const amber   = Color(0xFFF59E0B);
  static const emerald = Color(0xFF10B981);
  static const violet  = Color(0xFF7C3AED);

  /// Returns the accent colour for a given [NoteLabel].
  static Color forLabel(NoteLabel label) => switch (label) {
        NoteLabel.indigo  => indigo,
        NoteLabel.rose    => rose,
        NoteLabel.amber   => amber,
        NoteLabel.emerald => emerald,
        NoteLabel.violet  => violet,
      };
}
