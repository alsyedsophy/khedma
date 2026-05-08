class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyEmail = '/verify-email';
  static const String mapPicker = '/map-picker';
  static const String completeProfile = '/complete-profile';

  static const String home = '/home';

  // Service Routes

  static const String serviceShell = '/service-shell';
  static const String serviceHome = '/service/home';
  static const String serviceNotifications = '/service/notification';
  static const String serviceChat = '/service/chat';
  static const String serviceProfile = '/service/profile';
  static const String serviceSubscription = '/service/subscription';
  static const String postService = '/service/post';
  static const String serviceApplicants = '/service/applicants';
  static const String browseProviders = '/service/browse-providers';

  // Provider Routes
  static const String providerShell = '/provider-shell';
  static const String providerHome = '/provider/home';
  static const String providerNotifications = '/provider/notification';
  static const String providerChat = '/provider/chat';
  static const String providerProfile = '/provider/profile';
  static const String providerSubscription = '/provider/subscription';
  static const String browseServices = '/provider/browse-services';
  static const String applyService = '/provider/apply';
}
