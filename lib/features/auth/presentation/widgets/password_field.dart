import 'package:flutter/material.dart';
import 'package:khedma/core/Utils/validators.dart';
import 'package:khedma/core/Widgets/app_text_form_field.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      hint: 'Enter Your Password.',
      validator: (value) => Validators.validatePassword(value),
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.lock_clock_outlined,
    );
  }
}
