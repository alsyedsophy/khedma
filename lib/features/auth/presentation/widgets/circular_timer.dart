import 'package:flutter/material.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';

class CircularTimer extends StatelessWidget {
  final int secondsLeft;
  final int totalSeconds;

  const CircularTimer({
    super.key,
    required this.secondsLeft,
    this.totalSeconds = 60,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (secondsLeft / totalSeconds).clamp(0.0, 1.0);

    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            backgroundColor: Colors.grey.shade300,
            color: AppColors.primary,
          ),
          Text("$secondsLeft", style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}
