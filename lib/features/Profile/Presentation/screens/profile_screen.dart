import 'package:flutter/material.dart';
import 'package:khedma/Core/design_system/tokens/app_spacing.dart';
import 'package:khedma/Core/extentions/app_extentions.dart';
import 'package:khedma/features/auth/presentation/screens/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.h_24.verticalSpace,
            LogoAndBack(),
            AppSpacing.h_24.verticalSpace,
            Text("Profile screen"),
          ],
        ).paddingHorizontal(AppSpacing.w_24),
      ),
    );
  }
}
