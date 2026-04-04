import 'package:flutter/widgets.dart';
import 'package:khedma/Core/design_system/tokens/app_spacing.dart';
import 'package:khedma/Core/design_system/tokens/app_typography.dart';
import 'package:khedma/Core/extentions/app_extentions.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    this.action,
  });

  final String title;
  final String? subTitle;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(icon, size: AppSpacing.s_80),
          Text(
            title,
            style: AppTypography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          if (subTitle != null) ...[
            AppSpacing.h_16.verticalSpace,
            Text(
              subTitle!,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[AppSpacing.h_16.verticalSpace, action!],
        ],
      ).paddingAll(AppSpacing.h_24),
    );
  }
}
