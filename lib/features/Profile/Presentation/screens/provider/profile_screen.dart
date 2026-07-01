import 'package:flutter/material.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/constants/app_assets.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';
import 'package:khedma/core/extensions/app_extensions.dart';
import 'package:khedma/features/Profile/Presentation/widgets/app_logout_widget.dart';
import 'package:khedma/features/Profile/Presentation/widgets/list_profile_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.h_24.verticalSpace,
            Text(
              "My Profile",
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
            AppSpacing.h_10.verticalSpace,
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: AppSpacing.r_50,

                    backgroundImage: AssetImage(AppAssets.woman),
                  ),
                  AppSpacing.h_4.verticalSpace,
                  Text(
                    'Name',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.h_12.verticalSpace,
            ListProfileCard(),
            AppLogoutWidget(),
          ],
        ).paddingHorizontal(AppSpacing.w_24),
      ),
    );
  }
}
