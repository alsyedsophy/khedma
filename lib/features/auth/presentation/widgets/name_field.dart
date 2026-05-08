import 'package:flutter/material.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/Utils/validators.dart'; // تأكد أن فيه validateName
import 'package:khedma/core/Widgets/app_text_form_field.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';

class NameField extends StatelessWidget {
  const NameField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      height: AppSpacing.h_56,
      hintText: 'Enter Your Name.',
      validator: (value) =>
          Validators.validateName(value), // أو validateRequired
      keyboardType: TextInputType.name,
      prefixIcon: const Icon(Icons.person, color: AppColors.grey400),
    );
  }
}
