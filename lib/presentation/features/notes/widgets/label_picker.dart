import 'package:flutter/material.dart';

import '../../../../domain/entities/note.dart';
import '../../../core/app_colors.dart';

/// A row of coloured circles for selecting a [NoteLabel].
///
/// Stateless — the parent holds the selected value and passes a callback.
class LabelPicker extends StatelessWidget {
  final NoteLabel selected;
  final void Function(NoteLabel) onChanged;

  const LabelPicker({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: NoteLabel.values.map((l) => _LabelDot(
            label: l,
            isSelected: selected == l,
            onTap: () => onChanged(l),
          )).toList(),
    );
  }
}

// ── Private sub-widget ────────────────────────────────────────────────────────

class _LabelDot extends StatelessWidget {
  final NoteLabel label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LabelDot({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = DemoColors.forLabel(label);
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: isSelected ? 34 : 28,
          height: isSelected ? 34 : 28,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.white : Colors.transparent,
              width: 2.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: isSelected
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
              : null,
        ),
      ),
    );
  }
}
