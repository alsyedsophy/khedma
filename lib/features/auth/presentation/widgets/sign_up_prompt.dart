import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/app/routing/app_routs.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/constants/app_emums.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';

class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({super.key, required this.userType});
  final UserType userType;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => context.pushNamed(AppRoutes.register, extra: userType),
        child: RichText(
          text: TextSpan(
            text: 'New in Fixit? ',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.grey700),
            children: [
              TextSpan(
                text: 'Sign up now.',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
