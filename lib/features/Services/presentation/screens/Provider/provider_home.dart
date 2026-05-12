import 'package:flutter/material.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/Widgets/app_button.dart';
import 'package:khedma/core/Widgets/app_text_form_field.dart';
import 'package:khedma/core/constants/app_assets.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';
import 'package:khedma/core/extensions/app_extensions.dart';
import 'package:khedma/features/Services/presentation/widgets/banner_search_bar.dart';
import 'package:khedma/features/auth/presentation/widgets/app_logo_widget.dart';

class ProviderHome extends StatefulWidget {
  const ProviderHome({super.key});

  @override
  State<ProviderHome> createState() => _ProviderHomeState();
}

class _ProviderHomeState extends State<ProviderHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.h_24.verticalSpace,
              AppLogoWidget(),
              AppSpacing.h_30.verticalSpace,
              HomeBanner(),
              AppSpacing.h_24.verticalSpace,
              CustomPopulerService(),
              AppSpacing.h_24.verticalSpace,
              CustomServiceProvider(),
              AppSpacing.h_24.verticalSpace,
            ],
          ).paddingHorizontal(AppSpacing.w_24),
        ),
      ),
    );
  }
}

class CustomServiceProvider extends StatelessWidget {
  const CustomServiceProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopTitleCategory(title: 'Service Providers'),
        AppSpacing.h_12.verticalSpace,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: AppSpacing.h_230,
            child: Row(
              children: List.generate(
                5,
                (index) => Container(
                  height: AppSpacing.h_222,
                  width: AppSpacing.w_156,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppSpacing.r_12.borderRaduis,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: AppSpacing.b_10,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: AppSpacing.h_116,
                        width: AppSpacing.w_124,
                        decoration: BoxDecoration(
                          borderRadius: AppSpacing.r_10.borderRaduis,
                          color: AppColors.secondaryLight,
                        ),
                        child: Image.asset(AppAssets.plumber),
                      ),
                      AppSpacing.h_6.verticalSpace,
                      Text('Maskot Kota', style: AppTypography.bodyLarge),
                      Text('Electrical', style: AppTypography.bodySmall),
                      AppSpacing.h_6.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.star,
                                color: AppColors.primary,
                                size: AppSpacing.s_20,
                              ),
                              Text(
                                '4.6',
                                style: AppTypography.lableLarge.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppSpacing.h_20,
                            width: AppSpacing.w_70,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                // alignment: Alignment.center,
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppSpacing.r_6.borderRaduis,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                'Details',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.background,
                                ),
                                maxLines: 1,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ).paddingAll(AppSpacing.w_16),
                ).paddingRight(AppSpacing.w_16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomPopulerService extends StatelessWidget {
  const CustomPopulerService({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopTitleCategory(title: 'Popular Service'),
        AppSpacing.h_12.verticalSpace,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: AppSpacing.h_106,
            child: Row(
              children: List.generate(
                3,
                (index) => Container(
                  height: AppSpacing.h_100,
                  width: AppSpacing.w_100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppSpacing.r_12.borderRaduis,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: AppSpacing.b_10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child:
                      Column(
                            children: [
                              Image.asset(
                                AppAssets.plumber,
                                fit: BoxFit.cover,
                                height: AppSpacing.h_60,
                                width: AppSpacing.w_60,
                              ),
                              AppSpacing.h_4.verticalSpace,
                              Text('Plumber', style: AppTypography.bodyMedium),
                            ],
                          )
                          .paddingHorizontal(AppSpacing.w_16)
                          .paddingVertical(AppSpacing.h_4),
                ).paddingHorizontal(AppSpacing.w_10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TopTitleCategory extends StatelessWidget {
  const TopTitleCategory({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.headlineSmall),
        Text(
          'View All',
          style: AppTypography.headlineSmall.copyWith(color: AppColors.info),
        ),
      ],
    );
  }
}

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: AppSpacing.h_180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF004AAD),
            borderRadius: AppSpacing.r_16.borderRaduis,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppSpacing.h_12.verticalSpace,
              Text(
                'Get 30% off',
                style: AppTypography.headlineMedium.copyWith(
                  color: Colors.white,
                ),
              ),
              AppSpacing.h_8.verticalSpace,
              SizedBox(
                width: AppSpacing
                    .w_180, // تحديد العرض لمنع النص من تغطية صورة البنت
                child: Text(
                  'Just by Booking Home Services',
                  style: AppTypography.bodyLarge.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),

        Positioned(
          right: AppSpacing.w_10,
          bottom: 0,
          child: Image.asset(
            AppAssets.woman,
            height: AppSpacing.h_220,
            fit: BoxFit.contain,
          ),
        ),

        BannerSearchBar(),
      ],
    );
  }
}
