import 'package:flutter/material.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';
import 'package:khedma/core/extensions/app_extensions.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Divider().expanded,
        AppSpacing.w_8.horizontalSpace,
        Text(
          'or',
          style: AppTypography.bodyLarge.copyWith(color: AppColors.grey700),
        ),
        AppSpacing.w_8.horizontalSpace,
        const Divider().expanded,
      ],
    );
  }
}
