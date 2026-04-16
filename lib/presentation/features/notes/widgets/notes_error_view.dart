import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

/// Full-screen error state shown when notes fail to load.
class NotesErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const NotesErrorView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: DemoColors.rose,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: DemoColors.textSecondary),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              'Retry',
              style: TextStyle(color: DemoColors.indigo),
            ),
          ),
        ],
      ),
    );
  }
}
