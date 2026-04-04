import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/Core/Theme/app_colors.dart';
import 'package:khedma/Core/Widgets/app_button.dart';
import 'package:khedma/Core/constants/app_assets.dart';
import 'package:khedma/Core/constants/app_emums.dart';
import 'package:khedma/Core/design_system/tokens/app_spacing.dart';
import 'package:khedma/Core/design_system/tokens/app_typography.dart';
import 'package:khedma/Core/extentions/app_extentions.dart';
import 'package:khedma/Core/routing/app_routs.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  bool isProvider = false;
  bool isService = false;
  UserType userType = UserType.provider;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.h_16.verticalSpace,
            SvgPicture.asset(
              AppAssets.logo,
              width: AppSpacing.w_28,
              height: AppSpacing.h_30,
            ),
            AppSpacing.h_30.verticalSpace,
            Text('I am', style: AppTypography.headlineLarge),
            AppSpacing.h_30.verticalSpace,
            GestureDetector(
              onTap: () {
                if (!isProvider && !isService) {
                  setState(() {
                    isProvider = !isProvider;
                    userType = UserType.provider;
                  });
                }
                if (isService && !isProvider) {
                  setState(() {
                    isProvider = !isProvider;
                    isService = !isService;
                    userType = UserType.provider;
                  });
                }
                context.read<AuthCubit>().completeOnboarding(userType);
              },
              child: UserTypeWidget(
                selected: isProvider,
                userType: 'Service Provider',
                title: 'I offer professional service',
              ),
            ),
            AppSpacing.h_16.verticalSpace,
            GestureDetector(
              onTap: () {
                if (!isProvider && !isService) {
                  setState(() {
                    isService = !isService;
                    userType = UserType.service;
                  });
                }
                if (isProvider && !isService) {
                  setState(() {
                    isProvider = !isProvider;
                    isService = !isService;
                    userType = UserType.service;
                  });
                }
                context.read<AuthCubit>().completeOnboarding(userType);
              },
              child: UserTypeWidget(
                selected: isService,
                userType: 'Looking For Service',
                title: 'I am looking for home service',
              ),
            ),
            AppSpacing.h_48.verticalSpace,
            AppButton(
              onPressed: () {
                if (isProvider || isService) {
                  context.pushNamed(AppRoutes.login, extra: userType);
                }
              },
              label: 'Next',
            ),
          ],
        ).paddingHorizontal(AppSpacing.w_24),
      ),
    );
  }
}

class UserTypeWidget extends StatelessWidget {
  const UserTypeWidget({
    super.key,
    required this.selected,
    required this.userType,
    required this.title,
  });

  final bool selected;
  final String userType;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSpacing.h_152,
      padding: AppSpacing.h_12.allPadding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.grey400,
        ),
        borderRadius: AppSpacing.r_10.borderRaduis,
        color: selected ? AppColors.primaryLight : AppColors.background,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(userType, style: AppTypography.headlineMedium),
              AppSpacing.h_6.verticalSpace,
              Text(title, style: AppTypography.bodyMedium),
            ],
          ),
          Icon(
            Icons.check,
            size: AppSpacing.s_20,
            color: selected ? AppColors.primary : AppColors.grey400,
          ),
        ],
      ),
    );
  }
}
