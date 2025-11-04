import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    scaffoldBackgroundColor: AppColors.background,
    useMaterial3: true,
    fontFamily: 'Cairo',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0.2,
      foregroundColor: AppColors.textDark,
    ),
  );
}
