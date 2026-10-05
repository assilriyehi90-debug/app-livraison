import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFE8590C);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        ),
      );
}
