import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/Core/Theme/app_colors.dart';
import 'package:khedma/Core/Utils/validators.dart';
import 'package:khedma/Core/Widgets/app_button.dart';
import 'package:khedma/Core/Widgets/app_loading.dart';
import 'package:khedma/Core/constants/app_assets.dart';
import 'package:khedma/Core/constants/app_emums.dart';
import 'package:khedma/Core/design_system/tokens/app_spacing.dart';
import 'package:khedma/Core/design_system/tokens/app_typography.dart';
import 'package:khedma/Core/extentions/app_extentions.dart';
import 'package:khedma/Core/routing/app_routs.dart';
import 'package:khedma/features/auth/presentation/Mixin/auth_event_listener_mixin.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_state.dart';
import 'package:khedma/features/auth/presentation/widgets/app_text_form_field.dart';

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
                    LogoAndBack(),
                    AppSpacing.h_36.verticalSpace,
                    Text(
                      'Enter your email and password to login',
                      style: AppTypography.headlineSmall,
                    ),
                    AppSpacing.h_30.verticalSpace,
                    AppTextFormField(
                      controller: _emailController,
                      height: AppSpacing.h_56,
                      hintText: 'Enter Your Email.',
                      validator: (value) => Validators.validateEmail(value),
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.email_rounded,
                        color: AppColors.grey400,
                      ),
                    ),
                    AppSpacing.h_16.verticalSpace,
                    AppTextFormField(
                      controller: _passwordController,
                      height: AppSpacing.h_56,
                      hintText: 'Enter Your Password.',
                      validator: (value) => Validators.validatePassword(value),
                      isPassword: true,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.lock_clock_outlined,
                        color: AppColors.grey400,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            context.pushNamed(AppRoutes.forgotPassword),

                        child: Text(
                          'Forgot Password?',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                      ),
                    ),
                    AppSpacing.h_24.verticalSpace,
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return AppButton(
                          label: 'SignIn',
                          onPressed: state.isLoading ? null : _login,
                        );
                      },
                    ),
                    AppSpacing.h_24.verticalSpace,
                    Center(
                      child: GestureDetector(
                        onTap: () => context.pushNamed(
                          AppRoutes.register,
                          extra: widget.userType,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'New in Fixit? ',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.grey700,
                            ),
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
                    ),
                    AppSpacing.h_24.verticalSpace,
                    Row(
                      children: [
                        Divider().expanded,
                        AppSpacing.w_8.horizontalSpace,
                        Text(
                          'or',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.grey700,
                          ),
                        ),
                        AppSpacing.w_8.horizontalSpace,
                        Divider().expanded,
                      ],
                    ),
                    AppSpacing.h_24.verticalSpace,
                    Center(
                      child: Text(
                        'Log in with',
                        style: AppTypography.bodyLarge,
                      ),
                    ),
                    AppSpacing.h_24.verticalSpace,
                    Row(
                      children: [
                        SocialLoginButton(
                          label: 'Google',
                          imagePath: 'imagePath',
                          onTap: () => context
                              .read<AuthCubit>()
                              .loginWithGoogle(widget.userType),
                        ).expanded,
                        AppSpacing.w_16.horizontalSpace,
                        SocialLoginButton(
                          label: 'Facebook',
                          imagePath: 'imagePath',
                          onTap: () => context
                              .read<AuthCubit>()
                              .loginWithFacebook(widget.userType),
                        ).expanded,
                      ],
                    ),
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

class LogoAndBack extends StatelessWidget {
  const LogoAndBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        AppSpacing.w_8.horizontalSpace,
        SvgPicture.asset(
          AppAssets.logo,
          width: AppSpacing.w_28,
          height: AppSpacing.h_30,
        ),
      ],
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String label;
  final String imagePath; // asset path to the icon image
  final VoidCallback? onTap;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey500, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 22,
              height: 22,
              errorBuilder: (_, _, _) => const Icon(Icons.public, size: 22),
            ),
            const SizedBox(width: 8),
            Text(label, style: AppTypography.headlineSmall),
          ],
        ),
      ),
    );
  }
}
