import 'package:blog/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Input decoration style
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3.0,
        ),
        borderRadius: BorderRadius.circular(10),
      );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: const AppBarTheme(backgroundColor: AppPallete.backgroundColor),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradient2),
      errorBorder: _border(AppPallete.errorColor),
      border: _border(AppPallete.gradient2),
      errorStyle: const TextStyle(color: AppPallete.errorColor),
    ),
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(AppPallete.backgroundColor),
      side: BorderSide.none,
    ),
  );
}
