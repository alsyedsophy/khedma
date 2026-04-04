import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khedma/Core/Theme/app_colors.dart';
import 'package:khedma/Core/Utils/validators.dart';
import 'package:khedma/Core/design_system/tokens/app_spacing.dart';
import 'package:khedma/Core/extentions/app_extentions.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_state.dart';
import 'package:khedma/features/auth/presentation/screens/login.dart';
import 'package:khedma/features/auth/presentation/widgets/app_text_form_field.dart';

/// صفحة إكمال الملف الشخصي (الاسم، الهاتف، الصورة)
class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  XFile? _imageFile;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  /// اختيار صورة من المعرض
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  /// حفظ البيانات وتحديث الملف الشخصي
  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        image: _imageFile,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            context.read<AuthCubit>().clearMessages();
          } else if (state.successMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
            context.read<AuthCubit>().clearMessages();
          }
        },
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.h_24.verticalSpace,
                LogoAndBack(),
                AppSpacing.h_24.verticalSpace,
                // صورة المستخدم
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: AppSpacing.r_50,
                      backgroundColor: AppColors.primaryLight,
                      backgroundImage: _imageFile != null
                          ? FileImage(File(_imageFile!.path))
                          : null,
                      child: _imageFile == null
                          ? Icon(
                              Icons.camera_alt,
                              size: AppSpacing.s_30,
                              color: AppColors.primary,
                            )
                          : null,
                    ),
                  ),
                ),
                AppSpacing.h_24.verticalSpace,

                AppTextFormField(
                  controller: _nameController,
                  height: AppSpacing.h_56,
                  hintText: 'Enter your name',
                  keyboardType: TextInputType.name,
                  validator: (value) => Validators.validateName(value),
                  prefixIcon: Icon(Icons.person_2_outlined),
                ),
                AppSpacing.h_12.verticalSpace,
                AppTextFormField(
                  controller: _phoneController,
                  height: AppSpacing.h_56,
                  hintText: 'Enter your phone',
                  keyboardType: TextInputType.phone,
                  validator: (value) => Validators.validateName(value),
                  prefixIcon: Icon(Icons.phone_callback_outlined),
                ),
                AppSpacing.h_12.verticalSpace,
                AppTextFormField(
                  controller: _addressController,
                  height: AppSpacing.h_56,
                  hintText: 'Enter your Address',

                  keyboardType: TextInputType.text,
                  validator: (value) => Validators.validateName(value),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),

                AppSpacing.h_24.verticalSpace,
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.isLoading ? null : _submit,
                      child: state.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('حفظ'),
                    );
                  },
                ),
              ],
            ).paddingHorizontal(AppSpacing.w_24),
          ),
        ),
      ),
    );
  }
}
