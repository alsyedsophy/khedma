import 'package:flutter/material.dart';
import 'package:khedma/Core/design_system/extensions/app_theme_extensions.dart';
import 'package:khedma/Core/design_system/tokens/app_color.dart';
import 'package:khedma/Core/design_system/tokens/app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.primary,
    textTheme: AppTypography.lightTextTheme,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.lightSurface,
      error: AppColors.error,
    ),
    extensions: [
      AppThemeExtensions(
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        textColor: AppColors.lightTextPrimary,
      ),
    ],
  );
}
