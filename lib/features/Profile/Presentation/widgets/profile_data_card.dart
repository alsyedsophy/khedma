import 'package:flutter/material.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';
import 'package:khedma/core/extensions/num_extensions.dart';
import 'package:khedma/features/Profile/Presentation/widgets/buttom_profile_card.dart';

class ProfileDataCard extends StatelessWidget {
  const ProfileDataCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.imageUrl,
  });
  final String title;
  final String imageUrl;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            backgroundImage: AssetImage(imageUrl),
          ),
          AppSpacing.w_12.horizontalSpace,
          Text(
            title,
            style: AppTypography.lableLarge.copyWith(color: AppColors.black),
          ),
          Spacer(),
          ButtomProfileCard(onTap: onTap),
        ],
      ),
    );
  }
}
