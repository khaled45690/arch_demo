import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_colors.dart';

/// Floating action button that opens the add-note sheet.
class NotesFab extends StatelessWidget {
  final VoidCallback onPressed;

  const NotesFab({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: DemoColors.indigo,
      elevation: 0,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: Text(
        'New Note',
        style: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
