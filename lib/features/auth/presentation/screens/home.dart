import 'package:flutter/material.dart';
import 'package:khedma/Core/design_system/tokens/app_spacing.dart';
import 'package:khedma/Core/extentions/app_extentions.dart';
import 'package:khedma/Core/extentions/widget_extentions.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [AppSpacing.h_24.verticalSpace, Text('Home')],
        ).paddingHorizontal(AppSpacing.w_24),
      ),
    );
  }
}
