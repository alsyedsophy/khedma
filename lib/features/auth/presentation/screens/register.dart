import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/Widgets/app_button.dart';
import 'package:khedma/core/Widgets/app_loading.dart';
import 'package:khedma/core/constants/app_emums.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';
import 'package:khedma/core/extensions/app_extensions.dart';
import 'package:khedma/features/auth/presentation/Mixin/auth_event_listener_mixin.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_state.dart';
import 'package:khedma/features/auth/presentation/widgets/ask_have_account.dart';
import 'package:khedma/features/auth/presentation/widgets/check_agree_terms.dart';
import 'package:khedma/features/auth/presentation/widgets/email_field.dart';
import 'package:khedma/features/auth/presentation/widgets/logo_and_back.dart';
import 'package:khedma/features/auth/presentation/widgets/name_field.dart';
import 'package:khedma/features/auth/presentation/widgets/or_divider.dart';
import 'package:khedma/features/auth/presentation/widgets/password_field.dart';
import 'package:khedma/features/auth/presentation/widgets/social_login_row.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.userType});

  final UserType userType;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with AuthEventListenerMixin {
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
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<AuthCubit, AuthState>(
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
                    NameField(controller: _nameController),
                    AppSpacing.h_16.verticalSpace,
                    EmailField(controller: _emailController),
                    AppSpacing.h_16.verticalSpace,
                    PasswordField(controller: _passwordController),
                    AppSpacing.h_16.verticalSpace,
                    CheckAgreeTerms(
                      agreeToTerms: _agreeToTerms,
                      onChanged: (value) =>
                          setState(() => _agreeToTerms = value ?? false),
                    ),
                    AppSpacing.h_24.verticalSpace,
                    AppButton(
                      label: 'Sign Up',
                      onPressed: _agreeToTerms ? () => _register() : null,
                    ),
                    AppSpacing.h_30.verticalSpace,
                    AskHaveAccount(),
                    AppSpacing.h_24.verticalSpace,
                    OrDivider(),
                    AppSpacing.h_12.verticalSpace,
                    Center(
                      child: Text(
                        'Sign up With',
                        style: AppTypography.bodyLarge,
                      ),
                    ),
                    AppSpacing.h_12.verticalSpace,
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
