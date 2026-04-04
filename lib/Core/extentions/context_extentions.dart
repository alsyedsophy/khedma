import 'package:flutter/material.dart';
import 'package:khedma/Core/design_system/tokens/app_color.dart';
import 'package:khedma/Core/design_system/tokens/app_spacing.dart';
import 'package:khedma/Core/extentions/num_extentions.dart';
import 'package:khedma/Core/extentions/widget_extentions.dart';

extension ContextExtensions on BuildContext {
  // MediaQuery
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  bool get isSmallScreen => screenWidth < 360;

  // Theme
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  // SnackBars
  void showSnackBar(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: AppColors.lightBackground),
            AppSpacing.w_8.horizontalSpace,
            Text(message).paddingAll(10),
          ],
        ),
        backgroundColor: color,
      ),
    );
  }

  void showSuccess(String message) {
    showSnackBar(message, AppColors.success, Icons.check_circle_outline);
  }

  void showError(String message) {
    showSnackBar(message, AppColors.error, Icons.error_outline);
  }

  void showWarning(String message) {
    showSnackBar(message, AppColors.warning, Icons.warning_amber_outlined);
  }

  void showInfo(String message) {
    showSnackBar(message, AppColors.info, Icons.info_outline);
  }
}
