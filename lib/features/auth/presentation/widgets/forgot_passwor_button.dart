import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/app/routing/app_routs.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => context.pushNamed(AppRoutes.forgotPassword),
        child: Text(
          'Forgot Password?',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
        ),
      ),
    );
  }
}
