import 'package:flutter/material.dart';

class AppThemeExtensions extends ThemeExtension<AppThemeExtensions> {
  final Color background;
  final Color surface;
  final Color textColor;

  AppThemeExtensions({
    required this.background,
    required this.surface,
    required this.textColor,
  });

  @override
  AppThemeExtensions copyWith({
    Color? background,
    Color? surface,
    Color? textColor,
  }) {
    return AppThemeExtensions(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  ThemeExtension<AppThemeExtensions> lerp(
    covariant ThemeExtension<AppThemeExtensions>? other,
    double t,
  ) {
    if (other is! AppThemeExtensions) return this;
    return AppThemeExtensions(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
    );
  }
}
