import 'package:flutter/material.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/Utils/validators.dart';
import 'package:khedma/core/Widgets/app_text_form_field.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';

class EmailField extends StatelessWidget {
  const EmailField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      height: AppSpacing.h_56,
      hintText: 'Enter Your Email.',
      validator: (value) => Validators.validateEmail(value),
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_rounded, color: AppColors.grey400),
    );
  }
}
