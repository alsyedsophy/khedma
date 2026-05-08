import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/core/constants/app_assets.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/extensions/num_extensions.dart';

class LogoAndBack extends StatelessWidget {
  const LogoAndBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        AppSpacing.w_8.horizontalSpace,
        SvgPicture.asset(
          AppAssets.logo,
          width: AppSpacing.w_28,
          height: AppSpacing.h_30,
        ),
      ],
    );
  }
}
