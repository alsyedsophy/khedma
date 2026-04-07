import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/Core/Theme/app_colors.dart';
import 'package:khedma/Core/Widgets/app_button.dart';
import 'package:khedma/Core/design_system/tokens/app_spacing.dart';
import 'package:khedma/Core/design_system/tokens/app_typography.dart';
import 'package:khedma/Core/extentions/num_extentions.dart';
import 'package:khedma/Core/extentions/widget_extentions.dart';
import 'package:khedma/features/auth/presentation/Mixin/auth_event_listener_mixin.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_state.dart';
import 'package:khedma/features/auth/presentation/cubit/Verify%20Email/verify_email_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Verify%20Email/verify_email_state.dart';
import 'package:khedma/features/auth/presentation/screens/login.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyEmailCubit(),
      child: const _VerifyEmailView(),
    );
  }
}

class _VerifyEmailView extends StatefulWidget {
  const _VerifyEmailView();

  @override
  State<_VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<_VerifyEmailView>
    with AuthEventListenerMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.h_24.verticalSpace,
            const LogoAndBack(),
            AppSpacing.h_36.verticalSpace,

            Text(
              'We sent a verification email. Please check it then click "Checked".',
              style: AppTypography.headlineMedium,
            ),

            AppSpacing.h_48.verticalSpace,

            AppButton(
              label: 'Checked',
              onPressed: () => context.read<AuthCubit>().checkEmailVerified(),
            ),

            AppSpacing.h_12.verticalSpace,

            const _ResendSection(),
          ],
        ).paddingHorizontal(AppSpacing.h_24),
      ),
    );
  }
}

class _ResendSection extends StatelessWidget {
  const _ResendSection();

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

class CircularTimer extends StatelessWidget {
  final int secondsLeft;
  final int totalSeconds;

  const CircularTimer({
    super.key,
    required this.secondsLeft,
    this.totalSeconds = 60,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (secondsLeft / totalSeconds).clamp(0.0, 1.0);

    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            backgroundColor: Colors.grey.shade300,
            color: AppColors.primary,
          ),
          Text("$secondsLeft", style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}
