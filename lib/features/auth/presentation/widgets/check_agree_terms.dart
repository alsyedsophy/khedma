import 'package:flutter/material.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/extensions/num_extensions.dart';
import 'package:khedma/core/extensions/widget_extensions.dart';
import 'package:khedma/features/auth/presentation/widgets/agree_trems.dart';

class CheckAgreeTerms extends StatelessWidget {
  const CheckAgreeTerms({
    super.key,
    required this.agreeToTerms,
    required this.onChanged,
  });
  final bool agreeToTerms;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: agreeToTerms,
          onChanged: onChanged,
          checkColor: AppColors.primary,
          activeColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.r_2.borderRaduis,
          ),
          side: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        const AgreeTrems().flexible,
      ],
    );
  }
}
