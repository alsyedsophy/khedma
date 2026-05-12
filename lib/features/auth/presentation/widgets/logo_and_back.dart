import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/extensions/num_extensions.dart';
import 'package:khedma/features/auth/presentation/widgets/app_logo_widget.dart';

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
        AppLogoWidget(),
      ],
    );
  }
}
