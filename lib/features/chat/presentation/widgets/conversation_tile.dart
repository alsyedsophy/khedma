import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/app/routing/app_routs.dart';
import 'package:khedma/core/constants/app_assets.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';
import 'package:khedma/core/extensions/num_extensions.dart';
import 'package:khedma/features/chat/domain/entities/conversation_entity.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({super.key, this.conversation});

  final ConversationEntity? conversation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.providerChat),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSpacing.r_16,
            backgroundImage: AssetImage(AppAssets.woman),
          ),
          AppSpacing.w_16.horizontalSpace,
          Text('Last Message', style: AppTypography.headlineSmall),
        ],
      ),
    );
  }
}
