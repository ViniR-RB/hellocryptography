import 'package:flutter/material.dart';

sealed class AppTheme {
  static final ThemeData theme = ThemeData(
    primarySwatch: Colors.blue,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: true),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
  );
}
