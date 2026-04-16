import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

/// A pill-shaped drag handle shown at the top of bottom sheets.
class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: DemoColors.border,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
