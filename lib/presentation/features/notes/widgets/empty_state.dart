import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_colors.dart';

/// Shown when the notes list is empty.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: DemoColors.indigo.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.note_alt_outlined,
              color: DemoColors.indigo,
              size: 34,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No notes yet',
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: DemoColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap + New Note to get started',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: DemoColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
