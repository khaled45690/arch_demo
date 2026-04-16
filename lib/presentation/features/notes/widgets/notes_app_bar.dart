import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_colors.dart';

/// App bar for the notes screen showing the title and live note count.
class NotesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int noteCount;
  final bool isLoading;

  const NotesAppBar({
    required this.noteCount,
    required this.isLoading,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: DemoColors.background,
      titleSpacing: 24,
      toolbarHeight: 72,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: DemoColors.textPrimary,
              letterSpacing: -0.8,
            ),
          ),
          Text(
            isLoading
                ? 'Loading…'
                : '$noteCount note${noteCount == 1 ? '' : 's'}',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: DemoColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
