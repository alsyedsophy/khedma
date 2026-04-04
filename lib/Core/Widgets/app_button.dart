import 'package:flutter/material.dart';
import 'package:khedma/Core/design_system/tokens/app_color.dart';
import 'package:khedma/Core/design_system/tokens/app_spacing.dart';
import 'package:khedma/Core/design_system/tokens/app_typography.dart';
import 'package:khedma/Core/extentions/app_extentions.dart';

enum ButtonType { primary, secondry, text, outlined }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 56,
    this.context,
  });
  final String label;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final BuildContext? context;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
            ).paddingAll(AppSpacing.w_8),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppSpacing.s_20),
                AppSpacing.h_16.verticalSpace,
              ],
              Text(
                label,
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.lightBackground,
                ),
              ),
            ],
          );
    Widget button;
    switch (type) {
      case ButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,

          style: ElevatedButton.styleFrom(
            alignment: Alignment.center,
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.r_10.borderRaduis,
            ),
          ),
          child: child,
        );
        break;
      case ButtonType.secondry:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
          child: child,
        );
        break;
      case ButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
        break;
    }
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: button,
    );
  }
}
