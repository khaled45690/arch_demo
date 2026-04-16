import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'presentation/core/app_theme.dart';
import 'presentation/features/notes/notes_screen.dart';

/// Entry point for the architecture demo.
/// Run with: flutter run -t lib2/main.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Flutter Architecture',
      debugShowCheckedModeBanner: false,
      theme: DemoTheme.dark,
      home: const NotesScreen(),
    );
  }
}
