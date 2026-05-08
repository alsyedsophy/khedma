import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/Utils/validators.dart';
import 'package:khedma/core/Widgets/app_button.dart';
import 'package:khedma/core/Widgets/app_loading.dart';
import 'package:khedma/core/constants/app_emums.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';
import 'package:khedma/core/extensions/app_extensions.dart';
import 'package:khedma/app/routing/app_routs.dart';
import 'package:khedma/features/auth/presentation/Mixin/auth_event_listener_mixin.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_state.dart';
import 'package:khedma/features/auth/presentation/widgets/forgot_passwor_button.dart';

// UI components extracted to separate widgets
import 'package:khedma/features/auth/presentation/widgets/logo_and_back.dart';
import 'package:khedma/features/auth/presentation/widgets/email_field.dart';
import 'package:khedma/features/auth/presentation/widgets/password_field.dart';
import 'package:khedma/features/auth/presentation/widgets/sign_in_button.dart';
import 'package:khedma/features/auth/presentation/widgets/sign_up_prompt.dart';
import 'package:khedma/features/auth/presentation/widgets/or_divider.dart';
import 'package:khedma/features/auth/presentation/widgets/social_login_row.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.userType});
  final UserType userType;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with AuthEventListenerMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().loginWithEmail(
        widget.userType,
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          log(state.toString());
          return AppLoadingOverlay(
            isLoading: state.isLoading,
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.h_24.verticalSpace,
                    const LogoAndBack(),
                    AppSpacing.h_36.verticalSpace,
                    Text(
                      'Enter your email and password to login',
                      style: AppTypography.headlineSmall,
                    ),
                    AppSpacing.h_30.verticalSpace,
                    EmailField(controller: _emailController),
                    AppSpacing.h_16.verticalSpace,
                    PasswordField(controller: _passwordController),
                    const ForgotPasswordButton(),
                    AppSpacing.h_24.verticalSpace,
                    SignInButton(onSignIn: _login),
                    AppSpacing.h_24.verticalSpace,
                    SignUpPrompt(userType: widget.userType),
                    AppSpacing.h_24.verticalSpace,
                    const OrDivider(),
                    AppSpacing.h_24.verticalSpace,
                    Center(
                      child: Text(
                        'Log in with',
                        style: AppTypography.bodyLarge,
                      ),
                    ),
                    AppSpacing.h_24.verticalSpace,
                    SocialLoginRow(userType: widget.userType),
                  ],
                ).paddingHorizontal(AppSpacing.w_24),
              ),
            ),
          );
        },
      ),
    );
  }
}
