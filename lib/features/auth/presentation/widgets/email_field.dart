import 'package:flutter/material.dart';
import 'package:khedma/core/Utils/validators.dart';
import 'package:khedma/core/Widgets/app_text_form_field.dart';

class EmailField extends StatelessWidget {
  const EmailField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      hint: 'Enter Your Email.',
      validator: (value) => Validators.validateEmail(value),
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.email_rounded,
    );
  }
}
