import 'package:flutter/material.dart';
import 'package:khedma/Core/Widgets/app_button.dart';
import 'package:khedma/Core/design_system/tokens/app_color.dart';
import 'package:khedma/Core/design_system/tokens/app_spacing.dart';
import 'package:khedma/Core/design_system/tokens/app_typography.dart';
import 'package:khedma/Core/extentions/app_extentions.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: AppSpacing.s_64,
            color: AppColors.error,
          ),
          AppSpacing.h_16.verticalSpace,
          Text(
            message,
            style: AppTypography.bodyLarge,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            AppSpacing.h_24.verticalSpace,
            AppButton(
              label: 'اعادة المحاوله',
              onPressed: onRetry,
              width: AppSpacing.w_64,
            ),
          ],
        ],
      ).paddingAll(AppSpacing.h_24),
    );
  }
}
