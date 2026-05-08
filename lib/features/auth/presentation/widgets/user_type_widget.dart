import 'package:flutter/material.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';
import 'package:khedma/core/extensions/num_extensions.dart';

class UserTypeWidget extends StatelessWidget {
  const UserTypeWidget({
    super.key,
    required this.selected,
    required this.userType,
    required this.title,
  });

  final bool selected;
  final String userType;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSpacing.h_152,
      padding: AppSpacing.h_12.allPadding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.grey400,
        ),
        borderRadius: AppSpacing.r_10.borderRaduis,
        color: selected ? AppColors.primaryLight : AppColors.background,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(userType, style: AppTypography.headlineMedium),
              AppSpacing.h_6.verticalSpace,
              Text(title, style: AppTypography.bodyMedium),
            ],
          ),
          Icon(
            Icons.check,
            size: AppSpacing.s_20,
            color: selected ? AppColors.primary : AppColors.grey400,
          ),
        ],
      ),
    );
  }
}
