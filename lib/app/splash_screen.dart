import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khedma/Core/Theme/app_colors.dart';
import 'package:khedma/Core/constants/app_assets.dart';
import 'package:khedma/Core/design_system/tokens/app_spacing.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryLight, AppColors.background],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: 1,
            duration: Duration(seconds: 2),
            child: SvgPicture.asset(
              AppAssets.logo,
              width: AppSpacing.w_127,
              height: AppSpacing.h_106,
            ),
          ),
        ),
      ),
    );
  }
}
