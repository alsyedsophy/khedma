import 'package:flutter/material.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/extensions/num_extensions.dart';

class BannerSearchBar extends StatelessWidget {
  const BannerSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -5,
      left: 0,
      right: 0,
      child: Container(
        height: AppSpacing.h_56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppSpacing.r_12.borderRaduis,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: AppSpacing.r_10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search here..',
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(Icons.search, color: AppColors.black),
            suffixIcon: const Icon(
              Icons.tune,
              color: AppColors.black,
            ), // أيقونة الفلتر
            border: InputBorder.none,
            contentPadding: AppSpacing.h_16.verticalPadding,
          ),
        ),
      ),
    );
  }
}
