import 'package:flutter/material.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/extensions/app_extensions.dart';
import 'package:khedma/features/auth/presentation/widgets/logo_and_back.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
            Text('chating'),
          ],
        ).paddingHorizontal(AppSpacing.w_24),
      ),
    );
  }
}
