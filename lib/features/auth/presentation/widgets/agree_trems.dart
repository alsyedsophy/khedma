import 'package:flutter/material.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';

class AgreeTrems extends StatelessWidget {
  const AgreeTrems({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'I agree with fixit\'s ',
        style: AppTypography.bodyMedium,
        children: [
          TextSpan(
            text: 'Term ',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.info),
          ),
          TextSpan(text: '& ', style: AppTypography.bodyMedium),
          TextSpan(
            text: 'Conditions',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.info),
          ),
        ],
      ),
    );
  }
}
