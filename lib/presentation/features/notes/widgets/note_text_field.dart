import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_colors.dart';

/// A styled [TextField] for note input.
///
/// Used for both the title (single line, autofocus) and content (multiline).
class NoteTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final int minLines;
  final bool autofocus;
  final Color textColor;
  final double fontSize;
  final double? lineHeight;

  const NoteTextField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.minLines = 1,
    this.autofocus = false,
    this.textColor = DemoColors.textPrimary,
    this.fontSize = 14,
    this.lineHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      autofocus: autofocus,
      style: GoogleFonts.inter(
        color: textColor,
        fontSize: fontSize,
        height: lineHeight,
      ),
      decoration: InputDecoration(hintText: hintText),
      textCapitalization: TextCapitalization.sentences,
    );
  }
}
