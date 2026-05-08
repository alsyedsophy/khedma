import 'package:flutter/material.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';

class SocialLoginButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback? onTap;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey500, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 22,
              height: 22,
              errorBuilder: (_, _, _) => const Icon(Icons.public, size: 22),
            ),
            const SizedBox(width: 8),
            Text(label, style: AppTypography.headlineSmall),
          ],
        ),
      ),
    );
  }
}
