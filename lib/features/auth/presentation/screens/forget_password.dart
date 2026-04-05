import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/Core/Utils/validators.dart';
import 'package:khedma/Core/Widgets/app_button.dart';
import 'package:khedma/Core/Widgets/app_loading.dart';
import 'package:khedma/Core/design_system/tokens/app_spacing.dart';
import 'package:khedma/Core/design_system/tokens/app_typography.dart';
import 'package:khedma/Core/extentions/app_extentions.dart';
import 'package:khedma/features/auth/presentation/Mixin/auth_event_listener_mixin.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_state.dart';
import 'package:khedma/features/auth/presentation/screens/login.dart';
import 'package:khedma/features/auth/presentation/widgets/app_text_form_field.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>
    with AuthEventListenerMixin {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _forget() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().forgotPassword(_emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Enter your email address to verify.',
                      style: AppTypography.bodyLarge,
                    ),
                    AppSpacing.h_48.verticalSpace,
                    AppTextFormField(
                      controller: _emailController,
                      height: AppSpacing.h_56,
                      hintText: 'Enter your email.',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(Icons.email_outlined),
                      validator: (value) => Validators.validateEmail(value),
                    ),
                    AppSpacing.h_84.verticalSpace,
                    AppButton(label: 'Send Code', onPressed: () => _forget()),
                  ],
                ).paddingHorizontal(AppSpacing.h_24),
              ),
            ),
          );
        },
      ),
    );
  }
}
