import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/Widgets/app_button.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';
import 'package:khedma/core/extensions/num_extensions.dart';
import 'package:khedma/core/extensions/widget_extensions.dart';
import 'package:khedma/features/auth/presentation/Mixin/auth_event_listener_mixin.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Verify%20Email/verify_email_cubit.dart';
import 'package:khedma/features/auth/presentation/widgets/logo_and_back.dart';
import 'package:khedma/features/auth/presentation/widgets/resend_section.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyEmailCubit()..startTimer(),
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

            const ResendSection(),
          ],
        ).paddingHorizontal(AppSpacing.h_24),
      ),
    );
  }
}
