import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/core/Widgets/error_page.dart';
import 'package:khedma/core/constants/app_emums.dart';
import 'package:khedma/app/routing/app_routs.dart';
import 'package:khedma/app/routing/router_notifier.dart';
import 'package:khedma/app/splash_screen.dart';
import 'package:khedma/features/Notification/presentation/screens/provider_notification.dart';
import 'package:khedma/features/Notification/presentation/screens/service_notification.dart';
import 'package:khedma/features/Profile/Presentation/screens/provider/editing_profile.dart';
import 'package:khedma/features/Profile/Presentation/screens/provider/profile_screen.dart';
import 'package:khedma/features/Services/presentation/screens/Provider/provider_home.dart';
import 'package:khedma/features/Services/presentation/screens/Provider/provider_shell.dart';
import 'package:khedma/features/Services/presentation/screens/Service/service_home.dart';
import 'package:khedma/features/Services/presentation/screens/Service/service_shell.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_state.dart';
import 'package:khedma/features/auth/presentation/screens/complete_profile_page.dart';
import 'package:khedma/features/auth/presentation/screens/forget_password.dart';
import 'package:khedma/features/auth/presentation/screens/home.dart';
import 'package:khedma/features/auth/presentation/screens/location_picker.dart';
import 'package:khedma/features/auth/presentation/screens/login.dart';
import 'package:khedma/features/auth/presentation/screens/user_role_screen.dart.dart';
import 'package:khedma/features/auth/presentation/screens/register.dart';
import 'package:khedma/features/auth/presentation/screens/verify_email.dart';
import 'package:khedma/features/chat/presentation/screens/chat_screen.dart';

class RouteConfig {
  final RouterNotifier notifier;
  RouteConfig({required this.notifier});

  late final goRouter = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    errorBuilder: (context, state) => ErrorPage(),
    routes: _routes,
    redirect: _redirect,
  );

  // المسارات العامة (لا تحتاج تسجيل دخول)
  static const _publicRoutes = {
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
    final authState = notifier.authState;
    final currentPath = state.uri.path;
    log('================ ROUTER REDIRECT ================');
    log('Current Path => $currentPath');
    log('Auth Status => ${authState.authStatus}');
    log('User Role Status => ${authState.userRoleStatus}');
    log('Is Logged In => ${authState.isLoggedIn}');
    log('=================================================');
    // إذا كانت الحالة غير معروفة (لا تزال تحميل)، لا نعيد توجيه
    if (authState.authStatus == AuthStatus.unknown ||
        authState.userRoleStatus == UserRoleStatus.unKnown) {
      return null;
    }

    // المستخدم ما زال لم يختر نوع الحساب
    if (authState.userRoleStatus == UserRoleStatus.notSelected) {
      if (currentPath == AppRoutes.userRole) return null;
      return AppRoutes.userRole;
    }

    /// منع الرجوع لشاشة اختيار النوع بعد الاختيار
    if (currentPath == AppRoutes.userRole &&
        authState.userRoleStatus == UserRoleStatus.done) {
      return authState.isLoggedIn
          ? _routeForStatus(authState, context)
          : AppRoutes.login;
    }

    // إذا لم يكن مسجل الدخول → نسمح فقط بالمسارات العامة
    if (!authState.isLoggedIn) {
      if (_publicRoutes.contains(currentPath)) return null;
      return AppRoutes.login;
    }

    // إذا كان مسجل الدخول ولكن في مسار عام → نوجهه حسب حالته
    if (_publicRoutes.contains(currentPath)) {
      return _routeForStatus(authState, context);
    }

    if (currentPath == AppRoutes.splash) {
      return _routeForStatus(authState, context);
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
        final target = _homeRoute(authState);
        if (target == currentPath) return null;
        if (_setupRoutes.contains(currentPath)) {
          return target;
        }
        return null;
      default:
        return null;
    }
  }

  String _routeForStatus(AuthState authState, BuildContext context) {
    switch (authState.authStatus) {
      // case AuthStatus.unauthenticated: //! يعتبر انى لم استخدمها الى الان نهائيا
      //   return AppRoutes
      //       .login; //? هذه انا من قمت باضافتها حاليا لم تكن مضافة من قبل كلنت ضمن ال case التى تليها
      case AuthStatus.emailUnVerified:
        return AppRoutes.verifyEmail;
      case AuthStatus.locationNotSelected:
        return AppRoutes.mapPicker;
      case AuthStatus.profileIncomplete:
        return AppRoutes.completeProfile;
      case AuthStatus.fullySetup:
        return _homeRoute(authState);
      default:
        return AppRoutes.login;
    }
  }

  String _homeRoute(AuthState authState) {
    final userType = authState.user?.userType;

    return userType == UserType.provider
        ? AppRoutes.providerHome
        : AppRoutes.serviceHome;
  }

  List<RouteBase> get _routes => [
    //? Authentication
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splash,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.userRole,
      name: AppRoutes.userRole,
      builder: (context, state) => UserRoleScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (context, state) {
        final fromExtra = state.extra is UserType
            ? state.extra as UserType
            : null;
        final fromState = notifier.authState.selectedUserType;
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
        final fromState = notifier.authState.selectedUserType;
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
    GoRoute(
      path: AppRoutes.editingProfile,
      name: AppRoutes.editingProfile,
      builder: (context, state) => EditingProfile(),
    ),

    //? Service Shell Route
    _serviceShellRoute(),

    //? Provider Shell Route
    _providerShellRoute(),
  ];

  //? Provider Shell Route

  StatefulShellRoute _providerShellRoute() {
    return StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ProviderShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: AppRoutes.providerHome,
              name: AppRoutes.providerHome,
              builder: (context, state) => ProviderHome(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: AppRoutes.providerNotifications,
              name: AppRoutes.providerNotifications,
              builder: (context, state) => ProviderNotification(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: AppRoutes.providerChat,
              name: AppRoutes.providerChat,
              builder: (context, state) => ChatScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: AppRoutes.providerProfile,
              name: AppRoutes.providerProfile,
              builder: (context, state) => ProfileScreen(),
            ),
          ],
        ),
      ],
    );
  }

  //? Service Shell Route
  StatefulShellRoute _serviceShellRoute() {
    return StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ServiceShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: AppRoutes.serviceHome,
              name: AppRoutes.serviceHome,
              builder: (context, state) => ServiceHome(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: AppRoutes.serviceNotifications,
              name: AppRoutes.serviceNotifications,
              builder: (context, state) => ServiceNotification(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: AppRoutes.serviceChat,
              name: AppRoutes.serviceChat,
              builder: (context, state) => ChatScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: AppRoutes.serviceProfile,
              name: AppRoutes.serviceProfile,
              builder: (context, state) => ProfileScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
