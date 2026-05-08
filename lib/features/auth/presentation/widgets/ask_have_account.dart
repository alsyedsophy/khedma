import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';

class AskHaveAccount extends StatelessWidget {
  const AskHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => context.pop(),
        child: RichText(
          text: TextSpan(
            text: 'Already have an acount? ',
            style: AppTypography.bodyMedium,
            children: [
              TextSpan(
                text: 'Login now',
                style: AppTypography.bodyMedium.copyWith(
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
