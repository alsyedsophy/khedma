import 'package:flutter/material.dart';
import 'package:khedma/Core/design_system/tokens/app_color.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? AppColors.primary,
        strokeWidth: 2.5,
      ),
    );
  }
}

class FullScreenLoading extends StatelessWidget {
  const FullScreenLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AppLoading());
  }
}

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
  });
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: AppLoading(color: AppColors.lightBackground),
          ),
        ],
      ],
    );
  }
}
