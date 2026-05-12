import 'package:flutter/material.dart';
import 'package:khedma/core/Utils/validators.dart';
import 'package:khedma/core/Widgets/app_text_form_field.dart';

class NameField extends StatelessWidget {
  const NameField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      hint: 'Enter Your Name.',
      validator: (value) =>
          Validators.validateName(value), // أو validateRequired
      keyboardType: TextInputType.name,
      prefixIcon: Icons.person,
    );
  }
}
