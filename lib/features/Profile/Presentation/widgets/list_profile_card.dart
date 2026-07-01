import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/app/routing/app_routs.dart';
import 'package:khedma/core/constants/app_assets.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/extensions/num_extensions.dart';
import 'package:khedma/features/Profile/Presentation/widgets/profile_data_card.dart';

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
