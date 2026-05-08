import 'package:flutter/material.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/Utils/validators.dart';
import 'package:khedma/core/Widgets/app_text_form_field.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      height: AppSpacing.h_56,
      hintText: 'Enter Your Password.',
      validator: (value) => Validators.validatePassword(value),
      isPassword: true,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(
        Icons.lock_clock_outlined,
        color: AppColors.grey400,
      ),
    );
  }
}
