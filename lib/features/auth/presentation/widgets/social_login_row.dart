import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/constants/app_emums.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/extensions/app_extensions.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/widgets/social_login_button.dart';

class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key, required this.userType});
  final UserType userType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SocialLoginButton(
          label: 'Google',
          imagePath: 'imagePath',
          onTap: () => context.read<AuthCubit>().loginWithGoogle(userType),
        ).expanded,
        AppSpacing.w_16.horizontalSpace,
        SocialLoginButton(
          label: 'Facebook',
          imagePath: 'imagePath',
          onTap: () => context.read<AuthCubit>().loginWithFacebook(userType),
        ).expanded,
      ],
    );
  }
}
