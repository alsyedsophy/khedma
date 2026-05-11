import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/app/routing/app_routs.dart';
import 'package:khedma/core/Widgets/app_button.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';
import 'package:khedma/core/extensions/num_extensions.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text('الصفحه غير موجوده', style: AppTypography.bodyLarge),
              AppSpacing.h_30.verticalSpace,
              AppButton(
                label: 'الذهاب الى الصفحه الرئيسيه',
                onPressed: () => context.goNamed(AppRoutes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
