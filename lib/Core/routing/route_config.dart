import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/Core/Widgets/app_button.dart';
import 'package:khedma/Core/constants/app_emums.dart';
import 'package:khedma/Core/design_system/tokens/app_spacing.dart';
import 'package:khedma/Core/design_system/tokens/app_typography.dart';
import 'package:khedma/Core/extentions/app_extentions.dart';
import 'package:khedma/Core/routing/app_routs.dart';
import 'package:khedma/Core/routing/router_notifier.dart';
import 'package:khedma/app/splash_screen.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_state.dart';
import 'package:khedma/features/auth/presentation/screens/complete_profile_page.dart';
import 'package:khedma/features/auth/presentation/screens/forget_password.dart';
import 'package:khedma/features/auth/presentation/screens/home.dart';
import 'package:khedma/features/auth/presentation/screens/location_picker.dart';
import 'package:khedma/features/auth/presentation/screens/login.dart';
import 'package:khedma/features/auth/presentation/screens/on_boarding.dart';
import 'package:khedma/features/auth/presentation/screens/register.dart';
import 'package:khedma/features/auth/presentation/screens/verify_email.dart';

class RouteConfig {
  final RouterNotifier notifier;
  RouteConfig({required this.notifier});

  late final goRouter = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    errorBuilder: (context, state) => _ErrorPage(),
    routes: _routes,
    redirect: _redirect,
  );

  // المسارات العامة (لا تحتاج تسجيل دخول)
  static const _publicRoutes = {
    AppRoutes.onboarding,
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.forgotPassword,
  };

  // مسارات الإعداد (تحتاج تسجيل دخول ولكن لم يكتمل الإعداد)
  static const _setupRoutes = {
    AppRoutes.verifyEmail,
    AppRoutes.mapPicker,
    AppRoutes.completeProfile,
  };

  String? _redirect(BuildContext context, GoRouterState state) {
    log('REDIRECTED CALLED');
    final authState = notifier.authState;
    final currentPath = state.uri.path;
    log(authState.toString());
    log(currentPath.toString());
    // إذا كانت الحالة غير معروفة (لا تزال تحميل)، لا نعيد توجيه
    if (authState.authStatus == AuthStatus.unknown ||
        authState.onboardingStatus == OnboardingStatus.unKnown) {
      return null;
    }
    log("isFirstTimeDone :  ${authState.isFirstTimeDone}");

    log("isFirstTime :  ${authState.isFirstTime}");
    // إذا كانت أول مرة → نذهب إلى onboarding
    if (authState.onboardingStatus == OnboardingStatus.firstTime) {
      if (currentPath == AppRoutes.onboarding) return null;
      return AppRoutes.onboarding;
    }
    if (authState.onboardingStatus == OnboardingStatus.done &&
        !authState.isLoggedIn) {
      if (_publicRoutes.contains(currentPath)) return null;
      return AppRoutes.login;
    }

    // إذا لم يكن مسجل الدخول → نسمح فقط بالمسارات العامة
    if (!authState.isLoggedIn) {
      log("isLoggedIn : ${authState.isLoggedIn}");
      if (_publicRoutes.contains(currentPath)) return null;
      return AppRoutes.login;
    }

    // إذا كان مسجل الدخول ولكن في مسار عام → نوجهه حسب حالته
    if (_publicRoutes.contains(currentPath)) {
      return _routeForStatus(authState.authStatus);
    }

    // فرض التدفق الإلزامي للإعداد
    switch (authState.authStatus) {
      case AuthStatus.emailUnVerified:
        if (currentPath == AppRoutes.verifyEmail) return null;
        return AppRoutes.verifyEmail;

      case AuthStatus.locationNotSelected:
        if (currentPath == AppRoutes.mapPicker) return null;
        return AppRoutes.mapPicker;

      case AuthStatus.profileIncomplete:
        if (currentPath == AppRoutes.completeProfile) return null;
        return AppRoutes.completeProfile;

      case AuthStatus.fullySetup:
        // لا نسمح بالعودة إلى مسارات الإعداد
        if (_setupRoutes.contains(currentPath)) return AppRoutes.home;
        return null;

      default:
        return null;
    }
  }

  String? _routeForStatus(AuthStatus status) {
    switch (status) {
      case AuthStatus.emailUnVerified:
        return AppRoutes.verifyEmail;
      case AuthStatus.locationNotSelected:
        return AppRoutes.mapPicker;
      case AuthStatus.profileIncomplete:
        return AppRoutes.completeProfile;
      case AuthStatus.fullySetup:
        return AppRoutes.home;
      default:
        return null;
    }
  }

  List<RouteBase> get _routes => [
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splash,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboarding,
      builder: (context, state) => OnBoarding(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (context, state) {
        // ✅ أولاً: لو جاء userType من pushNamed (onboarding القديم) نأخذه
        // ثانياً: لو جاء من redirect نأخذه من AuthState.selectedUserType
        // ثالثاً: fallback لـ client لو مفيش في الحالتين
        final fromExtra = state.extra is UserType
            ? state.extra as UserType
            : null;
        final fromState = context.read<AuthCubit>().state.selectedUserType;
        final userType = fromExtra ?? fromState ?? UserType.service;
        return Login(userType: userType);
      },
    ),
    GoRoute(
      path: AppRoutes.register,
      name: AppRoutes.register,
      builder: (context, state) {
        final fromExtra = state.extra is UserType
            ? state.extra as UserType
            : null;
        final fromState = context.read<AuthCubit>().state.selectedUserType;
        final userType = fromExtra ?? fromState ?? UserType.service;
        return Register(userType: userType);
      },
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: AppRoutes.forgotPassword,
      builder: (context, state) => ForgetPassword(),
    ),
    GoRoute(
      path: AppRoutes.verifyEmail,
      name: AppRoutes.verifyEmail,
      builder: (context, state) => VerifyEmail(),
    ),
    GoRoute(
      path: AppRoutes.mapPicker,
      name: AppRoutes.mapPicker,
      builder: (context, state) => LocationPickerPage(),
    ),
    GoRoute(
      path: AppRoutes.completeProfile,
      name: AppRoutes.completeProfile,
      builder: (context, state) => CompleteProfilePage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (context, state) => Home(),
    ),
  ];
}

class _ErrorPage extends StatelessWidget {
  const _ErrorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text('الصفحه غير موجوده', style: AppTypography.bodyLarge),
              AppSpacing.h_30.verticalSpace,
              AppButton(label: 'الذهاب الى الصفحه الرئيسيه'),
            ],
          ),
        ),
      ),
    );
  }
}
