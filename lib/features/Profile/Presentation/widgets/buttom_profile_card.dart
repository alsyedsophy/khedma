import 'package:flutter/material.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/extensions/num_extensions.dart';

class ButtomProfileCard extends StatelessWidget {
  const ButtomProfileCard({super.key, required this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSpacing.h_44,
        width: AppSpacing.w_44,
        decoration: BoxDecoration(
          borderRadius: AppSpacing.r_6.borderRaduis,
          color: AppColors.primary,
        ),
        child: Icon(
          Icons.arrow_forward_ios,
          size: AppSpacing.s_25,
          color: AppColors.background,
        ),
      ),
    );
  }
}
