import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/app/routing/app_routs.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/constants/app_assets.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';
import 'package:khedma/core/extensions/app_extensions.dart';

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
            ListProfileCard(),

            AppLogoutWidget(),
          ],
        ).paddingHorizontal(AppSpacing.w_24),
      ),
    );
  }
}

class ListProfileCard extends StatelessWidget {
  const ListProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileDataCard(
          onTap: () => context.pushNamed(AppRoutes.editingProfile),
          title: 'Edit Profile',
          imageUrl: AppAssets.woman,
        ),
        AppSpacing.h_12.verticalSpace,
        ProfileDataCard(
          onTap: () {},
          title: 'Notification',
          imageUrl: AppAssets.woman,
        ),
        AppSpacing.h_12.verticalSpace,
        ProfileDataCard(
          onTap: () {},
          title: 'Payment method',
          imageUrl: AppAssets.woman,
        ),
        AppSpacing.h_12.verticalSpace,
        ProfileDataCard(
          onTap: () {},
          title: 'Help & support',
          imageUrl: AppAssets.woman,
        ),
        AppSpacing.h_12.verticalSpace,
      ],
    );
  }
}

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
          GestureDetector(
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
          ),
        ],
      ),
    );
  }
}
