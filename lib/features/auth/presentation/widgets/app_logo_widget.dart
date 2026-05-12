import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khedma/core/constants/app_assets.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.logo,
      width: AppSpacing.w_28,
      height: AppSpacing.h_30,
    );
  }
}
