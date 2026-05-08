import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';
import 'package:khedma/core/extensions/num_extensions.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Verify%20Email/verify_email_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Verify%20Email/verify_email_state.dart';
import 'package:khedma/features/auth/presentation/widgets/circular_timer.dart';

class ResendSection extends StatelessWidget {
  const ResendSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
      builder: (context, state) {
        final isFinished = state is VerifyEmailFinished;
        final seconds = state is VerifyEmailCounting ? state.secondsLeft : 0;

        return Row(
          children: [
            CircularTimer(secondsLeft: seconds),
            AppSpacing.w_8.horizontalSpace,

            Expanded(
              child: InkWell(
                onTap: isFinished
                    ? () {
                        context.read<AuthCubit>().sendEmailVerification();

                        context.read<VerifyEmailCubit>().resetTimer();
                      }
                    : null,
                child: RichText(
                  text: TextSpan(
                    text: 'Did not receive code? ',
                    style: AppTypography.bodyLarge,
                    children: [
                      TextSpan(
                        text: 'Send code',
                        style: AppTypography.bodyLarge.copyWith(
                          color: isFinished ? AppColors.primary : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
