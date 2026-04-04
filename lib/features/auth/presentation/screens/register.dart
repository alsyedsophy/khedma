import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/Core/Theme/app_colors.dart';
import 'package:khedma/Core/Utils/validators.dart';
import 'package:khedma/Core/Widgets/app_button.dart';
import 'package:khedma/Core/Widgets/app_loading.dart';
import 'package:khedma/Core/constants/app_emums.dart';
import 'package:khedma/Core/design_system/tokens/app_spacing.dart';
import 'package:khedma/Core/design_system/tokens/app_typography.dart';
import 'package:khedma/Core/extentions/app_extentions.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_state.dart';
import 'package:khedma/features/auth/presentation/screens/login.dart';
import 'package:khedma/features/auth/presentation/widgets/app_text_form_field.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.userType});

  final UserType userType;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().registerWithEmail(
        widget.userType,
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        builder: (context, state) {
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
                      'Enter your email and password to Register.',
                      style: AppTypography.headlineSmall,
                    ),
                    AppSpacing.h_30.verticalSpace,
                    AppTextFormField(
                      controller: _nameController,
                      height: AppSpacing.h_56,
                      hintText: 'Full name',
                      keyboardType: TextInputType.name,
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: AppColors.grey400,
                      ),
                      validator: (value) => Validators.validateName(value),
                    ),
                    AppSpacing.h_16.verticalSpace,
                    AppTextFormField(
                      controller: _emailController,
                      height: AppSpacing.h_56,
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: AppColors.grey400,
                      ),
                      validator: (value) => Validators.validateEmail(value),
                    ),
                    AppSpacing.h_16.verticalSpace,
                    AppTextFormField(
                      controller: _passwordController,
                      height: AppSpacing.h_56,
                      hintText: 'Enter Password',
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                      prefixIcon: Icon(
                        Icons.lock_clock_outlined,
                        color: AppColors.grey400,
                      ),
                      validator: (value) => Validators.validatePassword(value),
                    ),
                    AppSpacing.h_16.verticalSpace,
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) => setState(() {
                            _agreeToTerms = value ?? false;
                          }),
                          checkColor: AppColors.primary,
                          activeColor: AppColors.primaryLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppSpacing.r_2.borderRaduis,
                          ),
                          side: BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'I agree with fixit\'s ',
                            style: AppTypography.bodyMedium,
                            children: [
                              TextSpan(
                                text: 'Term ',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.info,
                                ),
                              ),
                              TextSpan(
                                text: '& ',
                                style: AppTypography.bodyMedium,
                              ),
                              TextSpan(
                                text: 'Conditions',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.info,
                                ),
                              ),
                            ],
                          ),
                        ).flexible,
                      ],
                    ),
                    AppSpacing.h_24.verticalSpace,
                    AppButton(
                      label: 'Sign Up',
                      onPressed: _agreeToTerms ? () => _register : null,
                    ),
                    AppSpacing.h_30.verticalSpace,
                    Center(
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
                    ),
                    AppSpacing.h_24.verticalSpace,
                    Row(
                      children: [
                        Divider().flexible,
                        AppSpacing.w_8.horizontalSpace,
                        Text(' Or ', style: AppTypography.bodyMedium),
                        AppSpacing.w_8.horizontalSpace,
                        Divider().flexible,
                      ],
                    ),
                    AppSpacing.h_12.verticalSpace,
                    Center(
                      child: Text(
                        'Sign up With',
                        style: AppTypography.bodyLarge,
                      ),
                    ),
                    AppSpacing.h_12.verticalSpace,
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
                        ),
                      ],
                    ),
                  ],
                ).paddingHorizontal(AppSpacing.w_24),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage.toString(),
                  style: AppTypography.bodySmall,
                ),
              ),
            );
            context.read<AuthCubit>().clearMessages();
          }
        },
      ),
    );
  }
}
