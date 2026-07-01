import 'package:flutter/material.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/constants/app_assets.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';
import 'package:khedma/core/extensions/num_extensions.dart';

class AppLogoutWidget extends StatelessWidget {
  const AppLogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: AppSpacing.h_56,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.w_10,
          vertical: AppSpacing.h_6,
        ),
        decoration: BoxDecoration(
          borderRadius: AppSpacing.r_12.borderRaduis,
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: AppSpacing.r_16,
              backgroundImage: AssetImage(AppAssets.woman),
            ),
            AppSpacing.w_12.horizontalSpace,
            Text(
              'Logout',
              style: AppTypography.lableLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
